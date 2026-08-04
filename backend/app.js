const state = {
  q: '',
  room: '',
  item_type: '',
  source_file: ''
};

const typeLabels = {
  '': 'Все',
  reagent: 'Реактивы',
  equipment: 'Оборудование',
  consumable: 'Расходники',
  furniture: 'Мебель',
  other: 'Прочее'
};

async function api(url) {
  const r = await fetch(url);
  if (!r.ok) throw new Error(await r.text());
  return r.json();
}

function qs(obj) {
  const p = new URLSearchParams();
  Object.entries(obj).forEach(([k, v]) => { if (v) p.set(k, v); });
  return p.toString();
}

function badge(type) {
  return `<span class="badge">${typeLabels[type] || type || 'Прочее'}</span>`;
}

function place(row) {
  return [row.room, row.cabinet && `Шкаф ${row.cabinet}`, row.shelf && row.shelf !== '-' && `Полка ${row.shelf}`, row.slot && row.slot !== '-' && `Ячейка ${row.slot}`]
    .filter(Boolean).join(' · ') || '—';
}

function details(row) {
  const bits = [
    row.inventory_number && `Инв. №: ${row.inventory_number}`,
    row.catalog_number && `Арт.: ${row.catalog_number}`,
    row.manufacturer && `Произв.: ${row.manufacturer}`,
    row.quantity && `Кол-во: ${row.quantity}${row.unit ? ' ' + row.unit : ''}`,
    row.source_file && `Источник: ${row.source_file}`,
  ].filter(Boolean);
  return bits.length ? bits.map(x => `<div>${x}</div>`).join('') : '<span class="muted">—</span>';
}

function renderRows(rows) {
  const body = document.getElementById('resultsBody');
  body.innerHTML = rows.map(row => `
    <tr>
      <td>${badge(row.item_type)}</td>
      <td><div class="mono">${row.internal_code || row.inventory_number || row.catalog_number || '—'}</div></td>
      <td>
        <div>${row.name_ru || row.name || row.name_en || '—'}</div>
        <div class="muted">${row.name_en || ''}</div>
      </td>
      <td>
        <div class="mono">${row.formula || '—'}</div>
        <div class="muted">${row.cas || '—'}</div>
      </td>
      <td>${place(row)}</td>
      <td><div class="detail-list">${details(row)}</div></td>
    </tr>
  `).join('');
}

function renderStatCards(stats, foundCount) {
  const mapType = Object.fromEntries(stats.by_type.map(x => [x.item_type, x.n]));
  const roomCount = stats.by_room.length;
  const cards = [
    ['Всего', stats.total],
    ['Найдено', foundCount],
    ['Комнат', roomCount],
    ['Реактивов', mapType.reagent || 0],
    ['Оборудование', mapType.equipment || 0],
    ['Расходники', mapType.consumable || 0],
  ];
  document.getElementById('statCards').innerHTML = cards.map(([label, value]) => `
    <div class="stat-card">
      <div class="stat-label">${label}</div>
      <div class="stat-value">${value}</div>
    </div>
  `).join('');
}

function renderRoomFilters(rooms) {
  const root = document.getElementById('roomFilters');
  const items = [{ room: '', items_count: rooms.reduce((a, b) => a + b.items_count, 0), label: 'Все комнаты' }, ...rooms.map(r => ({...r, label: `Комната ${r.room}`}))];
  root.innerHTML = items.map(r => `<button class="pill ${state.room === r.room ? 'active' : ''}" data-room="${r.room}">${r.label}</button>`).join('');
  root.querySelectorAll('[data-room]').forEach(btn => btn.onclick = () => { state.room = btn.dataset.room; loadAll(); });
}

function renderTypeFilters() {
  const root = document.getElementById('typeFilters');
  root.innerHTML = Object.entries(typeLabels).map(([key, label]) => `<button class="pill ${state.item_type === key ? 'active' : ''}" data-type="${key}">${label}</button>`).join('');
  root.querySelectorAll('[data-type]').forEach(btn => btn.onclick = () => { state.item_type = btn.dataset.type; loadAll(); });
}

function renderSources(stats) {
  const root = document.getElementById('sourceStats');
  root.innerHTML = stats.by_source_file.map(x => `<button class="source-item pill ${state.source_file === (x.source_file || '') ? 'active' : ''}" data-source="${x.source_file || ''}"><span>${x.source_file || 'Без файла'}</span><span>${x.n}</span></button>`).join('');
  root.querySelectorAll('[data-source]').forEach(btn => btn.onclick = () => { state.source_file = btn.dataset.source === state.source_file ? '' : btn.dataset.source; loadAll(); });
}

async function loadAll() {
  try {
    const [stats, rooms, results] = await Promise.all([
      api('/api/stats'),
      api('/api/rooms'),
      api('/api/search?' + qs(state)),
    ]);
    renderTypeFilters();
    renderRoomFilters(rooms);
    renderSources(stats);
    renderStatCards(stats, results.count);
    renderRows(results.results);
    document.getElementById('resultMeta').textContent = `Найдено: ${results.count}`;
  } catch (e) {
    document.getElementById('resultMeta').textContent = 'Ошибка загрузки';
    document.getElementById('resultsBody').innerHTML = `<tr><td colspan="6" class="muted">${String(e)}</td></tr>`;
  }
}

(function initTheme(){
  const root = document.documentElement;
  const btn = document.querySelector('[data-theme-toggle]');
  let theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  root.setAttribute('data-theme', theme);
  btn.addEventListener('click', () => {
    theme = theme === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', theme);
  });
})();

document.getElementById('searchInput').addEventListener('input', (e) => {
  state.q = e.target.value.trim();
  clearTimeout(window.__labTimer);
  window.__labTimer = setTimeout(loadAll, 250);
});
document.getElementById('refreshBtn').onclick = loadAll;
document.getElementById('clearBtn').onclick = () => {
  state.q = ''; state.room = ''; state.item_type = ''; state.source_file = '';
  document.getElementById('searchInput').value = '';
  loadAll();
};
loadAll();
