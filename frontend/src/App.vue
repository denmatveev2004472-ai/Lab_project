<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'

const API_BASE = 'http://127.0.0.1:8000'

async function api(url) {
  const r = await fetch(`${API_BASE}${url}`)
  if (!r.ok) throw new Error(await r.text())
  return r.json()
}

function qs(obj) {
  const p = new URLSearchParams()
  Object.entries(obj).forEach(([k, v]) => { if (v) p.set(k, v) })
  return p.toString()
}

const typeLabels = {
  '': 'Все',
  reagent: 'Реактивы',
  equipment: 'Оборудование',
  consumable: 'Расходники',
  furniture: 'Мебель',
  other: 'Прочее'
}

const state = reactive({ q: '', room: '', item_type: '', source_file: '' })

const items = ref([])
const stats = ref({ total: 0, by_type: [], by_room: [], by_source_file: [] })
const rooms = ref([])
const loading = ref(false)
const errorMsg = ref('')
const theme = ref('light')

function badge(type) {
  return typeLabels[type] || type || 'Прочее'
}

function place(row) {
  return [
    row.room,
    row.cabinet && `Шкаф ${row.cabinet}`,
    row.shelf && row.shelf !== '-' && `Полка ${row.shelf}`,
    row.slot && row.slot !== '-' && `Ячейка ${row.slot}`
  ].filter(Boolean).join(' · ') || '—'
}

function details(row) {
  return [
    row.inventory_number && `Инв. №: ${row.inventory_number}`,
    row.catalog_number && `Арт.: ${row.catalog_number}`,
    row.manufacturer && `Произв.: ${row.manufacturer}`,
    row.quantity && `Кол-во: ${row.quantity}${row.unit ? ' ' + row.unit : ''}`,
    row.source_file && `Источник: ${row.source_file}`
  ].filter(Boolean)
}

async function loadItems() {
  loading.value = true
  errorMsg.value = ''
  try {
    const data = await api(`/api/search?${qs(state)}`)
    items.value = data.results || []
  } catch (e) {
    errorMsg.value = String(e.message || e)
  } finally {
    loading.value = false
  }
}

async function loadStats() {
  try { stats.value = await api('/api/stats') } catch (e) { /* ignore */ }
}

async function loadRooms() {
  try { rooms.value = await api('/api/rooms') } catch (e) { /* ignore */ }
}

function resetFilters() {
  state.q = ''
  state.room = ''
  state.item_type = ''
  state.source_file = ''
}

function toggleTheme() {
  theme.value = theme.value === 'dark' ? 'light' : 'dark'
  document.documentElement.setAttribute('data-theme', theme.value)
}

let debounceTimer = null
watch(state, () => {
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(loadItems, 250)
}, { deep: true })

const sourceFiles = computed(() => stats.value.by_source_file || [])

onMounted(async () => {
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  theme.value = prefersDark ? 'dark' : 'light'
  document.documentElement.setAttribute('data-theme', theme.value)
  await Promise.all([loadItems(), loadStats(), loadRooms()])
})
</script>

<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand">
        <div class="logo">
          <svg viewBox="0 0 24 24"><path d="M9 3h6M10 3v6l-5 9a2 2 0 0 0 2 3h10a2 2 0 0 0 2-3l-5-9V3" /></svg>
        </div>
        <div>
          <h1>Lab Inventory</h1>
          <p>Каталог лаборатории</p>
        </div>
      </div>

      <button class="theme-toggle" @click="toggleTheme">
        {{ theme === 'dark' ? '☀️ Светлая тема' : '🌙 Тёмная тема' }}
      </button>

      <div class="nav-group">
        <div class="group-title">Тип</div>
        <div class="pill-grid">
          <button
            v-for="(label, key) in typeLabels"
            :key="key"
            class="pill"
            :class="{ active: state.item_type === key }"
            @click="state.item_type = key"
          >
            {{ label }}
          </button>
        </div>
      </div>

      <div class="nav-group">
        <div class="group-title">Комната</div>
        <div class="pill-grid">
          <button
            class="pill"
            :class="{ active: state.room === '' }"
            @click="state.room = ''"
          >
            Все
          </button>
          <button
            v-for="r in rooms"
            :key="r.room"
            class="pill"
            :class="{ active: state.room === r.room }"
            @click="state.room = r.room"
          >
            {{ r.room }} ({{ r.items_count }})
          </button>
        </div>
      </div>

      <div class="nav-group" v-if="sourceFiles.length">
        <div class="group-title">Источники</div>
        <div class="source-card soft-card">
          <div class="source-list">
            <div class="source-item" v-for="f in sourceFiles" :key="f.source_file">
              <span>{{ f.source_file || 'Без источника' }}</span>
              <span class="mono">{{ f.n }}</span>
            </div>
          </div>
        </div>
      </div>

      <button class="btn" @click="resetFilters">Сброс</button>
    </aside>

    <div class="workspace">
      <header class="topbar">
        <div>
          <div class="eyebrow">Каталог</div>
          <h2>Лабораторный инвентарь</h2>
        </div>
      </header>

      <main class="main">
        <section class="hero-grid">
          <div class="soft-card hero-panel">
            <div class="search-wrap">
              <input
                v-model="state.q"
                type="search"
                placeholder="Найти реактив, оборудование, расходник..."
              />
            </div>
            <p class="microcopy">
              Ищи по реактивам, расходникам, мебели, приборам, морозилкам и остаткам на складе.
            </p>
          </div>

          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-label">Всего позиций</div>
              <div class="stat-value">{{ stats.total ?? 0 }}</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">Комнат</div>
              <div class="stat-value">{{ rooms.length }}</div>
            </div>
          </div>
        </section>

        <section class="table-card">
          <div class="table-toolbar">
            <div>
              <div class="section-title">Каталог</div>
              <div class="section-subtitle">Найдено: {{ items.length }}</div>
            </div>
          </div>

          <div v-if="loading" class="muted">Загрузка…</div>
          <div v-else-if="errorMsg" class="muted">{{ errorMsg }}</div>
          <div v-else-if="!items.length" class="muted">Ничего не найдено</div>

          <div v-else class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Тип</th>
                  <th>Код / №</th>
                  <th>Название</th>
                  <th>Формула / CAS</th>
                  <th>Место</th>
                  <th>Детали</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in items" :key="row.id">
                  <td><span class="badge">{{ badge(row.item_type) }}</span></td>
                  <td class="mono">{{ row.code || row.inventory_number || '—' }}</td>
                  <td>
                    <strong>{{ row.name || row.name_ru || row.name_en || 'Без названия' }}</strong>
                  </td>
                  <td>
                    <div>{{ row.formula || '—' }}</div>
                    <div class="muted">{{ row.cas || '' }}</div>
                  </td>
                  <td>{{ place(row) }}</td>
                  <td>
                    <div class="detail-list">
                      <div v-for="(d, i) in details(row)" :key="i">{{ d }}</div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>
  </div>
</template>

<style>
:root, [data-theme="light"] {
  --font-body: 'Satoshi', 'Inter', sans-serif;
  --font-display: 'General Sans', 'Inter', sans-serif;
  --text-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
  --text-sm: clamp(0.875rem, 0.8rem + 0.35vw, 1rem);
  --text-base: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  --text-lg: clamp(1.125rem, 1rem + 0.75vw, 1.5rem);
  --text-xl: clamp(1.5rem, 1.2rem + 1.25vw, 2rem);
  --space-1: 0.25rem; --space-2: 0.5rem; --space-3: 0.75rem; --space-4: 1rem;
  --space-5: 1.25rem; --space-6: 1.5rem; --space-8: 2rem; --space-10: 2.5rem; --space-12: 3rem;
  --radius-sm: .5rem; --radius-md: .9rem; --radius-lg: 1.25rem; --radius-xl: 1.6rem;
  --color-bg: #f3f6f8;
  --color-surface: #ffffff;
  --color-surface-2: #f7fafb;
  --color-border: #d9e2e8;
  --color-text: #10222c;
  --color-text-muted: #5d6d76;
  --color-primary: #0f7c82;
  --color-primary-2: #103d5b;
  --color-accent: #9de6df;
  --shadow-sm: 0 4px 20px rgba(12, 28, 38, .07);
  --shadow-lg: 0 16px 60px rgba(12, 28, 38, .12);
}

[data-theme="dark"] {
  --color-bg: #081219;
  --color-surface: #0e1a22;
  --color-surface-2: #12212b;
  --color-border: #203746;
  --color-text: #e6f0f4;
  --color-text-muted: #8da4b1;
  --color-primary: #54c1c3;
  --color-primary-2: #3f7db1;
  --color-accent: #17323a;
  --shadow-sm: 0 4px 24px rgba(0,0,0,.28);
  --shadow-lg: 0 20px 80px rgba(0,0,0,.38);
}

* { box-sizing: border-box }
html, body { height: 100%; margin: 0; overflow: hidden }
body {
  font-family: var(--font-body);
  font-size: var(--text-base);
  background:
    radial-gradient(circle at top left, rgba(84,193,195,.12), transparent 28%),
    radial-gradient(circle at top right, rgba(63,125,177,.14), transparent 24%),
    var(--color-bg);
  color: var(--color-text);
}
button, input { font: inherit }
button { cursor: pointer }

.app-shell { display: grid; grid-template-columns: 300px 1fr; height: 100dvh }
.sidebar {
  padding: var(--space-6);
  border-right: 1px solid var(--color-border);
  background: linear-gradient(180deg, rgba(255,255,255,.03), rgba(255,255,255,.01));
  overflow: auto;
}
.workspace { display: grid; grid-template-rows: auto 1fr; min-width: 0 }
.topbar {
  display: flex; justify-content: space-between; align-items: end;
  padding: var(--space-6) var(--space-8);
  border-bottom: 1px solid var(--color-border);
  backdrop-filter: blur(14px);
  background: rgba(8,18,25,.45);
}
.main { overflow: auto; padding: var(--space-8) }
.brand { display: flex; align-items: center; gap: var(--space-4); margin-bottom: var(--space-6) }
.logo {
  width: 54px; height: 54px; border-radius: 18px;
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2));
  display: grid; place-items: center; box-shadow: var(--shadow-sm);
}
.logo svg { width: 30px; height: 30px; stroke: #fff; stroke-width: 2; fill: none }
.brand h1 { font-family: var(--font-display); font-size: 1.15rem; margin: 0 }
.brand p { margin: .2rem 0 0; color: var(--color-text-muted); font-size: var(--text-sm) }
.theme-toggle, .btn {
  border: 1px solid var(--color-border); background: var(--color-surface);
  color: var(--color-text); border-radius: 999px; padding: .7rem 1rem;
}
.theme-toggle { margin-bottom: var(--space-6); width: 100% }
.nav-group { margin-bottom: var(--space-6) }
.group-title, .eyebrow {
  font-size: var(--text-xs); letter-spacing: .08em; text-transform: uppercase;
  color: var(--color-text-muted); margin-bottom: var(--space-3);
}
.pill-grid { display: flex; flex-wrap: wrap; gap: .55rem }
.pill {
  border: 1px solid var(--color-border); background: var(--color-surface-2);
  padding: .6rem .9rem; border-radius: 999px; font-size: var(--text-sm);
}
.pill.active {
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2));
  color: white; border-color: transparent;
}
.soft-card, .glass-card, .table-card, .stat-card {
  background: linear-gradient(180deg, rgba(255,255,255,.04), rgba(255,255,255,.02));
  border: 1px solid var(--color-border); box-shadow: var(--shadow-sm);
}
.soft-card, .glass-card, .table-card { border-radius: var(--radius-xl) }
.source-card { padding: var(--space-4) }
.source-list { display: grid; gap: .7rem }
.source-item { display: flex; justify-content: space-between; font-size: var(--text-sm); color: var(--color-text-muted) }
.topbar h2 { font-family: var(--font-display); font-size: var(--text-xl); margin: .2rem 0 0 }
.hero-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: var(--space-6); margin-bottom: var(--space-6) }
.hero-panel { padding: var(--space-6); position: relative; overflow: hidden }
.hero-panel::after {
  content: ""; position: absolute; inset: auto -10% -35% auto; width: 280px; height: 280px;
  background: radial-gradient(circle, rgba(84,193,195,.22), transparent 62%); pointer-events: none;
}
.search-wrap { display: flex; gap: var(--space-3) }
input[type="search"] {
  flex: 1; padding: 1rem 1.1rem; border-radius: 18px; border: 1px solid var(--color-border);
  background: var(--color-surface); color: var(--color-text);
}
.microcopy { margin-top: var(--space-3); font-size: var(--text-sm); color: var(--color-text-muted) }
.stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: var(--space-4) }
.stat-card { padding: var(--space-5); border-radius: var(--radius-lg) }
.stat-label { font-size: var(--text-xs); text-transform: uppercase; color: var(--color-text-muted); letter-spacing: .08em }
.stat-value { font-family: var(--font-display); font-size: 1.95rem; margin-top: .35rem; font-variant-numeric: tabular-nums }
.table-card { padding: var(--space-4) }
.table-toolbar { display: flex; justify-content: space-between; align-items: end; padding: var(--space-2) var(--space-2) var(--space-4) }
.section-title { font-family: var(--font-display); font-size: var(--text-lg) }
.section-subtitle { color: var(--color-text-muted); font-size: var(--text-sm); margin-top: .2rem }
.table-wrap { overflow: auto; border-radius: 1rem }
table { width: 100%; border-collapse: collapse }
thead th {
  position: sticky; top: 0; background: rgba(12,23,31,.92); backdrop-filter: blur(10px);
  font-size: var(--text-xs); letter-spacing: .08em; text-transform: uppercase;
  color: var(--color-text-muted); text-align: left; padding: 1rem; border-bottom: 1px solid var(--color-border);
}
tbody td { padding: 1rem; border-bottom: 1px solid rgba(141,164,177,.12); vertical-align: top }
tbody tr:hover { background: rgba(84,193,195,.06) }
.badge {
  display: inline-flex; align-items: center; border-radius: 999px; padding: .38rem .65rem;
  font-size: var(--text-xs); text-transform: uppercase; letter-spacing: .08em;
  background: var(--color-accent); color: var(--color-primary);
}
.mono { font-variant-numeric: tabular-nums; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: var(--text-sm) }
.muted { color: var(--color-text-muted) }
.btn.ghost { background: transparent }
.btn.subtle { background: var(--color-surface-2) }
.detail-list { display: grid; gap: .35rem; font-size: var(--text-sm) }

@media (max-width: 1100px) {
  .app-shell { grid-template-columns: 1fr }
  .sidebar { display: none }
  .hero-grid { grid-template-columns: 1fr }
  .stats-grid { grid-template-columns: repeat(2, 1fr) }
  html, body { overflow: auto }
  .main { overflow: visible }
}
@media (max-width: 720px) {
  .topbar, .main { padding: var(--space-4) }
  .search-wrap { flex-direction: column }
  .stats-grid { grid-template-columns: 1fr }
  .topbar { align-items: start; flex-direction: column; gap: var(--space-4) }
  tbody td, thead th { padding: .8rem }
}
</style>
