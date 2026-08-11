<!-- App.vue — Лаборатория нано- и микрокапсулирования -->
<script setup>
import { ref, reactive, onMounted, onUnmounted, watch, computed } from 'vue'

const API_BASE = import.meta.env.DEV ? 'http://192.168.1.120:8000' : window.location.origin

async function api(url, options) {
  const r = await fetch(`${API_BASE}${url}`, options)
  if (!r.ok) throw new Error(await r.text())
  return r.json()
}

async function download(url, filename) {
  const r = await fetch(`${API_BASE}${url}`)
  if (!r.ok) throw new Error(await r.text())
  const blob = await r.blob()
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = filename
  link.click()
  URL.revokeObjectURL(link.href)
}

function qs(obj) {
  const p = new URLSearchParams()
  Object.entries(obj).forEach(([k, v]) => {
    if (v !== null && v !== undefined && String(v) !== '') p.set(k, v)
  })
  return p.toString()
}

function asText(v) {
  if (v === null || v === undefined) return ''
  return String(v)
}

function normalizedText(v) {
  return asText(v).trim()
}

function readStorage(key, fallback) {
  try {
    const raw = localStorage.getItem(key)
    return raw ? JSON.parse(raw) : fallback
  } catch {
    return fallback
  }
}

function writeStorage(key, value) {
  localStorage.setItem(key, JSON.stringify(value))
}

const language = ref(readStorage('labLanguage', 'ru'))
watch(language, v => writeStorage('labLanguage', v))

const i18n = {
  ru: {
    all: 'Все',
    reagents: 'Реактивы',
    equipment: 'Оборудование',
    consumables: 'Расходники',
    protocols: 'Протоколы синтезов',
    booking: 'Расписание приборов',
    bookingShort: 'Расписание',
    other: 'Прочее',
    furniture: 'Мебель',
    section: 'Раздел',
    room: 'Комната',
    reset: 'Сброс',
    clear: 'Очистить',
    catalog: 'Каталог',
    totalItems: 'Всего позиций',
    totalProtocols: 'Протоколов',
    itemsShort: 'Позиций',
    protocolsShort: 'Протоколов',
    add: 'Добавить',
    addWhat: 'Что добавить?',
    currentPlace: 'Текущее место',
    placeNotSet: 'Место не задано — можно указать в форме',
    labTitle: 'Лаборатория нано- и микрокапсулирования биологически активных веществ',
    labSubtitle: 'Каталог лаборатории',
    mobileSubtitle: 'Лаборатории нано- и микрокапсулирования биологически активных веществ',
    loginTitle: 'Вход администратора',
    login: 'Логин',
    password: 'Пароль',
    loginButton: 'Войти',
    loginError: 'Неверный логин или пароль',
    adminOn: 'Администратор: ВКЛ',
    adminOff: 'Войти как администратор',
    adminHint: 'Логин: admin · Пароль: admin',
    searchItems: 'Найти реактив, оборудование, расходник...',
    searchProtocols: 'Найти протокол синтеза...',
    found: 'Найдено',
    loading: 'Загрузка…',
    nothingFound: 'Ничего не найдено',
    codeNumber: 'Код / №',
    name: 'Название',
    formulaCas: 'Формула / CAS',
    documents: 'Документы',
    place: 'Место',
    details: 'Детали',
    noName: 'Без названия',
    codeShort: 'Код/№:',
    formulaShort: 'Формула:',
    document: 'Документ',
    drive: 'Google Drive',
    edit: 'Редактировать',
    remove: 'Удалить',
    addItem: 'Добавить позицию',
    editItem: 'Редактировать позицию',
    type: 'Тип',
    nameRequired: 'Название *',
    nameRu: 'Название (рус.)',
    nameEn: 'Название (англ.)',
    formula: 'Формула',
    cas: 'CAS №',
    manufacturer: 'Производитель',
    catalogNumber: 'Каталожный №',
    inventoryNumber: 'Инвентарный №',
    serialNumber: 'Заводской №',
    quantity: 'Количество',
    unit: 'Единица',
    documentUrl: 'Ссылка на документ',
    gdriveLink: 'Ссылка на Google Drive',
    notes: 'Примечание',
    location: 'Местоположение',
    roomField: 'Комната',
    cabinet: 'Шкаф',
    shelf: 'Полка',
    slot: 'Ячейка',
    cancel: 'Отмена',
    save: 'Сохранить',
    saving: 'Сохранение…',
    itemNameRequired: 'Укажите название позиции',
    protocolNameRequired: 'Укажите название протокола',
    deleteError: 'Ошибка удаления',
    protocolEdit: 'Редактировать протокол',
    protocolAdd: 'Добавить протокол',
    code: 'Код',
    category: 'Категория',
    synthesisSteps: 'Этапы синтеза',
    reagentOne: 'Реактив',
    consumableOne: 'Расходник',
    equipmentOne: 'Оборудование',
    otherOne: 'Прочее',
    addProtocol: 'Добавить протокол синтеза',
    back: 'Назад',
    inventoryPrefix: 'Инв. №',
    articlePrefix: 'Арт.',
    manufacturerPrefix: 'Произв.',
    quantityPrefix: 'Кол-во',
    desktopSearchTitle: 'Поиск',
    recentSearches: 'Последние поиски',
    recentAdds: 'Последние добавления',
    dbLastUpdate: 'Последнее обновление базы данных',
    noRecentData: 'Пока нет данных',
    repeatLast: 'Последнее',
    saveErrorPrefix: 'Ошибка сохранения',
    duplicateLast3: 'Последние 3',
    databaseLog: 'Журнал базы',
    bookingTitle: 'Расписание приборов',
    bookingSubtitle: 'Бронирование аналитического оборудования',
    thisWeek: 'Эта неделя',
    nextWeek: 'Следующая неделя',
    bookSlot: 'Забронировать',
    bookingDate: 'Дата',
    bookingWho: 'Кто бронирует',
    bookingExp: 'Эксперимент / задача',
    bookingDuration: 'Продолжительность',
    bookingComments: 'Комментарии',
    bookingAdd: 'Добавить запись',
    bookingEdit: 'Редактировать запись',
    bookingConfirm: 'Забронировать',
    bookingCancel: 'Отмена',
    bookingDelete: 'Удалить',
    bookingOperProtocol: 'Протокол эксплуатации',
    bookingPostProcess: 'Обработка результатов',
    bookingExamples: 'Примеры статей',
    bookingStatus: 'Статус прибора',
    bookingStatusOk: 'Исправен, доступен',
    bookingStatusMaint: 'Техническое обслуживание',
    bookingMaintReason: 'Причина/Комментарий администратора',
    bookingUnavailDates: 'Даты ТО (нажмите для выбора)',
    bookingSetStatus: 'Установить статус',
    bookingUnavailDay: 'Этот день недоступен — прибор на техобслуживании',
    bookingConflict: 'На это время уже есть запись. Выберите другое время.',
    bookingNameRequired: 'Укажите своё имя',
    bookingExpRequired: 'Укажите эксперимент',
    bookingDateRequired: 'Выберите дату',
    selectInstrument: 'Выберите прибор',
    instrFTIR: 'ИК-спектроскопия (FTIR)',
    instrTGA: 'Термогравиметрия (TGA)',
    instrDLS: 'Динамическое светорассеяние (DLS)',
    instrOptMicro: 'Оптический микроскоп',
    instrConfocal: 'Конфокальный микроскоп',
    instrBeNano: 'Динамическое светорассеяние (BeNano)',
    noBookings: 'Записей нет — нажмите «Забронировать»',
    bookingYou: 'Вы',
    dur30: '30 мин',
    dur60: '1 час',
    dur90: '1,5 часа',
    dur120: '2 часа',
    dur180: '3 часа',
    dur240: '4+ часа',
    adminPanel: 'Панель администратора',
    bookingMaintAlert: 'находится на техническом обслуживании',
    maintSelectDates: 'Выберите даты техобслуживания (нажмите для выбора/снятия)',
    noEquipmentMatch: 'Прибор не найден в базе оборудования',
    experiments: 'Обработка экспериментов',
    experimentsShort: 'Эксперименты',
    alamarBlue: 'Alamar Blue',
    release: 'Release / Загрузка',
    dls: 'DLS (скоро)',
    uploadFile: 'Загрузить файл',
    process: 'Обработать',
    downloadExcel: 'Скачать Excel',
    cellCulture: 'Клеточная культура',
    cellCultureSubtitle: 'Бронирование боксов клеточной культуры',
    cellBox: 'Бокс',
    confirmConflictTitle: 'Конфликт времени',
    confirmConflictText: 'На это время уже есть запись: {who} — {exp}. Пересечься?',
    confirmAnyway: 'Всё равно забронировать',
    cancelAnyway: 'Отмена',
    processing: 'Обработка…',
    processError: 'Ошибка обработки',
    results: 'Результаты',
    sample: 'Образец',
    mean: 'Среднее',
    std: 'Стд.откл.',
    viability: 'Жизнеспособность, %',
    releaseProfile: 'Профиль релиза',
    timeH: 'Время, ч',
    percentRelease: '% релиза',
    cumulativeRelease: 'Кумулятивный релиз',
    loadingBlock: 'Загрузка',
    encapsulationEff: 'Эффективность загрузки',
  },
  en: {
    all: 'All',
    reagents: 'Reagents',
    equipment: 'Equipment',
    consumables: 'Consumables',
    protocols: 'Synthesis protocols',
    booking: 'Instrument Schedule',
    bookingShort: 'Schedule',
    other: 'Other',
    furniture: 'Furniture',
    section: 'Section',
    room: 'Room',
    reset: 'Reset',
    clear: 'Clear',
    catalog: 'Catalog',
    totalItems: 'Total items',
    totalProtocols: 'Protocols',
    itemsShort: 'Items',
    protocolsShort: 'Protocols',
    add: 'Add',
    addWhat: 'What to add?',
    currentPlace: 'Current location',
    placeNotSet: 'Location is not set — you can specify it in the form',
    labTitle: 'Laboratory of Nano- and Microencapsulation of Biologically Active Substances',
    labSubtitle: 'Laboratory catalog',
    mobileSubtitle: 'of the Laboratory of Nano- and Microencapsulation of Biologically Active Substances',
    loginTitle: 'Admin login',
    login: 'Login',
    password: 'Password',
    loginButton: 'Login',
    loginError: 'Wrong login or password',
    adminOn: 'Administrator: ON',
    adminOff: 'Login as administrator',
    adminHint: 'Login: admin · Password: admin',
    searchItems: 'Search reagent, equipment, consumable...',
    searchProtocols: 'Search synthesis protocol...',
    found: 'Found',
    loading: 'Loading…',
    nothingFound: 'Nothing found',
    codeNumber: 'Code / No.',
    name: 'Name',
    formulaCas: 'Formula / CAS',
    documents: 'Documents',
    place: 'Location',
    details: 'Details',
    noName: 'Untitled',
    codeShort: 'Code/No.:',
    formulaShort: 'Formula:',
    document: 'Document',
    drive: 'Google Drive',
    edit: 'Edit',
    remove: 'Delete',
    addItem: 'Add item',
    editItem: 'Edit item',
    type: 'Type',
    nameRequired: 'Name *',
    nameRu: 'Name (RU)',
    nameEn: 'Name (EN)',
    formula: 'Formula',
    cas: 'CAS No.',
    manufacturer: 'Manufacturer',
    catalogNumber: 'Catalog No.',
    inventoryNumber: 'Inventory No.',
    serialNumber: 'Serial No.',
    quantity: 'Quantity',
    unit: 'Unit',
    documentUrl: 'Document link',
    gdriveLink: 'Google Drive link',
    notes: 'Notes',
    location: 'Location',
    roomField: 'Room',
    cabinet: 'Cabinet',
    shelf: 'Shelf',
    slot: 'Slot',
    cancel: 'Cancel',
    save: 'Save',
    saving: 'Saving…',
    itemNameRequired: 'Enter item name',
    protocolNameRequired: 'Enter protocol name',
    deleteError: 'Delete error',
    protocolEdit: 'Edit protocol',
    protocolAdd: 'Add protocol',
    code: 'Code',
    category: 'Category',
    synthesisSteps: 'Synthesis steps',
    reagentOne: 'Reagent',
    consumableOne: 'Consumable',
    equipmentOne: 'Equipment',
    otherOne: 'Other',
    addProtocol: 'Add synthesis protocol',
    back: 'Back',
    inventoryPrefix: 'Inv. No.',
    articlePrefix: 'Cat. No.',
    manufacturerPrefix: 'Mfr.',
    quantityPrefix: 'Qty',
    desktopSearchTitle: 'Search',
    recentSearches: 'Recent searches',
    recentAdds: 'Recent additions',
    dbLastUpdate: 'Latest database update',
    noRecentData: 'No data yet',
    repeatLast: 'Last',
    saveErrorPrefix: 'Save error',
    duplicateLast3: 'Last 3',
    databaseLog: 'Database log',
    bookingTitle: 'Instrument Schedule',
    bookingSubtitle: 'Booking of analytical equipment',
    thisWeek: 'This week',
    nextWeek: 'Next week',
    bookSlot: 'Book',
    bookingDate: 'Date',
    bookingWho: 'Your name',
    bookingExp: 'Experiment / task',
    bookingDuration: 'Duration',
    bookingComments: 'Comments',
    bookingAdd: 'Add booking',
    bookingEdit: 'Edit booking',
    bookingConfirm: 'Confirm booking',
    bookingCancel: 'Cancel',
    bookingDelete: 'Delete',
    bookingOperProtocol: 'Operation protocol',
    bookingPostProcess: 'Data processing',
    bookingExamples: 'Example articles',
    bookingStatus: 'Instrument status',
    bookingStatusOk: 'Operational',
    bookingStatusMaint: 'Maintenance',
    bookingMaintReason: 'Reason / Admin comment',
    bookingUnavailDates: 'Maint. dates (click to select)',
    bookingSetStatus: 'Set status',
    bookingUnavailDay: 'This day is unavailable — instrument under maintenance',
    bookingConflict: 'This time slot is already taken. Please choose another.',
    bookingNameRequired: 'Enter your name',
    bookingExpRequired: 'Enter experiment description',
    bookingDateRequired: 'Select a date',
    selectInstrument: 'Select instrument',
    instrFTIR: 'IR Spectroscopy (FTIR)',
    instrTGA: 'Thermogravimetry (TGA)',
    instrDLS: 'Dynamic Light Scattering (DLS)',
    instrOptMicro: 'Optical Microscope',
    instrConfocal: 'Confocal Microscope',
    instrBeNano: 'Dynamic Light Scattering (BeNano)',
    noBookings: 'No bookings yet — click "Book"',
    bookingYou: 'You',
    dur30: '30 min',
    dur60: '1 hour',
    dur90: '1.5 hours',
    dur120: '2 hours',
    dur180: '3 hours',
    dur240: '4+ hours',
    adminPanel: 'Admin panel',
    bookingMaintAlert: 'is under maintenance',
    maintSelectDates: 'Select maintenance dates (click to toggle)',
    noEquipmentMatch: 'Instrument not found in equipment database',
    experiments: 'Experiment Processing',
    experimentsShort: 'Experiments',
    alamarBlue: 'Alamar Blue',
    release: 'Release / Loading',
    dls: 'DLS (soon)',
    uploadFile: 'Upload file',
    process: 'Process',
    downloadExcel: 'Download Excel',
    cellCulture: 'Cell culture',
    cellCultureSubtitle: 'Cell culture box booking',
    cellBox: 'Box',
    confirmConflictTitle: 'Time conflict',
    confirmConflictText: 'This slot overlaps with: {who} — {exp}. Book anyway?',
    confirmAnyway: 'Book anyway',
    cancelAnyway: 'Cancel',
    processing: 'Processing…',
    processError: 'Processing error',
    results: 'Results',
    sample: 'Sample',
    mean: 'Mean',
    std: 'Std.dev.',
    viability: 'Viability, %',
    releaseProfile: 'Release profile',
    timeH: 'Time, h',
    percentRelease: '% release',
    cumulativeRelease: 'Cumulative release',
    loadingBlock: 'Loading',
    encapsulationEff: 'Encapsulation efficiency',
  }
}

function t(key) {
  return i18n[language.value]?.[key] || key
}

const RECENT_SEARCHES_KEY = 'labRecentSearches'
const RECENT_ADDS_KEY = 'labRecentAdds'
const ADMIN_STATE_KEY = 'labAdminState'
const LAST_ADD_TEMPLATES_KEY = 'labLastAddTemplates'
const MAX_RECENT = 3

function nowLabel() {
  return new Date().toLocaleString(language.value === 'ru' ? 'ru-RU' : 'en-GB')
}

const isMobile = ref(window.innerWidth <= 900)
function updateIsMobile() {
  isMobile.value = window.innerWidth <= 900
}
window.addEventListener('resize', updateIsMobile)
window.addEventListener('orientationchange', updateIsMobile)
onUnmounted(() => {
  window.removeEventListener('resize', updateIsMobile)
  window.removeEventListener('orientationchange', updateIsMobile)
})

const mobileScreen = ref('home')
function goMobileHome() { mobileScreen.value = 'home' }
function goMobileCatalog(tab) {
  activeTab.value = tab
  mobileScreen.value = 'catalog'
  if (tab === 'protocols') loadProtocols()
  else if (tab === 'booking') { loadBookingData() }
  else if (tab === 'experiments') { /* nothing to load */ }
  else { state.item_type = tab; loadItems() }
}
function goMobileAddChoice() {
  if (!isAdmin.value) { openLoginModal(() => { mobileScreen.value = 'addChoice' }); return }
  mobileScreen.value = 'addChoice'
}

const activeTab = ref('reagent')
function setTab(tab) {
  activeTab.value = tab
  if (tab === 'protocols') loadProtocols()
  else if (tab === 'booking') { loadBookingData() }
  else if (tab === 'experiments') { /* nothing to load */ }
  else { state.item_type = tab; loadItems() }
}

const state = reactive({ q: '', room: '', cabinet: '', item_type: 'reagent', source_file: '' })

const items = ref([])
const stats = ref({ total: 0, protocols_total: 0, by_type: [], by_room: [], by_source_file: [] })
const rooms = ref([])
const cabinets = ref([])
const expandedRoom = ref('')
const currentLocation = ref(readStorage('currentLocation', null))
const loading = ref(false)
const errorMsg = ref('')
const theme = ref(readStorage('labTheme', 'light'))

const protocols = ref([])
const protocolCategories = ref([])
const protocolQuery = ref('')
const protocolCategory = ref('')

const isAdmin = ref(readStorage(ADMIN_STATE_KEY, false))
watch(isAdmin, v => writeStorage(ADMIN_STATE_KEY, v))

const ADMIN_LOGIN = 'admin'
const ADMIN_PASSWORD = 'admin'

const showLoginModal = ref(false)
const loginForm = reactive({ login: '', password: '' })
const loginError = ref('')
const pendingAdminAction = ref(null)

function openLoginModal(action = null) {
  loginForm.login = ''; loginForm.password = ''; loginError.value = ''
  pendingAdminAction.value = action; showLoginModal.value = true
}
function closeLoginModal() {
  showLoginModal.value = false; loginError.value = ''; pendingAdminAction.value = null
}
function submitLogin() {
  if (loginForm.login === ADMIN_LOGIN && loginForm.password === ADMIN_PASSWORD) {
    isAdmin.value = true; showLoginModal.value = false; loginError.value = ''
    const action = pendingAdminAction.value; pendingAdminAction.value = null
    if (typeof action === 'function') action()
  } else { loginError.value = t('loginError') }
}
function logoutAdmin() { isAdmin.value = false }

function place(row) {
  return [
    row.room,
    row.cabinet && row.cabinet !== '-' && `${row.cabinet}`,
    row.shelf && row.shelf !== '-' && `${row.shelf}`,
    row.slot && row.slot !== '-' && `${row.slot}`
  ].filter(Boolean).join(' · ') || '—'
}

function details(row) {
  return [
    row.inventory_number && `${t('inventoryPrefix')}: ${row.inventory_number}`,
    row.catalog_number && `${t('articlePrefix')}: ${row.catalog_number}`,
    row.manufacturer && `${t('manufacturerPrefix')}: ${row.manufacturer}`,
    row.quantity && `${t('quantityPrefix')}: ${row.quantity}${row.unit ? ' ' + row.unit : ''}`
  ].filter(Boolean)
}

function countByType(type) {
  const row = (stats.value.by_type || []).find(x => x.item_type === type)
  return row?.n ?? 0
}

const filteredRooms = computed(() =>
  (rooms.value || []).filter(r => normalizedText(r.room) && Number(r.items_count || 0) > 0)
)
const filteredCabinets = computed(() =>
  (cabinets.value || []).filter(c => normalizedText(c.cabinet) && Number(c.items_count || 0) > 0)
)
const currentTabLabel = computed(() => {
  if (activeTab.value === 'protocols') return t('protocols')
  if (activeTab.value === 'equipment') return t('equipment')
  if (activeTab.value === 'consumable') return t('consumables')
  if (activeTab.value === 'booking') return t('booking')
  if (activeTab.value === 'experiments') return t('experiments')
  return t('reagents')
})

async function loadItems() {
  loading.value = true; errorMsg.value = ''
  try { const data = await api(`/api/search?${qs(state)}`); items.value = data.results || [] }
  catch (e) { errorMsg.value = String(e.message || e) }
  finally { loading.value = false }
}
async function loadProtocols() {
  loading.value = true; errorMsg.value = ''
  try { protocols.value = await api(`/api/protocols?${qs({ q: protocolQuery.value, category: protocolCategory.value })}`) }
  catch (e) { errorMsg.value = String(e.message || e) }
  finally { loading.value = false }
}
async function loadProtocolCategories() {
  try { protocolCategories.value = await api('/api/protocols/categories') } catch {}
}
let protocolDebounce = null
watch([protocolQuery, protocolCategory], () => {
  clearTimeout(protocolDebounce)
  protocolDebounce = setTimeout(() => { saveRecentSearch(protocolQuery.value, 'protocols'); loadProtocols() }, 250)
})
async function loadStats() {
  try { stats.value = await api('/api/stats') } catch {}
}
async function loadRooms() {
  try { rooms.value = await api('/api/rooms') } catch {}
}
async function loadCabinets(room) {
  try { cabinets.value = await api(`/api/locations/summary?room=${encodeURIComponent(room)}`) }
  catch { cabinets.value = [] }
}
function toggleRoom(room) {
  if (expandedRoom.value === room) { expandedRoom.value = ''; cabinets.value = []; state.room = ''; state.cabinet = '' }
  else { expandedRoom.value = room; state.room = room; state.cabinet = ''; loadCabinets(room) }
}
function selectCabinet(cabinet) { state.cabinet = state.cabinet === cabinet ? '' : cabinet }
function resetFilters() { state.q = ''; state.room = ''; state.cabinet = ''; state.source_file = ''; expandedRoom.value = ''; cabinets.value = [] }
function toggleTheme() {
  theme.value = theme.value === 'dark' ? 'light' : 'dark'
  document.documentElement.setAttribute('data-theme', theme.value)
  writeStorage('labTheme', theme.value)
}

const recentSearches = ref(readStorage(RECENT_SEARCHES_KEY, []))
const recentAdds = ref(readStorage(RECENT_ADDS_KEY, []))
const siteUpdates = ref([])
const lastAddTemplates = ref(readStorage(LAST_ADD_TEMPLATES_KEY, []))

function pushRecent(listRef, key, entry, max = MAX_RECENT) {
  const next = [entry, ...listRef.value].slice(0, max)
  listRef.value = next; writeStorage(key, next)
}
function saveRecentSearch(query, section) {
  const q = normalizedText(query); if (!q) return
  const withoutSame = recentSearches.value.filter(x => !(x.q === q && x.section === section))
  const next = [{ q, section, time: nowLabel() }, ...withoutSame].slice(0, MAX_RECENT)
  recentSearches.value = next; writeStorage(RECENT_SEARCHES_KEY, next)
}
function saveRecentAdd(entry) {
  pushRecent(recentAdds, RECENT_ADDS_KEY, { ...entry, time: nowLabel() })
}
function openRecentSearch(entry) {
  if (!entry) return
  if (entry.section === 'protocols') {
    activeTab.value = 'protocols'; protocolQuery.value = entry.q
    if (isMobile.value) mobileScreen.value = 'catalog'; loadProtocols()
  } else {
    activeTab.value = entry.section || 'reagent'; state.item_type = activeTab.value; state.q = entry.q
    if (isMobile.value) mobileScreen.value = 'catalog'; loadItems()
  }
}
let debounceTimer = null
watch(() => ({ ...state }), () => {
  if (activeTab.value === 'protocols' || activeTab.value === 'booking' || activeTab.value === 'experiments') return
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    saveRecentSearch(state.q || [state.room, state.cabinet].filter(Boolean).join(' '), activeTab.value)
    loadItems()
  }, 250)
}, { deep: true })

async function loadActivityLog() {
  try {
    const data = await api('/api/activity?period=week&limit=100')
    siteUpdates.value = (data.results || []).map(r => ({
      action: r.action,
      name: r.name || '—',
      place: r.details || '—',
      time: new Date(r.created_at).toLocaleString(language.value === 'ru' ? 'ru-RU' : 'en-GB')
    }))
  } catch (e) { siteUpdates.value = [] }
}

onMounted(async () => {
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  if (!readStorage('labTheme', null)) theme.value = prefersDark ? 'dark' : 'light'
  document.documentElement.setAttribute('data-theme', theme.value)
  await Promise.all([loadItems(), loadStats(), loadRooms(), loadProtocolCategories()])
  await loadActivityLog()
})

// ─── Items CRUD ──────────────────────────────────────────────────────────────
const showAddModal = ref(false)
const addSaving = ref(false)
const addError = ref('')
const editingItemId = ref(null)
const showDatabaseModal = ref(false)

const addForm = reactive({
  item_type: 'reagent', name: '', name_ru: '', name_en: '', formula: '', cas: '',
  manufacturer: '', catalog_number: '', inventory_number: '', serial_number: '',
  quantity: '', unit: '', notes: '', document_url: '', gdrive_link: '',
  room: '', cabinet: '', shelf: '', slot: ''
})

function createEmptyAddForm(forceType = '') {
  return {
    item_type: forceType || (
      activeTab.value === 'equipment' ? 'equipment' :
      activeTab.value === 'consumable' ? 'consumable' : 'reagent'
    ),
    name: '', name_ru: '', name_en: '', formula: '', cas: '', manufacturer: '',
    catalog_number: '', inventory_number: '', serial_number: '', quantity: '',
    unit: '', notes: '', document_url: '', gdrive_link: '', room: '', cabinet: '', shelf: '', slot: ''
  }
}

function openAddModal(forceType) {
  if (!isAdmin.value) { openLoginModal(() => openAddModal(forceType)); return }
  editingItemId.value = null; Object.assign(addForm, createEmptyAddForm(forceType))
  addError.value = ''; showAddModal.value = true
}
function openEditModal(row) {
  if (!isAdmin.value) { openLoginModal(() => openEditModal(row)); return }
  editingItemId.value = row.id
  Object.assign(addForm, {
    item_type: row.item_type || 'reagent', name: row.name || '', name_ru: row.name_ru || '',
    name_en: row.name_en || '', formula: row.formula || '', cas: row.cas || '',
    manufacturer: row.manufacturer || '', catalog_number: row.catalog_number || '',
    inventory_number: row.inventory_number || '', serial_number: row.serial_number || '',
    quantity: row.quantity ?? '', unit: row.unit || '', notes: row.notes || '',
    document_url: row.document_url || '', gdrive_link: row.gdrive_link || '',
    room: row.room || '',
    cabinet: row.cabinet && row.cabinet !== '-' ? row.cabinet : '',
    shelf: row.shelf && row.shelf !== '-' ? row.shelf : '',
    slot: row.slot && row.slot !== '-' ? row.slot : ''
  })
  addError.value = ''; showAddModal.value = true
}
function closeAddModal() { showAddModal.value = false; editingItemId.value = null }
function toPayload() {
  return {
    item_type: addForm.item_type,
    name: normalizedText(addForm.name),
    name_ru: normalizedText(addForm.name_ru) || null,
    name_en: normalizedText(addForm.name_en) || null,
    formula: normalizedText(addForm.formula) || null,
    cas: normalizedText(addForm.cas) || null,
    manufacturer: normalizedText(addForm.manufacturer) || null,
    catalog_number: normalizedText(addForm.catalog_number) || null,
    inventory_number: normalizedText(addForm.inventory_number) || null,
    serial_number: normalizedText(addForm.serial_number) || null,
    quantity: normalizedText(addForm.quantity) || null,
    unit: normalizedText(addForm.unit) || null,
    notes: normalizedText(addForm.notes) || null,
    document_url: normalizedText(addForm.document_url) || null,
    gdrive_link: normalizedText(addForm.gdrive_link) || null
  }
}
function saveTemplateFromPayload(payload, location) {
  const entry = { ...payload, room: location.room || '', cabinet: location.cabinet || '',
    shelf: location.shelf || '', slot: location.slot || '', time: nowLabel() }
  const next = [entry, ...lastAddTemplates.value].slice(0, 3)
  lastAddTemplates.value = next; writeStorage(LAST_ADD_TEMPLATES_KEY, next)
}
function applyTemplate(template) {
  if (!template) return
  Object.assign(addForm, {
    item_type: template.item_type || 'reagent', name: template.name || '',
    name_ru: template.name_ru || '', name_en: template.name_en || '',
    formula: template.formula || '', cas: template.cas || '',
    manufacturer: template.manufacturer || '', catalog_number: template.catalog_number || '',
    inventory_number: template.inventory_number || '', serial_number: template.serial_number || '',
    quantity: template.quantity ?? '', unit: template.unit || '', notes: template.notes || '',
    document_url: template.document_url || '', gdrive_link: template.gdrive_link || '',
    room: template.room || '', cabinet: template.cabinet || '',
    shelf: template.shelf || '', slot: template.slot || ''
  })
}
async function submitAddForm() {
  if (!normalizedText(addForm.name)) { addError.value = t('itemNameRequired'); return }
  addSaving.value = true; addError.value = ''
  try {
    let location_id = null
    const roomValue = normalizedText(addForm.room)
    const cabinetValue = normalizedText(addForm.cabinet)
    const shelfValue = normalizedText(addForm.shelf)
    const slotValue = normalizedText(addForm.slot)
    if (roomValue) {
      const loc = await api('/api/locations', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ room: roomValue, cabinet: cabinetValue || null, shelf: shelfValue || null, slot: slotValue || null })
      })
      location_id = loc.id
      currentLocation.value = { room: roomValue, cabinet: cabinetValue || '', shelf: shelfValue || '', slot: slotValue || '' }
      writeStorage('currentLocation', currentLocation.value)
    }
    const payload = { ...toPayload(), location_id }
    if (editingItemId.value) {
      await api(`/api/item/${editingItemId.value}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) })
    } else {
      await api('/api/item', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) })
      saveRecentAdd({ name: payload.name || payload.formula || payload.inventory_number || '—', type: payload.item_type,
        place: [roomValue, cabinetValue, shelfValue, slotValue].filter(Boolean).join(' · ') || '—' })
      saveTemplateFromPayload(payload, { room: roomValue, cabinet: cabinetValue, shelf: shelfValue, slot: slotValue })
    }
    showAddModal.value = false; editingItemId.value = null
    await Promise.all([loadItems(), loadStats(), loadRooms()])
    await loadActivityLog()
  } catch (e) { addError.value = `${t('saveErrorPrefix')}: ${String(e.message || e)}` }
  finally { addSaving.value = false }
}
const expandedNames = ref(new Set())
function toggleNameExpand(id) {
  const next = new Set(expandedNames.value)
  if (next.has(id)) next.delete(id)
  else next.add(id)
  expandedNames.value = next
}
function isLongName(row) {
  const name = row.name || row.name_ru || row.name_en || ''
  return name.length > 28
}
function stockLevel(row) {
  const q = parseFloat(row.quantity)
  if (!Number.isFinite(q)) return 'normal'
  if (q <= 0) return 'empty'
  if (q <= 2) return 'low'
  return 'normal'
}
async function changeQuantity(row, delta) {
  const current = parseFloat(row.quantity) || 0
  const next = Math.max(0, current + delta)
  try {
    await api(`/api/item/${row.id}`, {
      method: 'PATCH', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ quantity: String(next) })
    })
    const idx = items.value.findIndex(i => i.id === row.id)
    if (idx !== -1) items.value[idx] = { ...items.value[idx], quantity: String(next) }
  } catch (e) { alert('Ошибка: ' + (e.message || e)) }
}

async function deleteItem(row) {
  if (!isAdmin.value) { openLoginModal(() => deleteItem(row)); return }
  if (!confirm(`Удалить позицию "${row.name || row.name_ru || row.name_en || ''}"?`)) return
  try {
    await api(`/api/item/${row.id}`, { method: 'DELETE' })
    await Promise.all([loadItems(), loadStats(), loadRooms()])
    await loadActivityLog()
  } catch (e) { alert(`${t('deleteError')}: ` + (e.message || e)) }
}

// ─── Protocols CRUD ──────────────────────────────────────────────────────────
const showProtocolModal = ref(false)
const protocolSaving = ref(false)
const protocolError = ref('')
const editingProtocolId = ref(null)
const protocolForm = reactive({ code: '', name: '', category: '', steps: '', notes: '' })

function openAddProtocolModal() {
  if (!isAdmin.value) { openLoginModal(() => openAddProtocolModal()); return }
  editingProtocolId.value = null
  Object.assign(protocolForm, { code: '', name: '', category: '', steps: '', notes: '' })
  protocolError.value = ''; showProtocolModal.value = true
}
function openEditProtocolModal(p) {
  if (!isAdmin.value) { openLoginModal(() => openEditProtocolModal(p)); return }
  editingProtocolId.value = p.id
  Object.assign(protocolForm, { code: p.code || '', name: p.name || '', category: p.category || '', steps: p.steps || '', notes: p.notes || '' })
  protocolError.value = ''; showProtocolModal.value = true
}
function closeProtocolModal() { showProtocolModal.value = false; editingProtocolId.value = null }
async function submitProtocolForm() {
  if (!normalizedText(protocolForm.name)) { protocolError.value = t('protocolNameRequired'); return }
  protocolSaving.value = true; protocolError.value = ''
  try {
    const payload = { code: normalizedText(protocolForm.code) || null, name: normalizedText(protocolForm.name),
      category: normalizedText(protocolForm.category) || 'other', steps: normalizedText(protocolForm.steps) || null, notes: normalizedText(protocolForm.notes) || null }
    if (editingProtocolId.value) {
      await api(`/api/protocols/${editingProtocolId.value}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) })
    } else {
      await api('/api/protocols', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) })
      saveRecentAdd({ name: payload.name, type: 'protocol', place: payload.category || 'protocol' })
    }
    showProtocolModal.value = false; editingProtocolId.value = null
    await Promise.all([loadProtocols(), loadProtocolCategories(), loadStats()])
    await loadActivityLog()
  } catch (e) { protocolError.value = String(e.message || e) }
  finally { protocolSaving.value = false }
}
async function deleteProtocol(p) {
  if (!isAdmin.value) { openLoginModal(() => deleteProtocol(p)); return }
  if (!confirm(`Удалить протокол "${p.name}"?`)) return
  try {
    await api(`/api/protocols/${p.id}`, { method: 'DELETE' })
    await Promise.all([loadProtocols(), loadProtocolCategories(), loadStats()])
    await loadActivityLog()
  } catch (e) { alert(`${t('deleteError')}: ` + (e.message || e)) }
}

function exportCurrent(format) {
  if (activeTab.value === 'protocols') {
    download(`/api/export/protocols/${format}`, format === 'excel' ? 'protocols.xlsx' : 'protocols.docx')
  } else if (activeTab.value === 'equipment') {
    download(`/api/export/equipment/${format}`, format === 'excel' ? 'equipment.xlsx' : 'equipment.docx')
  } else if (activeTab.value === 'consumable') {
    download(`/api/export/consumables/${format}`, format === 'excel' ? 'consumables.xlsx' : 'consumables.docx')
  } else {
    download(`/api/export/reagents/${format}`, format === 'excel' ? 'reagents.xlsx' : 'reagents.docx')
  }
}

const filteredSiteUpdates = computed(() => siteUpdates.value.slice(0, 100))

// ─── BOOKING MODULE ───────────────────────────────────────────────────────────

const INSTRUMENTS = [
  { id: 'ftir',     labelKey: 'instrFTIR',     icon: '📡', searchNames: ['FTIR', 'ИК-спектроскопия', 'спектроскопия'] },
  { id: 'tga',      labelKey: 'instrTGA',      icon: '🌡️', searchNames: ['TGA', 'Термогравиметр', 'термогравиметри'] },
  { id: 'dls',      labelKey: 'instrDLS',      icon: '💧', searchNames: ['DLS', 'светорассеяние'] },
  { id: 'opt',      labelKey: 'instrOptMicro', icon: '🔬', searchNames: ['оптический', 'микроскоп'] },
  { id: 'confocal', labelKey: 'instrConfocal', icon: '🔭', searchNames: ['конфокальный', 'confocal'] },
  { id: 'benano',   labelKey: 'instrBeNano',   icon: '⚗️', searchNames: ['BeNano', 'zeta'] },
]

const DURATIONS = [
  { val: 30, key: 'dur30' }, { val: 60, key: 'dur60' }, { val: 90, key: 'dur90' },
  { val: 120, key: 'dur120' }, { val: 180, key: 'dur180' }, { val: 240, key: 'dur240' },
]

const INSTR_INFO = {
  ftir: {
    protocol: 'Перед включением: убедитесь, что продувочный газ (азот/воздух) подключён. Включайте прибор минимум за 15 мин до измерения для прогрева. Подготовьте образец (KBr-таблетка, ATR, жидкостная кювета). После измерения очистите ATR-кристалл изопропанолом.',
    postprocess: 'Экспортируйте спектр в формат .csv или .spa. Для анализа используйте OMNIC, Origin или Python (scipy). Фоновый спектр записывайте не реже 1 раза в 30 мин.',
    articles: ['DOI: 10.1016/j.ijpharm.2020.xxxxx', 'DOI: 10.1021/acs.analchem.xxxxx']
  },
  tga: {
    protocol: 'Тарировка тигля перед каждым измерением. Навеска образца: 5–15 мг. Поток газа (N₂ или воздух): 50–100 мл/мин. Скорость нагрева: 10°C/мин (стандарт). После завершения дайте прибору остыть до <50°C перед открытием.',
    postprocess: 'Анализ в ПО NETZSCH Proteus или TA Instruments Universal Analysis. Определите этапы разложения, температуры пиков и потери масс. Экспортируйте данные в .csv для Origin.',
    articles: ['DOI: 10.1016/j.tca.2021.xxxxx']
  },
  dls: {
    protocol: 'Используйте пластиковые кюветы (полистирол). Объём образца: 0,5–1 мл. Концентрация частиц: 0,1–5 мг/мл. Центрифугируйте суспензию перед измерением (3000 об/мин, 2 мин), если есть крупные агрегаты. Минимум 3 запуска по 10–15 циклов.',
    postprocess: 'Анализируйте распределение по интенсивности, объёму и числу. Отчитывайтесь Z-average и PDI. При PDI > 0,3 образец полидисперсен.',
    articles: ['DOI: 10.1021/la100014z']
  },
  opt: {
    protocol: 'Очистите предметное стекло и покровное стекло этанолом. Нанесите каплю суспензии (5–10 мкл). Накройте покровным стеклом без пузырей. Начинайте с объектива 10×, затем переходите к 40× или 100× (иммерсия).',
    postprocess: 'Сохраняйте изображения в TIFF (без сжатия). Анализ размеров частиц в ImageJ: Analyze → Analyze Particles.',
    articles: ['DOI: 10.1039/c5sm00000a']
  },
  confocal: {
    protocol: 'Для флуоресценции: проверьте длины волн возбуждения/эмиссии красителя. Используйте иммерсионный объектив (63× или 100×). Минимальная мощность лазера — ограничивайте фотообесцвечивание. Запись серии Z-срезов (Z-stack): шаг 0,2–0,5 мкм.',
    postprocess: 'Обработка в ImageJ/Fiji или ZEN (ZEISS). 3D-реконструкция через Volume Viewer. Для колокализации: расчёт коэффициента Пирсона.',
    articles: ['DOI: 10.1038/nmeth.xxxxx', 'DOI: 10.1016/j.biomaterials.20xx.xxxxx']
  },
  benano: {
    protocol: 'Подготовка аналогична DLS (см. выше). BeNano поддерживает одновременное измерение DLS + ELS (зета-потенциал). Для зета-потенциала используйте кювету с электродами. Ионная сила буфера должна быть ≤ 50 мМ.',
    postprocess: 'Экспортируйте отчёт PDF + исходные данные. Сравните Z-average и PDI со стандартными DLS (при наличии). Зета-потенциал > ±30 мВ — коллоидно стабильная система.',
    articles: ['DOI: 10.1016/j.ijpharm.2022.xxxxx']
  }
}

const equipmentItems = ref([])
const instrItemMap = ref({})
const maintenanceRecords = ref([])

async function loadEquipmentItems() {
  try {
    const data = await api('/api/search?item_type=equipment&limit=100')
    equipmentItems.value = data.results || []
    for (const instr of INSTRUMENTS) {
      const found = equipmentItems.value.find(item =>
        instr.searchNames.some(name =>
          (item.name || '').toLowerCase().includes(name.toLowerCase()) ||
          (item.name_ru || '').toLowerCase().includes(name.toLowerCase()) ||
          (item.name_en || '').toLowerCase().includes(name.toLowerCase())
        )
      )
      if (found) instrItemMap.value[instr.id] = found.id
    }
  } catch (e) { equipmentItems.value = [] }
}

function getItemIdForInstr(instrId) {
  return instrItemMap.value[instrId] || null
}

async function loadAllMaintenance() {
  try {
    maintenanceRecords.value = await api(`/api/instrument-maintenance/all`)
  } catch (e) {
    maintenanceRecords.value = []
  }
}

function isDateUnavail(instrId, dateStr) {
  return maintenanceRecords.value.some(m => m.instrument_id === instrId && dateStr >= m.date_from && dateStr <= m.date_to)
}

function getMaintReason(instrId) {
  const rec = maintenanceRecords.value.find(m => m.instrument_id === instrId)
  return rec?.reason || ''
}

const bookings = ref([])

async function loadAllBookings() {
  try {
    const offset = bookingWeek.value === 'this' ? 0 : 1
    const data = await api(`/api/instrument-usage?${qs({ period: 'week', offset })}`)
    bookings.value = data.results.map(u => {
      const start = new Date(u.start_time)
      const end = new Date(u.end_time)
      const duration = Math.round((end - start) / 60000)
      const dateStr = start.toISOString().slice(0, 10)
      return {
        id: u.id, apiId: u.id, instrId: u.instrument_id,
        date: dateStr, who: u.username, experiment: u.notes || '',
        duration, comments: ''
      }
    })
  } catch (e) {
    bookings.value = []
  }
}

function loadBookingData() {
  loadAllBookings()
  loadAllMaintenance()
  loadCellBookings()
}

const selectedInstrId = ref(INSTRUMENTS[0].id)
const bookingWeek = ref('this')
const showBookingModal = ref(false)
const showInstrInfoModal = ref(false)
const showAdminStatusModal = ref(false)
const editingBookingId = ref(null)
const bookingError = ref('')
const bookingSaving = ref(false)
const bookingInfoTab = ref('protocol')

// ═══ Time-based booking form with sliders ═══
const bookingForm = reactive({
  instrId: '',
  date: '',
  who: '',
  experiment: '',
  startMinutes: 540,
  duration: 60,
  comments: ''
})

const DAY_START = 480
const DAY_END = 1200

function minutesToLabel(total) {
  const h = Math.floor(total / 60)
  const m = total % 60
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`
}






function toLocalDateTimeStr(dateObj) {
  const y = dateObj.getFullYear()
  const mo = String(dateObj.getMonth() + 1).padStart(2, '0')
  const d = String(dateObj.getDate()).padStart(2, '0')
  const h = String(dateObj.getHours()).padStart(2, '0')
  const mi = String(dateObj.getMinutes()).padStart(2, '0')
  const s = String(dateObj.getSeconds()).padStart(2, '0')
  return `${y}-${mo}-${d}T${h}:${mi}:${s}`
}




const startTimeLabel = computed(() => minutesToLabel(bookingForm.startMinutes))
const endTimeLabel = computed(() => minutesToLabel(bookingForm.startMinutes + bookingForm.duration))
const durationLabel = computed(() => {
  const d = DURATIONS.find(x => x.val === bookingForm.duration)
  return d ? t(d.key) : `${bookingForm.duration} мин`
})
const maxStartMinutes = computed(() => DAY_END - bookingForm.duration)

const timelineFillStyle = computed(() => {
  const total = DAY_END - DAY_START
  const left = ((bookingForm.startMinutes - DAY_START) / total) * 100
  const width = (bookingForm.duration / total) * 100
  return { left: `${left}%`, width: `${width}%` }
})

watch(() => bookingForm.duration, (nd) => {
  if (bookingForm.startMinutes + nd > DAY_END) {
    bookingForm.startMinutes = DAY_END - nd
  }
})
// ═══ END: Time-based booking form ═══

// ═══ Conflict handling ═══
const showConflictModal = ref(false)
const conflictInfo = reactive({ who: '', experiment: '' })
const forceBooking = ref(false)
const conflictSource = ref('equipment')




function closeConflictModal() {
  showConflictModal.value = false
  forceBooking.value = false
}
function confirmConflict() {
  showConflictModal.value = false
  forceBooking.value = true
  if (conflictSource.value === 'cell') {
    submitCellBooking()
  } else {
    submitBooking()
  }
}




// ═══ END Conflict handling ═══

function getInstrStatus(instrId) {
  const hasMaint = maintenanceRecords.value.some(m => m.instrument_id === instrId)
  const reason = getMaintReason(instrId)
  return { status: hasMaint ? 'maint' : 'ok', reason }
}

function getWeekDates(offset = 0) {
  const now = new Date()
  const monday = new Date(now)
  const day = now.getDay() === 0 ? 6 : now.getDay() - 1
  monday.setDate(now.getDate() - day + offset * 7)
  monday.setHours(0, 0, 0, 0)
  return Array.from({ length: 7 }, (_, i) => {
    const d = new Date(monday); d.setDate(monday.getDate() + i)
    return d
  })
}

const thisWeekDates = computed(() => getWeekDates(0))
const nextWeekDates = computed(() => getWeekDates(1))
const currentWeekDates = computed(() => bookingWeek.value === 'this' ? thisWeekDates.value : nextWeekDates.value)

function formatDate(d) {
  return d.toLocaleDateString(language.value === 'ru' ? 'ru-RU' : 'en-GB', { weekday: 'short', day: '2-digit', month: '2-digit' })
}
function toDateStr(d) {
  return d.toISOString().slice(0, 10)
}

function getBookingsForDay(instrId, dateStr) {
  return bookings.value.filter(b => b.instrId === instrId && b.date === dateStr)
}

function openBookingModal(instrId, dateStr) {
  bookingError.value = isDateUnavail(instrId, dateStr) ? t('bookingUnavailDay') : ''
  editingBookingId.value = null
  forceBooking.value = false
  Object.assign(bookingForm, { instrId, date: dateStr, who: '', experiment: '', startMinutes: 540, duration: 60, comments: '' })
  showBookingModal.value = true
}

function openEditBookingModal(b) {
  editingBookingId.value = b.id
  forceBooking.value = false
  Object.assign(bookingForm, { instrId: b.instrId, date: b.date, who: b.who, experiment: b.experiment, startMinutes: 540, duration: b.duration, comments: b.comments || '' })
  bookingError.value = ''; showBookingModal.value = true
}

function closeBookingModal() { showBookingModal.value = false; editingBookingId.value = null; bookingError.value = ''; forceBooking.value = false }

async function submitBooking() {
  if (!normalizedText(bookingForm.who)) { bookingError.value = t('bookingNameRequired'); return }
  if (!normalizedText(bookingForm.experiment)) { bookingError.value = t('bookingExpRequired'); return }
  if (!bookingForm.date) { bookingError.value = t('bookingDateRequired'); return }

  bookingSaving.value = true
  bookingError.value = ''
  try {
    const h = Math.floor(bookingForm.startMinutes / 60)
    const m = bookingForm.startMinutes % 60
    const startTime = `${bookingForm.date}T${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:00`
    const endDate = new Date(`${bookingForm.date}T${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:00`)
    endDate.setMinutes(endDate.getMinutes() + bookingForm.duration)
    const endTime = toLocalDateTimeStr(endDate)

    const payload = {
      instrument_id: bookingForm.instrId,
      username: normalizedText(bookingForm.who),
      start_time: startTime,
      end_time: endTime,
      notes: normalizedText(bookingForm.experiment),
      force: forceBooking.value
    }

    let r
    if (editingBookingId.value) {
      const old = bookings.value.find(b => b.id === editingBookingId.value)
      r = await fetch(`${API_BASE}/api/instrument-usage/${old?.apiId}`, {
        method: 'PATCH', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          username: payload.username, start_time: payload.start_time,
          end_time: payload.end_time, notes: payload.notes
        })
      })
    } else {
      r = await fetch(`${API_BASE}/api/instrument-usage`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      })
    }

    if (!r.ok) {
      const text = await r.text()
      let detail = text
      try { detail = JSON.parse(text).detail || text } catch (e) {}
      if (r.status === 409 && detail.startsWith('КОНФЛИКТ')) {
        const parts = detail.split(':')
        conflictInfo.who = parts[1] || ''
        conflictInfo.experiment = parts[2] || ''
        conflictSource.value = 'equipment'
        showConflictModal.value = true
        bookingSaving.value = false
        return
      }
      throw new Error(detail)
    }

    await loadAllBookings()
    showBookingModal.value = false
    editingBookingId.value = null
    forceBooking.value = false
  } catch (e) {
    bookingError.value = String(e.message || e)
  } finally {
    bookingSaving.value = false
  }
}





async function deleteBooking(b) {
  if (!confirm(`${b.who}: ${b.experiment}?`)) return
  try {
    if (b.apiId) await api(`/api/instrument-usage/${b.apiId}`, { method: 'DELETE' })
    await loadAllBookings()
  } catch (e) {}
}

const adminStatusForm = reactive({
  instrId: '',
  status: 'ok',
  reason: '',
  selectedDates: []
})

watch(() => adminStatusForm.status, (val) => {
  if (val === 'ok') {
    adminStatusForm.selectedDates = []
  }
})

const maintDatePickerWeeks = computed(() => [getWeekDates(0), getWeekDates(1)])

function openAdminStatusModal(instrId) {
  if (!isAdmin.value) { openLoginModal(() => openAdminStatusModal(instrId)); return }
  const currentDates = maintenanceRecords.value
    .filter(m => m.instrument_id === instrId)
    .flatMap(m => {
      const dates = []
      const from = new Date(m.date_from)
      const to = new Date(m.date_to)
      for (let d = new Date(from); d <= to; d.setDate(d.getDate() + 1)) {
        dates.push(d.toISOString().slice(0, 10))
      }
      return dates
    })
  Object.assign(adminStatusForm, {
    instrId,
    status: currentDates.length > 0 ? 'maint' : 'ok',
    reason: getMaintReason(instrId),
    selectedDates: [...new Set(currentDates)]
  })
  showAdminStatusModal.value = true
}

function closeAdminStatusModal() { showAdminStatusModal.value = false }

function toggleMaintDate(dateStr) {
  const idx = adminStatusForm.selectedDates.indexOf(dateStr)
  if (idx >= 0) adminStatusForm.selectedDates.splice(idx, 1)
  else adminStatusForm.selectedDates.push(dateStr)
  adminStatusForm.status = adminStatusForm.selectedDates.length > 0 ? 'maint' : 'ok'
}

function isMaintDateSelected(dateStr) {
  return adminStatusForm.selectedDates.includes(dateStr)
}

async function submitAdminStatus() {
  const instrId = adminStatusForm.instrId
  const toDelete = maintenanceRecords.value.filter(m => m.instrument_id === instrId)
  for (const m of toDelete) {
    try { await api(`/api/instrument-maintenance/${m.id}`, { method: 'DELETE' }) } catch (e) {}
  }
  const sorted = [...adminStatusForm.selectedDates].sort()
  for (const dateStr of sorted) {
    try {
      await api(`/api/instrument-maintenance`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          instrument_id: instrId,
          date_from: dateStr, date_to: dateStr,
          reason: normalizedText(adminStatusForm.reason) || null,
          created_by: isAdmin.value ? 'admin' : null
        })
      })
    } catch (e) {}
  }
  await loadAllMaintenance()
  showAdminStatusModal.value = false
}

function openInstrInfoModal(instrId) {
  selectedInstrId.value = instrId; bookingInfoTab.value = 'protocol'; showInstrInfoModal.value = true
}
function closeInstrInfoModal() { showInstrInfoModal.value = false }

const selectedInstr = computed(() => INSTRUMENTS.find(i => i.id === selectedInstrId.value))
const selectedInstrInfo = computed(() => INSTR_INFO[selectedInstrId.value] || {})

// ─── CELL CULTURE MODULE ─────────────────────────────────────────────────────
const cellBookings = ref([])
const cellBookingWeek = ref('this')
const showCellBookingModal = ref(false)
const editingCellBookingId = ref(null)
const cellBookingForm = reactive({
  boxNumber: 1, date: '', who: '', experiment: '', startMinutes: 540, duration: 60, comments: ''
})
const cellBookingError = ref('')
const cellBookingSaving = ref(false)

async function loadCellBookings() {
  try {
    const offset = cellBookingWeek.value === 'this' ? 0 : 1
    const data = await api(`/api/cell-usage?period=week&offset=${offset}`)
    cellBookings.value = (data.results || []).map(u => {
      const start = new Date(u.start_time)
      const end = new Date(u.end_time)
      const duration = Math.round((end - start) / 60000)
      return {
        id: u.id,
        apiId: u.id,
        boxNumber: u.box_number,
        date: start.toISOString().slice(0, 10),
        who: u.user_name,
        experiment: u.experiment || '',
        duration: duration,
        startMinutes: start.getHours() * 60 + start.getMinutes(),
        comments: ''
      }
    })
  } catch (e) { cellBookings.value = [] }
}

function getCellBookingsForDay(boxNumber, dateStr) {
  return cellBookings.value.filter(b => b.boxNumber === boxNumber && b.date === dateStr)
}



function openCellBookingModal(boxNumber, dateStr) {
  cellBookingError.value = ''
  editingCellBookingId.value = null
  forceBooking.value = false
  Object.assign(cellBookingForm, { boxNumber, date: dateStr, who: '', experiment: '', startMinutes: 540, duration: 60, comments: '' })
  showCellBookingModal.value = true
}









function openEditCellBookingModal(b) {
  editingCellBookingId.value = b.id
  Object.assign(cellBookingForm, {
    boxNumber: b.boxNumber, date: b.date, who: b.who, experiment: b.experiment,
    startMinutes: b.startMinutes || 540, duration: b.duration, comments: b.comments || ''
  })
  cellBookingError.value = ''; showCellBookingModal.value = true
}

function closeCellBookingModal() {
  showCellBookingModal.value = false; editingCellBookingId.value = null; cellBookingError.value = ''
}





async function submitCellBooking() {
  if (!normalizedText(cellBookingForm.who)) { cellBookingError.value = t('bookingNameRequired'); return }
  if (!normalizedText(cellBookingForm.experiment)) { cellBookingError.value = t('bookingExpRequired'); return }
  if (!cellBookingForm.date) { cellBookingError.value = t('bookingDateRequired'); return }

  cellBookingSaving.value = true; cellBookingError.value = ''
  try {
    const h = Math.floor(cellBookingForm.startMinutes / 60)
    const m = cellBookingForm.startMinutes % 60
    const startTime = `${cellBookingForm.date}T${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:00`
    const endDate = new Date(startTime)
    endDate.setMinutes(endDate.getMinutes() + cellBookingForm.duration)
    const endTime = toLocalDateTimeStr(endDate)

    if (editingCellBookingId.value) {
      await api(`/api/cell-usage/${editingCellBookingId.value}`, {
        method: 'PATCH', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          user_name: normalizedText(cellBookingForm.who),
          start_time: startTime,
          end_time: endTime,
          experiment: normalizedText(cellBookingForm.experiment)
        })
      })
    } else {



      
      const r = await fetch(`${API_BASE}/api/cell-usage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          box_number: cellBookingForm.boxNumber,
          user_name: normalizedText(cellBookingForm.who),
          start_time: startTime,
          end_time: endTime,
          experiment: normalizedText(cellBookingForm.experiment),
          force: forceBooking.value
        })
      })





      if (!r.ok) {
        const text = await r.text()
        let detail = text
        try { detail = JSON.parse(text).detail || text } catch (e) {}
        if (r.status === 409 && detail.startsWith('CONFLICT:')) {
          const parts = detail.split(':')
          conflictInfo.who = parts[1] || ''
          conflictInfo.experiment = parts[2] || ''
          conflictSource.value = 'cell'
          showConflictModal.value = true
          cellBookingSaving.value = false
          return
        }
        throw new Error(detail)
      }



    }



    
    await loadCellBookings()
    showCellBookingModal.value = false; editingCellBookingId.value = null; forceBooking.value = false
  } catch (e) {
    cellBookingError.value = String(e.message || e)
  } finally {
    cellBookingSaving.value = false
  }
}









async function deleteCellBooking(b) {
  if (!confirm(`Удалить запись "${b.who} — ${b.experiment}"?`)) return
  try {
    if (b.apiId) await api(`/api/cell-usage/${b.apiId}`, { method: 'DELETE' })
    await loadCellBookings()
  } catch (e) {}
}

const cellWeekDates = computed(() => cellBookingWeek.value === 'this' ? thisWeekDates.value : nextWeekDates.value)
const expandedCellBox = ref(null)
function toggleCellBox(box) {
  expandedCellBox.value = expandedCellBox.value === box ? null : box
  if (expandedCellBox.value) loadCellBookings()
}

// ─── EXPERIMENTS MODULE ──────────────────────────────────────────────────────
const activeExperimentTab = ref('alamar')
const alamarFile = ref(null)
const releaseFile = ref(null)
const alamarResult = ref(null)
const releaseResult = ref(null)
const experimentLoading = ref(false)
const experimentError = ref('')

function onAlamarFileChange(e) {
  alamarFile.value = e.target.files?.[0] || null
}
function onReleaseFileChange(e) {
  releaseFile.value = e.target.files?.[0] || null
}

async function processAlamar() {
  if (!alamarFile.value) return
  experimentLoading.value = true; experimentError.value = ''; alamarResult.value = null
  try {
    const formData = new FormData()
    formData.append('file', alamarFile.value)
    const r = await fetch(`${API_BASE}/api/experiments/alamar-blue`, { method: 'POST', body: formData })
    if (!r.ok) throw new Error(await r.text())
    alamarResult.value = await r.json()
  } catch (e) { experimentError.value = `${t('processError')}: ${String(e.message || e)}` }
  finally { experimentLoading.value = false }
}

async function processRelease() {
  if (!releaseFile.value) return
  experimentLoading.value = true; experimentError.value = ''; releaseResult.value = null
  try {
    const formData = new FormData()
    formData.append('file', releaseFile.value)
    const r = await fetch(`${API_BASE}/api/experiments/release`, { method: 'POST', body: formData })
    if (!r.ok) throw new Error(await r.text())
    releaseResult.value = await r.json()
  } catch (e) { experimentError.value = `${t('processError')}: ${String(e.message || e)}` }
  finally { experimentLoading.value = false }
}

async function downloadAlamarExcel() {
  if (!alamarResult.value) return
  const r = await fetch(`${API_BASE}/api/experiments/alamar-blue/export-excel`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(alamarResult.value)
  })
  if (!r.ok) throw new Error(await r.text())
  const blob = await r.blob()
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = 'alamar_blue_results.xlsx'
  link.click()
  URL.revokeObjectURL(link.href)
}

async function downloadReleaseExcel() {
  if (!releaseResult.value) return
  const r = await fetch(`${API_BASE}/api/experiments/release/export-excel`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(releaseResult.value)
  })
  if (!r.ok) throw new Error(await r.text())
  const blob = await r.blob()
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = 'release_results.xlsx'
  link.click()
  URL.revokeObjectURL(link.href)
}

// ─── Modal tracking ──────────────────────────────────────────────────────────
const anyModalOpen = computed(() =>
  showDatabaseModal.value || showAddModal.value || showProtocolModal.value || showLoginModal.value ||
  showBookingModal.value || showInstrInfoModal.value || showAdminStatusModal.value ||
  showCellBookingModal.value || showConflictModal.value
)
watch(anyModalOpen, (val) => { document.body.classList.toggle('modal-open', val) })
</script>

<template>
  <div class="app-shell" :class="{ 'is-mobile': isMobile }">

    <!-- ═══ MOBILE HOME ═══ -->
    <div v-if="isMobile && mobileScreen === 'home'" class="mobile-home">
      <div class="mobile-home-header">
        <div class="mobile-home-topline">
          <button v-if="isAdmin" class="admin-badge-mini mobile-admin-left" title="Администратор (нажмите, чтобы выйти)" @click="logoutAdmin">A</button>
          <div class="mobile-home-title-wrap">
            <div class="logo mobile-logo">
              <img v-if="theme === 'light'" src="/logo-light.png" alt="Lab logo" />
              <img v-else src="/logo-dark.png" alt="Lab logo" />
            </div>
            <h1>{{ t('catalog') }}</h1>
            <p>{{ t('mobileSubtitle') }}</p>
          </div>
          <div class="mobile-header-actions">
            <button class="theme-toggle-mini" @click="toggleTheme">{{ theme === 'dark' ? '☀️' : '🌙' }}</button>
            <button class="lang-toggle-mini" @click="language = language === 'ru' ? 'en' : 'ru'">{{ language === 'ru' ? 'RU' : 'EN' }}</button>
          </div>
        </div>
      </div>

      <div class="mobile-big-grid">
        <button class="big-btn big-btn-protocols" @click="goMobileCatalog('protocols')">
          <span class="big-btn-icon">📖</span><span class="big-btn-label">{{ t('protocols') }}</span>
        </button>
        <button class="big-btn big-btn-reagent" @click="goMobileCatalog('reagent')">
          <span class="big-btn-icon">🧪</span><span class="big-btn-label">{{ t('reagents') }}</span>
        </button>
        <button class="big-btn big-btn-consumable" @click="goMobileCatalog('consumable')">
          <span class="big-btn-icon">📦</span><span class="big-btn-label">{{ t('consumables') }}</span>
        </button>
        <button class="big-btn big-btn-equipment" @click="goMobileCatalog('equipment')">
          <span class="big-btn-icon">⚙️</span><span class="big-btn-label">{{ t('equipment') }}</span>
        </button>
        <button class="big-btn big-btn-booking" @click="goMobileCatalog('booking')">
          <span class="big-btn-icon">🗓️</span><span class="big-btn-label">{{ t('bookingShort') }}</span>
        </button>
        <button class="big-btn big-btn-experiments" @click="goMobileCatalog('experiments')">
          <span class="big-btn-icon">📊</span><span class="big-btn-label">{{ t('experimentsShort') }}</span>
        </button>
      </div>

      <button class="big-btn-secondary" @click="goMobileAddChoice">➕ {{ t('add') }}</button>
    </div>

    <!-- ═══ MOBILE ADD CHOICE ═══ -->
    <div v-else-if="isMobile && mobileScreen === 'addChoice'" class="mobile-home">
      <div class="mobile-screen-header">
        <div class="mobile-screen-topline">
          <button class="back-btn" @click="goMobileHome">← {{ t('back') }}</button>
          <div class="mobile-header-actions-inline">
            <button v-if="isAdmin" class="admin-badge-mini" title="Администратор (нажмите, чтобы выйти)" @click="logoutAdmin">A</button>
            <button class="theme-toggle-mini" @click="toggleTheme">{{ theme === 'dark' ? '☀️' : '🌙' }}</button>
            <button class="lang-toggle-mini" @click="language = language === 'ru' ? 'en' : 'ru'">{{ language === 'ru' ? 'RU' : 'EN' }}</button>
          </div>
        </div>
        <h2>{{ t('addWhat') }}</h2>
      </div>

      <div v-if="currentLocation" class="current-location-badge mobile-badge">
        📍 {{ t('currentPlace') }}: {{ currentLocation.room }}{{ currentLocation.cabinet ? ' · ' + currentLocation.cabinet : '' }}
      </div>
      <div v-else class="muted mobile-badge">{{ t('placeNotSet') }}</div>

      <div class="mobile-big-grid">
        <button class="big-btn big-btn-protocols" @click="openAddProtocolModal"><span class="big-btn-icon">📖</span><span class="big-btn-label">{{ t('addProtocol') }}</span></button>
        <button class="big-btn big-btn-reagent" @click="openAddModal('reagent')"><span class="big-btn-icon">🧪</span><span class="big-btn-label">{{ t('reagentOne') }}</span></button>
        <button class="big-btn big-btn-consumable" @click="openAddModal('consumable')"><span class="big-btn-icon">📦</span><span class="big-btn-label">{{ t('consumableOne') }}</span></button>
        <button class="big-btn big-btn-equipment" @click="openAddModal('equipment')"><span class="big-btn-icon">⚙️</span><span class="big-btn-label">{{ t('equipmentOne') }}</span></button>
        <button class="big-btn big-btn-other" @click="openAddModal('other')"><span class="big-btn-icon">🗂️</span><span class="big-btn-label">{{ t('otherOne') }}</span></button>
      </div>
    </div>

    <!-- ═══ DESKTOP + MOBILE CATALOG ═══ -->
    <template v-else>
      <div class="workspace">
        <header class="desktop-header">
          <div class="desktop-header-top">
            <div class="brand">
              <div class="logo">
                <img v-if="theme === 'light'" src="/logo-light.png" alt="Lab logo" />
                <img v-else src="/logo-dark.png" alt="Lab logo" />
              </div>
              <div class="brand-copy">
                <h1>{{ t('labTitle') }}</h1>
                <p>{{ t('labSubtitle') }}</p>
              </div>
            </div>
            <div class="topbar-right-controls">
              <button class="theme-toggle" @click="toggleTheme">{{ theme === 'dark' ? '☀️' : '🌙' }}</button>
              <button class="btn lang-btn" @click="language = language === 'ru' ? 'en' : 'ru'">{{ language === 'ru' ? 'RU' : 'EN' }}</button>
              <button class="btn admin-btn" :class="{ 'admin-btn-on': isAdmin }" @click="isAdmin ? logoutAdmin() : openLoginModal()">
                {{ isAdmin ? t('adminOn') : t('adminOff') }}
              </button>
            </div>
          </div>

          <div class="desktop-tabs-row">
            <div class="toolbar-block section-toolbar-full">
              <div class="section-tabs-line">
                <div class="section-left">
                  <div class="group-title">{{ t('section') }}</div>
                  <div class="section-tabs">
                    <button class="section-tab" :class="{ active: activeTab === 'reagent' }" @click="setTab('reagent')">
                      <span>{{ t('reagents') }}</span><span class="tab-count">{{ countByType('reagent') }}</span>
                    </button>
                    <button class="section-tab" :class="{ active: activeTab === 'consumable' }" @click="setTab('consumable')">
                      <span>{{ t('consumables') }}</span><span class="tab-count">{{ countByType('consumable') }}</span>
                    </button>
                    <button class="section-tab" :class="{ active: activeTab === 'equipment' }" @click="setTab('equipment')">
                      <span>{{ t('equipment') }}</span><span class="tab-count">{{ countByType('equipment') }}</span>
                    </button>
                    <button class="section-tab" :class="{ active: activeTab === 'protocols' }" @click="setTab('protocols')">
                      <span>{{ t('protocols') }}</span><span class="tab-count">{{ stats.protocols_total ?? 0 }}</span>
                    </button>
                    <button class="section-tab section-tab-booking" :class="{ active: activeTab === 'booking' }" @click="setTab('booking')">
                      <span>🗓️ {{ t('bookingShort') }}</span>
                    </button>
                    <button class="section-tab section-tab-experiments" :class="{ active: activeTab === 'experiments' }" @click="setTab('experiments')">
                      <span>📊 {{ t('experimentsShort') }}</span>
                    </button>
                  </div>
                </div>

                <div class="section-right-actions" v-if="activeTab !== 'booking' && activeTab !== 'experiments'">
                  <button v-if="isAdmin" class="btn" @click="exportCurrent('excel')">📊 Excel</button>
                  <button v-if="isAdmin" class="btn" @click="exportCurrent('word')">📄 Word</button>
                  <button v-if="isAdmin" class="btn btn-primary" @click="activeTab === 'protocols' ? openAddProtocolModal() : openAddModal()">
                    + {{ t('add') }}
                  </button>
                  <button class="btn btn-database" @click="showDatabaseModal = true; loadActivityLog()">🗄️</button>
                </div>
                <div class="section-right-actions" v-else>
                  <button class="btn btn-database" @click="showDatabaseModal = true; loadActivityLog()">🗄️</button>
                </div>
              </div>
            </div>
          </div>

          <div class="desktop-filter-row" v-if="activeTab !== 'protocols' && activeTab !== 'booking' && activeTab !== 'experiments'">
            <div class="toolbar-block filters-block">
              <div class="group-title">{{ t('room') }}</div>
              <div class="room-line">
                <button class="room-chip" :class="{ active: state.room === '' }" @click="resetFilters">{{ t('all') }}</button>
                <button v-for="r in filteredRooms" :key="r.room" class="room-chip" :class="{ active: expandedRoom === r.room }" @click="toggleRoom(r.room)">
                  {{ r.room }}<span class="room-chip-count">{{ r.items_count }}</span>
                </button>
                <button class="btn btn-ghost" @click="resetFilters">{{ t('reset') }}</button>
              </div>
              <div v-if="expandedRoom && filteredCabinets.length" class="cabinet-line">
                <button v-for="c in filteredCabinets" :key="c.cabinet" class="cabinet-chip" :class="{ active: state.cabinet === c.cabinet }" @click="selectCabinet(c.cabinet)">
                  {{ c.cabinet }}<span class="room-chip-count">{{ c.items_count }}</span>
                </button>
              </div>
            </div>
          </div>

          <div class="desktop-filter-row" v-if="activeTab === 'booking'">
            <div class="toolbar-block filters-block">
              <div class="group-title">{{ t('selectInstrument') }}</div>
              <div class="room-line">
                <button
                  v-for="instr in INSTRUMENTS" :key="instr.id"
                  class="room-chip instr-chip"
                  :class="{
                    active: selectedInstrId === instr.id,
                    'instr-maint': getInstrStatus(instr.id).status !== 'ok'
                  }"
                  @click="selectedInstrId = instr.id"
                >
                  {{ instr.icon }} {{ t(instr.labelKey) }}
                  <span v-if="getInstrStatus(instr.id).status !== 'ok'" class="instr-maint-dot" title="Техобслуживание">⚠️</span>
                </button>
              </div>
            </div>
          </div>

          <div v-if="!isMobile && activeTab !== 'booking' && activeTab !== 'experiments'" class="desktop-context-row desktop-search-only-row">
            <div class="context-search-block search-block-wide">
              <div class="group-title">{{ t('desktopSearchTitle') }}</div>
              <div class="desktop-search-wrap">
                <input v-if="activeTab !== 'protocols'" v-model="state.q" type="search" :placeholder="t('searchItems')" />
                <input v-else v-model="protocolQuery" type="search" :placeholder="t('searchProtocols')" />
              </div>
              <div class="search-history-under">
                <div class="group-title">{{ t('recentSearches') }}</div>
                <div v-if="recentSearches.length" class="history-list compact-history">
                  <button v-for="(entry, idx) in recentSearches" :key="'rs'+idx" class="history-item compact-history-item" @click="openRecentSearch(entry)">
                    <strong>{{ entry.q }}</strong><span>{{ entry.section }} · {{ entry.time }}</span>
                  </button>
                </div>
                <div v-else class="muted history-empty">{{ t('noRecentData') }}</div>
              </div>
            </div>
          </div>
        </header>

        <main class="main">

          <!-- ═══ BOOKING SECTION ═══ -->
          <section v-if="activeTab === 'booking'" class="booking-section">

            <div v-if="selectedInstr && getInstrStatus(selectedInstr.id).status !== 'ok'" class="maint-alert-banner">
              ⛔ {{ selectedInstr.icon }} <strong>{{ t(selectedInstr.labelKey) }}</strong> {{ t('bookingMaintAlert') }}.
              <span v-if="getInstrStatus(selectedInstr.id).reason" class="maint-reason">{{ getInstrStatus(selectedInstr.id).reason }}</span>
            </div>

            <div class="booking-header-row">
              <div class="booking-instr-title">
                <span class="booking-instr-icon">{{ selectedInstr?.icon }}</span>
                <div>
                  <div class="section-title">{{ selectedInstr ? t(selectedInstr.labelKey) : '' }}</div>
                  <div class="muted" style="font-size:var(--text-sm)">{{ t('bookingSubtitle') }}</div>
                </div>
              </div>
              <div class="booking-header-actions">
                <button class="btn" @click="openInstrInfoModal(selectedInstrId)">📋 {{ t('bookingOperProtocol') }}</button>
                <button v-if="isAdmin" class="btn btn-admin-status" @click="openAdminStatusModal(selectedInstrId)">🔧 {{ t('bookingSetStatus') }}</button>
              </div>
            </div>

            <div class="week-toggle-row">
              <button class="week-tab" :class="{ active: bookingWeek === 'this' }" @click="bookingWeek = 'this'; loadAllBookings()">{{ t('thisWeek') }}</button>
              <button class="week-tab" :class="{ active: bookingWeek === 'next' }" @click="bookingWeek = 'next'; loadAllBookings()">{{ t('nextWeek') }}</button>
            </div>

            <div v-if="bookingError && !showBookingModal" class="booking-inline-error">⚠️ {{ bookingError }}</div>

            <div v-if="!isMobile" class="booking-grid">
              <div v-for="day in currentWeekDates" :key="toDateStr(day)" class="booking-day-col">
                <div class="booking-day-header" :class="{ 'day-today': toDateStr(day) === toDateStr(new Date()), 'day-unavail': isDateUnavail(selectedInstrId, toDateStr(day)) }">
                  <div class="booking-day-name">{{ formatDate(day) }}</div>
                  <div v-if="isDateUnavail(selectedInstrId, toDateStr(day))" class="booking-day-maint-label">🔧 ТО</div>
                </div>
                <div class="booking-day-slots">
                  <div v-if="!isDateUnavail(selectedInstrId, toDateStr(day))">
                    <div v-for="b in getBookingsForDay(selectedInstrId, toDateStr(day))" :key="b.id" class="booking-slot">
                      <div class="booking-slot-who">👤 {{ b.who }}</div>
                      <div class="booking-slot-exp">{{ b.experiment }}</div>
                      <div class="booking-slot-dur muted">⏱ {{ DURATIONS.find(d=>d.val===b.duration)?.val || b.duration }} мин</div>
                      <div v-if="b.comments" class="booking-slot-comment muted">💬 {{ b.comments }}</div>
                      <div class="booking-slot-actions">
                        <button class="icon-btn" :title="t('edit')" @click="openEditBookingModal(b)">✏️</button>
                        <button class="icon-btn" :title="t('bookingDelete')" @click="deleteBooking(b)">🗑️</button>
                      </div>
                    </div>
                    <div v-if="!getBookingsForDay(selectedInstrId, toDateStr(day)).length" class="booking-empty-day">—</div>
                    <button class="booking-add-btn" @click="openBookingModal(selectedInstrId, toDateStr(day))">+ {{ t('bookSlot') }}</button>
                  </div>
                  <div v-else class="booking-maint-day">🔧 {{ t('bookingUnavailDay') }}</div>
                </div>
              </div>
            </div>

            <div v-else class="booking-mobile-list">
              <div v-for="day in currentWeekDates" :key="toDateStr(day)" class="booking-mobile-day">
                <div class="booking-mobile-day-header" :class="{ 'day-today': toDateStr(day) === toDateStr(new Date()), 'day-unavail': isDateUnavail(selectedInstrId, toDateStr(day)) }">
                  <span>{{ formatDate(day) }}</span>
                  <span v-if="isDateUnavail(selectedInstrId, toDateStr(day))" class="muted">🔧 ТО</span>
                </div>
                <div v-if="!isDateUnavail(selectedInstrId, toDateStr(day))">
                  <div v-for="b in getBookingsForDay(selectedInstrId, toDateStr(day))" :key="b.id" class="booking-slot booking-slot-mobile">
                    <div class="booking-slot-who">👤 <strong>{{ b.who }}</strong> · ⏱ {{ b.duration }} мин</div>
                    <div class="booking-slot-exp">{{ b.experiment }}</div>
                    <div v-if="b.comments" class="booking-slot-comment muted">💬 {{ b.comments }}</div>
                    <div class="booking-slot-actions">
                      <button class="icon-btn" @click="openEditBookingModal(b)">✏️</button>
                      <button class="icon-btn" @click="deleteBooking(b)">🗑️</button>
                    </div>
                  </div>
                  <div v-if="!getBookingsForDay(selectedInstrId, toDateStr(day)).length" class="muted booking-no-entries">{{ t('noBookings') }}</div>
                  <button class="booking-add-btn-mobile" @click="openBookingModal(selectedInstrId, toDateStr(day))">+ {{ t('bookSlot') }}</button>
                </div>
                <div v-else class="booking-maint-day muted">🔧 {{ t('bookingUnavailDay') }}</div>
              </div>
            </div>

            <!-- ═══ CELL CULTURE ═══ -->
            <div class="cell-culture-divider">
              <div class="cell-culture-title">🧫 {{ t('cellCulture') }}</div>
              <div class="muted" style="font-size:var(--text-sm)">{{ t('cellCultureSubtitle') }}</div>
            </div>

            <div class="week-toggle-row">
              <button class="week-tab" :class="{ active: cellBookingWeek === 'this' }" @click="cellBookingWeek = 'this'; loadCellBookings()">{{ t('thisWeek') }}</button>
              <button class="week-tab" :class="{ active: cellBookingWeek === 'next' }" @click="cellBookingWeek = 'next'; loadCellBookings()">{{ t('nextWeek') }}</button>
            </div>

            <div v-for="box in [1,2]" :key="box" class="cell-box-section">
              <button
                class="cell-box-accordion-btn"
                :class="{ 'cell-box-accordion-open': expandedCellBox === box }"
                @click="toggleCellBox(box)"
              >
                <span>🧫 {{ t('cellBox') }} №{{ box }}</span>
                <span class="cell-box-accordion-arrow">{{ expandedCellBox === box ? '▲' : '▼' }}</span>
              </button>
              <div v-if="!isMobile && expandedCellBox === box" class="booking-grid">
                <div v-for="day in cellWeekDates" :key="toDateStr(day)+'-box-'+box" class="booking-day-col">
                  <div class="booking-day-header" :class="{ 'day-today': toDateStr(day) === toDateStr(new Date()) }">
                    <div class="booking-day-name">{{ formatDate(day) }}</div>
                  </div>
                  <div class="booking-day-slots">
                    <div v-for="b in getCellBookingsForDay(box, toDateStr(day))" :key="b.id" class="booking-slot">
                      <div class="booking-slot-who">👤 {{ b.who }}</div>
                      <div class="booking-slot-exp">{{ b.experiment }}</div>
                      <div class="booking-slot-dur muted">⏱ {{ b.duration }} мин</div>
                      <div class="booking-slot-actions">
                        <button class="icon-btn" @click="openEditCellBookingModal(b)">✏️</button>
                        <button class="icon-btn" @click="deleteCellBooking(b)">🗑️</button>
                      </div>
                    </div>
                    <div v-if="!getCellBookingsForDay(box, toDateStr(day)).length" class="booking-empty-day">—</div>
                    <button class="booking-add-btn" @click="openCellBookingModal(box, toDateStr(day))">+ {{ t('bookSlot') }}</button>
                  </div>
                </div>
              </div>
              <div v-else-if="expandedCellBox === box" class="booking-mobile-list">
                <div v-for="day in cellWeekDates" :key="toDateStr(day)+'-box-'+box" class="booking-mobile-day">
                  <div class="booking-mobile-day-header" :class="{ 'day-today': toDateStr(day) === toDateStr(new Date()) }">
                    <span>{{ formatDate(day) }}</span>
                  </div>
                  <div v-for="b in getCellBookingsForDay(box, toDateStr(day))" :key="b.id" class="booking-slot booking-slot-mobile">
                    <div class="booking-slot-who">👤 <strong>{{ b.who }}</strong> · ⏱ {{ b.duration }} мин</div>
                    <div class="booking-slot-exp">{{ b.experiment }}</div>
                  </div>
                  <div v-if="!getCellBookingsForDay(box, toDateStr(day)).length" class="muted booking-no-entries">{{ t('noBookings') }}</div>
                  <button class="booking-add-btn-mobile" @click="openCellBookingModal(box, toDateStr(day))">+ {{ t('bookSlot') }}</button>
                </div>
              </div>
            </div>
          </section>

          <!-- ═══ EXPERIMENTS SECTION ═══ -->
          <section v-else-if="activeTab === 'experiments'" class="experiments-section">
            <div class="experiments-tabs">
              <button class="experiments-tab" :class="{ active: activeExperimentTab === 'alamar' }" @click="activeExperimentTab = 'alamar'">🔬 {{ t('alamarBlue') }}</button>
              <button class="experiments-tab" :class="{ active: activeExperimentTab === 'release' }" @click="activeExperimentTab = 'release'">⚗️ {{ t('release') }}</button>
              <button class="experiments-tab" :class="{ active: activeExperimentTab === 'dls' }" @click="activeExperimentTab = 'dls'" disabled>💧 {{ t('dls') }}</button>
            </div>

            <div v-if="activeExperimentTab === 'alamar'" class="experiment-card">
              <div class="section-title">{{ t('alamarBlue') }}</div>
              <div class="experiment-hint">Загрузите Excel-файл с сырыми данными планшета (570 нм и 600 нм). Система рассчитает жизнеспособность клеток.</div>
              <div class="form-row" style="margin-top:1rem">
                <input type="file" accept=".xlsx,.xls" @change="onAlamarFileChange" />
              </div>
              <div class="experiment-actions">
                <button class="btn btn-primary" :disabled="experimentLoading || !alamarFile" @click="processAlamar">
                  {{ experimentLoading ? t('processing') : t('process') }}
                </button>
                <button v-if="alamarResult" class="btn" @click="downloadAlamarExcel">📊 {{ t('downloadExcel') }}</button>
              </div>
              <div v-if="experimentError" class="form-error">{{ experimentError }}</div>

              <div v-if="alamarResult && alamarResult.samples" class="experiment-results">
                <div class="group-title">{{ t('results') }}</div>
                <div class="results-table-wrap">
                  <table class="results-table">
                    <thead>
                      <tr><th>{{ t('sample') }}</th><th>{{ t('mean') }} (+ctrl)</th><th>{{ t('std') }}</th><th>{{ t('mean') }} (-ctrl)</th><th>{{ t('std') }}</th><th>n</th></tr>
                    </thead>
                    <tbody>
                      <tr v-for="s in alamarResult.samples" :key="s.name">
                        <td><strong>{{ s.name }}</strong></td>
                        <td>{{ s.mean_positive_control }}</td>
                        <td>{{ s.std_positive_control }}</td>
                        <td>{{ s.mean_negative_control ?? '—' }}</td>
                        <td>{{ s.std_negative_control ?? '—' }}</td>
                        <td>{{ s.n }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!-- Simple bar chart -->
                <div class="chart-block">
                  <div class="chart-title">{{ t('viability') }}</div>
                  <div class="chart-bars">
                    <div v-for="s in alamarResult.samples" :key="s.name" class="chart-bar-row">
                      <span class="chart-label">{{ s.name }}</span>
                      <div class="chart-bar-track">
                        <div class="chart-bar-fill" :style="{ width: Math.min(s.mean_positive_control, 100) + '%' }"></div>
                      </div>
                      <span class="chart-value">{{ s.mean_positive_control }}%</span>
                    </div>
                  </div>
                </div>
                <div class="formula-block">
                  <div class="muted">{{ alamarResult.formula_corrected }}</div>
                  <div class="muted">{{ alamarResult.formula_positive }}</div>
                  <div class="muted">{{ alamarResult.formula_negative }}</div>
                </div>
              </div>
            </div>

            <div v-else-if="activeExperimentTab === 'release'" class="experiment-card">
              <div class="section-title">{{ t('release') }}</div>
              <div class="experiment-hint">Загрузите Excel-файл с данными загрузки и релиза. Система рассчитает эффективность загрузки и профиль высвобождения.</div>
              <div class="form-row" style="margin-top:1rem">
                <input type="file" accept=".xlsx,.xls" @change="onReleaseFileChange" />
              </div>
              <div class="experiment-actions">
                <button class="btn btn-primary" :disabled="experimentLoading || !releaseFile" @click="processRelease">
                  {{ experimentLoading ? t('processing') : t('process') }}
                </button>
                <button v-if="releaseResult" class="btn" @click="downloadReleaseExcel">📊 {{ t('downloadExcel') }}</button>
              </div>
              <div v-if="experimentError" class="form-error">{{ experimentError }}</div>

              <div v-if="releaseResult && releaseResult.loading" class="experiment-results">
                <div class="group-title">{{ t('loadingBlock') }}</div>
                <div class="results-grid">
                  <div class="result-kv"><span class="result-k">{{ t('encapsulationEff') }}</span><span class="result-v">{{ releaseResult.loading.percent_loaded ?? '—' }} %</span></div>
                  <div class="result-kv"><span class="result-k">Запакованная масса</span><span class="result-v">{{ releaseResult.loading.encapsulated_mass_mg ?? '—' }} мг</span></div>
                </div>

                <div v-for="(profile, pIdx) in releaseResult.release_profiles" :key="pIdx" class="release-profile-block">
                  <div class="group-title">{{ t('releaseProfile') }} — {{ profile.solvent || '—' }}</div>
                  <div class="results-table-wrap">
                    <table class="results-table">
                      <thead>
                        <tr><th>{{ t('timeH') }}</th><th>OD mean</th><th>Конц. мг/мл</th><th>Масса мг</th><th>% в растворе</th><th>% осталось</th><th>% релиза</th></tr>
                      </thead>
                      <tbody>
                        <tr v-for="row in profile.rows" :key="row.time">
                          <td>{{ row.time }}</td>
                          <td>{{ row.od_mean ?? '—' }}</td>
                          <td>{{ row.concentration_mg_ml ?? '—' }}</td>
                          <td>{{ row.mass_mg ?? '—' }}</td>
                          <td>{{ row.percent_in_solution ?? '—' }}</td>
                          <td>{{ row.percent_remaining ?? '—' }}</td>
                          <td><strong>{{ row.percent_release ?? '—' }}</strong></td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                  <!-- Release chart -->
                  <div class="chart-block">
                    <div class="chart-title">{{ t('cumulativeRelease') }}</div>
                    <div class="chart-bars">
                      <div v-for="row in profile.rows" :key="row.time" class="chart-bar-row">
                        <span class="chart-label">{{ row.time }}</span>
                        <div class="chart-bar-track">
                          <div class="chart-bar-fill release-fill" :style="{ width: Math.min(row.percent_release || 0, 100) + '%' }"></div>
                        </div>
                        <span class="chart-value">{{ row.percent_release ?? '—' }}%</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div v-else class="experiment-card muted">{{ t('dls') }} — {{ language === 'ru' ? 'в разработке' : 'coming soon' }}</div>
          </section>

          <!-- ═══ TABLE CARD (reagents, equipment, consumables) ═══ -->
          <section v-else-if="activeTab !== 'protocols'" class="table-card">
            <div class="table-toolbar simple-toolbar">
              <div><div class="section-title">{{ currentTabLabel }}</div></div>
            </div>
            <div v-if="loading" class="muted">{{ t('loading') }}</div>
            <div v-else-if="errorMsg" class="muted">{{ errorMsg }}</div>
            <div v-else-if="!items.length" class="muted">{{ t('nothingFound') }}</div>

            <div v-else-if="!isMobile" class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>{{ t('codeNumber') }}</th>
                    <th>{{ t('name') }}</th>
                    <th v-if="activeTab === 'reagent'">{{ t('formulaCas') }}</th>
                    <th v-if="activeTab === 'equipment'">{{ t('documents') }}</th>
                    <th>{{ t('place') }}</th>
                    <th>{{ t('details') }}</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in items" :key="row.id">
                    <td class="mono">{{ row.code || row.inventory_number || '—' }}</td>
                    <td>
  <div class="name-cell">
    <div class="name-line">
      <strong :class="{ 'name-truncate': !expandedNames.has(row.id) && isLongName(row) }">{{ row.name || row.name_ru || row.name_en || t('noName') }}</strong>
      <span v-if="stockLevel(row) === 'low'" class="stock-badge stock-badge-low" title="Заканчивается">⚠️</span>
      <span v-if="stockLevel(row) === 'empty'" class="stock-badge stock-badge-empty" title="Закончилось">⛔</span>
    </div>
    <button v-if="isLongName(row)" type="button" class="name-toggle-btn" @click.prevent="toggleNameExpand(row.id)">{{ expandedNames.has(row.id) ? '▲' : '▼' }}</button>
  </div>
</td>
                    <td v-if="activeTab === 'reagent'">
                      <div>{{ row.formula || '—' }}</div><div class="muted">{{ row.cas || '' }}</div>
                    </td>
                    <td v-if="activeTab === 'equipment'">
                      <div v-if="row.document_url"><a :href="row.document_url" target="_blank" rel="noopener noreferrer">📄 {{ t('document') }}</a></div>
                      <div v-if="row.gdrive_link"><a :href="row.gdrive_link" target="_blank" rel="noopener noreferrer">☁️ {{ t('drive') }}</a></div>
                      <div v-if="!row.document_url && !row.gdrive_link" class="muted">—</div>
                    </td>
                    <td>{{ place(row) }}</td>
                    <td><div class="detail-list"><div v-for="(d,i) in details(row)" :key="i">{{ d }}</div></div></td>
                    <td>
                      <div class="row-actions row-actions-split">
                        <div class="row-actions-left">
                          <button type="button" class="icon-btn stock-plus" title="Увеличить количество" @click.prevent="changeQuantity(row, 1)">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="7.5" stroke="#16a34a" fill="#dcfce7"/><rect x="7" y="3.5" width="2" height="9" rx="1" fill="#16a34a"/><rect x="3.5" y="7" width="9" height="2" rx="1" fill="#16a34a"/></svg>
                          </button>
                          <button type="button" class="icon-btn stock-minus" title="Уменьшить количество" @click.prevent="changeQuantity(row, -1)">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="7.5" stroke="#dc2626" fill="#fee2e2"/><rect x="3.5" y="7" width="9" height="2" rx="1" fill="#dc2626"/></svg>
                          </button>
                        </div>
                        <div class="row-actions-right">
                          <button class="icon-btn" :title="t('edit')" @click="openEditModal(row)">✏️</button>
                          <button v-if="isAdmin" class="icon-btn" :title="t('remove')" @click="deleteItem(row)">🗑️</button>
                        </div>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div v-else class="mobile-catalog-view">
              <div class="mobile-search-block">
                <input v-model="state.q" type="search" :placeholder="t('searchItems')" class="mobile-search-input" />
                <div class="search-history-under mobile-search-history">
                  <div class="group-title">{{ t('recentSearches') }}</div>
                  <div v-if="recentSearches.length" class="history-list compact-history">
                    <button v-for="(entry, idx) in recentSearches" :key="'mrs'+idx" class="history-item compact-history-item" @click="openRecentSearch(entry)">
                      <strong>{{ entry.q }}</strong><span>{{ entry.section }} · {{ entry.time }}</span>
                    </button>
                  </div>
                  <div v-else class="muted history-empty">{{ t('noRecentData') }}</div>
                </div>
              </div>
              <div class="mobile-item-list">
                <div v-for="row in items" :key="row.id" class="mobile-item-card">
                  <div class="mobile-item-top">
                    <div class="name-cell">
  <strong class="mobile-item-name" :class="{ 'name-truncate': !expandedNames.has(row.id) }">{{ row.name || row.name_ru || row.name_en || t('noName') }}</strong>
  <button type="button" class="name-toggle-btn" @click.prevent="toggleNameExpand(row.id)">{{ expandedNames.has(row.id) ? '▲' : '▼' }}</button>
</div>
                    <div class="row-actions row-actions-split">
                      <div class="row-actions-left">
                        <button type="button" class="icon-btn stock-plus" title="Увеличить количество" @click.prevent="changeQuantity(row, 1)">
                          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="7.5" stroke="#16a34a" fill="#dcfce7"/><rect x="7" y="3.5" width="2" height="9" rx="1" fill="#16a34a"/><rect x="3.5" y="7" width="9" height="2" rx="1" fill="#16a34a"/></svg>
                        </button>
                        <button type="button" class="icon-btn stock-minus" title="Уменьшить количество" @click.prevent="changeQuantity(row, -1)">
                          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="7.5" stroke="#dc2626" fill="#fee2e2"/><rect x="3.5" y="7" width="9" height="2" rx="1" fill="#dc2626"/></svg>
                        </button>
                      </div>
                      <div class="row-actions-right">
                        <button class="icon-btn" :title="t('edit')" @click="openEditModal(row)">✏️</button>
                        <button v-if="isAdmin" class="icon-btn" :title="t('remove')" @click="deleteItem(row)">🗑️</button>
                      </div>
                    </div>
                  </div>
                  <div class="mobile-item-row" v-if="row.code || row.inventory_number">
                    <span class="mobile-item-label">{{ t('codeShort') }}</span><span class="mono">{{ row.code || row.inventory_number }}</span>
                  </div>
                  <div class="mobile-item-row" v-if="activeTab === 'reagent' && (row.formula || row.cas)">
                    <span class="mobile-item-label">{{ t('formulaShort') }}</span><span>{{ row.formula || '—' }}{{ row.cas ? ' · ' + row.cas : '' }}</span>
                  </div>
                  <div class="mobile-item-row"><span class="mobile-item-label">{{ t('place') }}:</span><span>{{ place(row) }}</span></div>
                  <div class="mobile-item-row" v-for="(d, i) in details(row)" :key="i"><span>{{ d }}</span></div>
                  <div class="mobile-item-row" v-if="activeTab === 'equipment' && (row.document_url || row.gdrive_link)">
                    <a v-if="row.document_url" :href="row.document_url" target="_blank" rel="noopener noreferrer">📄 {{ t('document') }}</a>
                    <a v-if="row.gdrive_link" :href="row.gdrive_link" target="_blank" rel="noopener noreferrer">☁️ Drive</a>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- ═══ PROTOCOLS SECTION ═══ -->
          <section v-else class="table-card">
            <div v-if="isMobile" class="table-toolbar simple-toolbar">
              <div><div class="section-title">{{ t('protocols') }}</div></div>
            </div>
            <div v-if="isMobile" class="protocol-search-wrap">
              <input v-model="protocolQuery" type="search" :placeholder="t('searchProtocols')" class="mobile-search-input" />
              <div class="search-history-under mobile-search-history">
                <div class="group-title">{{ t('recentSearches') }}</div>
                <div v-if="recentSearches.length" class="history-list compact-history">
                  <button v-for="(entry, idx) in recentSearches" :key="'prs'+idx" class="history-item compact-history-item" @click="openRecentSearch(entry)">
                    <strong>{{ entry.q }}</strong><span>{{ entry.section }} · {{ entry.time }}</span>
                  </button>
                </div>
                <div v-else class="muted history-empty">{{ t('noRecentData') }}</div>
              </div>
            </div>
            <div v-if="loading" class="muted">{{ t('loading') }}</div>
            <div v-else-if="errorMsg" class="muted">{{ errorMsg }}</div>
            <div v-else-if="!protocols.length" class="muted">{{ t('nothingFound') }}</div>
            <div v-else class="protocol-list">
              <div v-for="p in protocols" :key="p.id" class="protocol-card">
                <div class="protocol-header">
                  <div>
                    <span class="badge">{{ p.category }}</span>
                    <strong class="protocol-title">{{ p.code ? p.code + ' — ' : '' }}{{ p.name }}</strong>
                  </div>
                  <div class="row-actions">
                    <button class="icon-btn" :title="t('edit')" @click="openEditProtocolModal(p)">✏️</button>
                    <button v-if="isAdmin" class="icon-btn" :title="t('remove')" @click="deleteProtocol(p)">🗑️</button>
                  </div>
                </div>
                <pre class="protocol-steps">{{ p.steps }}</pre>
                <div v-if="p.notes" class="muted">{{ p.notes }}</div>
              </div>
            </div>
          </section>
        </main>
      </div>
    </template>

    <!-- ═══ MODALS ═══ -->

    <!-- Database Modal -->
    <div v-if="showDatabaseModal" class="modal-overlay" @click.self="showDatabaseModal = false">
      <div class="modal-card">
        <div class="modal-header">
          <h3>{{ t('databaseLog') }}</h3>
          <button class="modal-close" @click="showDatabaseModal = false">✕</button>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="showDatabaseModal = false">{{ t('cancel') }}</button>
        </div>
        <div class="modal-body">
          <div class="history-card">
            <div class="group-title">{{ t('recentAdds') }}</div>
            <div v-if="recentAdds.length" class="history-list">
              <div v-for="(entry, idx) in recentAdds" :key="'ra'+idx" class="history-item static-item">
                <strong>{{ entry.name }}</strong><span>{{ entry.type }} · {{ entry.place }} · {{ entry.time }}</span>
              </div>
            </div>
            <div v-else class="muted">{{ t('noRecentData') }}</div>
          </div>
          <div class="history-card">
            <div class="group-title">{{ t('dbLastUpdate') }}</div>
            <div v-if="filteredSiteUpdates.length" class="history-list">
              <div v-for="(entry, idx) in filteredSiteUpdates" :key="'su'+idx" class="history-item static-item">
                <strong>{{ entry.action }}: {{ entry.name }}</strong><span>{{ entry.place }} · {{ entry.time }}</span>
              </div>
            </div>
            <div v-else class="muted">{{ t('noRecentData') }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Item Modal -->
    <div v-if="showAddModal" class="modal-overlay modal-overlay-mobile-safe" @click.self="closeAddModal">
      <div class="modal-card modal-card-mobile-safe">
        <div class="modal-header">
          <h3>{{ editingItemId ? t('editItem') : t('addItem') }}</h3>
          <button class="modal-close" @click="closeAddModal">✕</button>
        </div>
        <div class="modal-footer-top modal-footer-top-mobile-safe">
          <button class="btn" @click="closeAddModal">{{ t('cancel') }}</button>
          <button class="btn btn-primary" :disabled="addSaving" @click="submitAddForm">{{ addSaving ? t('saving') : t('save') }}</button>
        </div>
        <div class="modal-body">
          <div v-if="!editingItemId && lastAddTemplates.length" class="repeat-last-line">
            <span class="group-title">{{ t('duplicateLast3') }}</span>
            <div class="repeat-last-buttons">
              <button v-for="(tpl, idx) in lastAddTemplates" :key="'repeat'+idx" type="button" class="btn btn-tiny repeat-btn" @click="applyTemplate(tpl)">
                {{ tpl.name || tpl.formula || tpl.inventory_number || '—' }}
              </button>
            </div>
          </div>
          <div class="form-row">
            <label>{{ t('type') }}</label>
            <select v-model="addForm.item_type">
              <option value="reagent">{{ t('reagentOne') }}</option>
              <option value="equipment">{{ t('equipmentOne') }}</option>
              <option value="consumable">{{ t('consumableOne') }}</option>
              <option value="furniture">{{ t('furniture') }}</option>
              <option value="other">{{ t('otherOne') }}</option>
            </select>
          </div>
          <div class="form-row">
            <label>{{ t('nameRequired') }}</label>
            <input v-model="addForm.name" type="text" placeholder="Например: Натрия хлорид" />
          </div>
          <div class="form-grid-2">
            <div class="form-row"><label>{{ t('nameRu') }}</label><input v-model="addForm.name_ru" type="text" /></div>
            <div class="form-row"><label>{{ t('nameEn') }}</label><input v-model="addForm.name_en" type="text" /></div>
          </div>
          <div class="form-grid-2" v-if="addForm.item_type === 'reagent'">
            <div class="form-row"><label>{{ t('formula') }}</label><input v-model="addForm.formula" type="text" placeholder="NaCl" /></div>
            <div class="form-row"><label>{{ t('cas') }}</label><input v-model="addForm.cas" type="text" placeholder="7647-14-5" /></div>
          </div>
          <div class="form-grid-2">
            <div class="form-row"><label>{{ t('manufacturer') }}</label><input v-model="addForm.manufacturer" type="text" /></div>
            <div class="form-row"><label>{{ t('catalogNumber') }}</label><input v-model="addForm.catalog_number" type="text" /></div>
          </div>
          <div class="form-grid-2">
            <div class="form-row"><label>{{ t('inventoryNumber') }}</label><input v-model="addForm.inventory_number" type="text" /></div>
            <div class="form-row"><label>{{ t('serialNumber') }}</label><input v-model="addForm.serial_number" type="text" /></div>
          </div>
          <div class="form-grid-2" v-if="addForm.item_type === 'reagent' || addForm.item_type === 'consumable'">
            <div class="form-row"><label>{{ t('quantity') }}</label><input v-model="addForm.quantity" type="text" placeholder="10" /></div>
            <div class="form-row"><label>{{ t('unit') }}</label><input v-model="addForm.unit" type="text" placeholder="мл, шт, кг" /></div>
          </div>
          <div class="form-grid-2" v-if="addForm.item_type === 'equipment'">
            <div class="form-row"><label>{{ t('documentUrl') }}</label><input v-model="addForm.document_url" type="text" placeholder="https://..." /></div>
            <div class="form-row"><label>{{ t('gdriveLink') }}</label><input v-model="addForm.gdrive_link" type="text" placeholder="https://drive.google.com/..." /></div>
          </div>
          <div class="form-row"><label>{{ t('notes') }}</label><textarea v-model="addForm.notes" rows="4"></textarea></div>
          <div class="form-section-title">{{ t('location') }}</div>
          <div class="form-grid-4">
            <div class="form-row"><label>{{ t('roomField') }}</label><input v-model="addForm.room" type="text" placeholder="306" /></div>
            <div class="form-row"><label>{{ t('cabinet') }}</label><input v-model="addForm.cabinet" type="text" /></div>
            <div class="form-row"><label>{{ t('shelf') }}</label><input v-model="addForm.shelf" type="text" /></div>
            <div class="form-row"><label>{{ t('slot') }}</label><input v-model="addForm.slot" type="text" /></div>
          </div>
          <div v-if="addError" class="form-error">{{ addError }}</div>
        </div>
      </div>
    </div>

    <!-- Protocol Modal -->
    <div v-if="showProtocolModal" class="modal-overlay" @click.self="closeProtocolModal">
      <div class="modal-card">
        <div class="modal-header">
          <h3>{{ editingProtocolId ? t('protocolEdit') : t('protocolAdd') }}</h3>
          <button class="modal-close" @click="closeProtocolModal">✕</button>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="closeProtocolModal">{{ t('cancel') }}</button>
          <button class="btn btn-primary" :disabled="protocolSaving" @click="submitProtocolForm">{{ protocolSaving ? t('saving') : t('save') }}</button>
        </div>
        <div class="modal-body">
          <div class="form-grid-2">
            <div class="form-row"><label>{{ t('code') }}</label><input v-model="protocolForm.code" type="text" placeholder="P22" /></div>
            <div class="form-row"><label>{{ t('category') }}</label><input v-model="protocolForm.category" type="text" placeholder="Микро- и наночастицы" /></div>
          </div>
          <div class="form-row"><label>{{ t('nameRequired') }}</label><input v-model="protocolForm.name" type="text" placeholder="Наночастицы CaCO3" /></div>
          <div class="form-row"><label>{{ t('synthesisSteps') }}</label><textarea v-model="protocolForm.steps" rows="10" placeholder="1) ...&#10;2) ..."></textarea></div>
          <div class="form-row"><label>{{ t('notes') }}</label><textarea v-model="protocolForm.notes" rows="3"></textarea></div>
          <div v-if="protocolError" class="form-error">{{ protocolError }}</div>
        </div>
      </div>
    </div>

    <!-- Login Modal -->
    <div v-if="showLoginModal" class="modal-overlay" @click.self="closeLoginModal">
      <div class="modal-card modal-card-small">
        <div class="modal-header">
          <h3>{{ t('loginTitle') }}</h3>
          <button class="modal-close" @click="closeLoginModal">✕</button>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="closeLoginModal">{{ t('cancel') }}</button>
          <button class="btn btn-primary" @click="submitLogin">{{ t('loginButton') }}</button>
        </div>
        <div class="modal-body">
          <div class="admin-hint">{{ t('adminHint') }}</div>
          <div class="form-row"><label>{{ t('login') }}</label><input v-model="loginForm.login" type="text" autocomplete="username" @keyup.enter="submitLogin" /></div>
          <div class="form-row"><label>{{ t('password') }}</label><input v-model="loginForm.password" type="password" autocomplete="current-password" @keyup.enter="submitLogin" /></div>
          <div v-if="loginError" class="form-error">{{ loginError }}</div>
        </div>
      </div>
    </div>

    <!-- Booking Modal -->
    <div v-if="showBookingModal" class="modal-overlay modal-overlay-mobile-safe" @click.self="closeBookingModal">
      <div class="modal-card modal-card-mobile-safe">
        <div class="modal-header">
          <h3>{{ editingBookingId ? t('bookingEdit') : t('bookingAdd') }}</h3>
          <button class="modal-close" @click="closeBookingModal">✕</button>
        </div>
        <div class="modal-footer-top modal-footer-top-mobile-safe">
          <button class="btn" @click="closeBookingModal">{{ t('bookingCancel') }}</button>
          <button class="btn btn-primary" :disabled="bookingSaving" @click="submitBooking">{{ bookingSaving ? t('saving') : t('bookingConfirm') }}</button>
        </div>
        <div class="modal-body">
          <div class="booking-modal-instr-label">
            📋 {{ selectedInstr ? (selectedInstr.icon + ' ' + t(selectedInstr.labelKey)) : '' }}
            <span class="muted" v-if="bookingForm.date">· {{ bookingForm.date }}</span>
          </div>
          <div class="booking-form-hint">Заполните информацию о своём эксперименте, чтобы другие участники лаборатории могли видеть занятость прибора.</div>

          <div class="form-row">
            <label>{{ t('bookingWho') }} *</label>
            <input v-model="bookingForm.who" type="text" placeholder="Иванов И.И. / ФИО или имя" />
          </div>
          <div class="form-row">
            <label>{{ t('bookingExp') }} *</label>
            <input v-model="bookingForm.experiment" type="text" placeholder="Измерение размеров наночастиц CaCO3" />
          </div>

          <!-- Time Slider Block -->
          <div class="form-row">
            <label>{{ t('bookingDuration') }}: {{ startTimeLabel }} – {{ endTimeLabel }}</label>
            <div class="time-slider-block">
              <div class="time-slider-row">
                <span class="time-slider-tag">Начало</span>
                <input type="range" class="time-range" min="480" :max="maxStartMinutes" step="30" v-model.number="bookingForm.startMinutes" />
                <span class="time-slider-value">{{ startTimeLabel }}</span>
              </div>
              <div class="time-slider-row">
                <span class="time-slider-tag">{{ t('bookingDuration') }}</span>
                <input type="range" class="time-range" min="30" max="240" step="30" v-model.number="bookingForm.duration" />
                <span class="time-slider-value">{{ durationLabel }}</span>
              </div>
              <div class="time-timeline">
                <div class="time-timeline-track">
                  <div class="time-timeline-fill" :style="timelineFillStyle"></div>
                </div>
                <div class="time-timeline-labels">
                  <span>08:00</span><span>14:00</span><span>20:00</span>
                </div>
              </div>
            </div>
          </div>

          <div class="form-row">
            <label>{{ t('bookingComments') }}</label>
            <textarea v-model="bookingForm.comments" rows="3" placeholder="Дополнительная информация, контакт и т.д."></textarea>
          </div>
          <div v-if="bookingError" class="form-error">{{ bookingError }}</div>
        </div>
      </div>
    </div>

    <!-- Cell Booking Modal -->
    <div v-if="showCellBookingModal" class="modal-overlay modal-overlay-mobile-safe" @click.self="closeCellBookingModal">
      <div class="modal-card modal-card-mobile-safe">
        <div class="modal-header">
          <h3>{{ editingCellBookingId ? t('bookingEdit') : t('bookingAdd') }} — {{ t('cellBox') }} №{{ cellBookingForm.boxNumber }}</h3>
          <button class="modal-close" @click="closeCellBookingModal">✕</button>
        </div>
        <div class="modal-footer-top modal-footer-top-mobile-safe">
          <button class="btn" @click="closeCellBookingModal">{{ t('bookingCancel') }}</button>
          <button class="btn btn-primary" :disabled="cellBookingSaving" @click="submitCellBooking">{{ cellBookingSaving ? t('saving') : t('bookingConfirm') }}</button>
        </div>
        <div class="modal-body">
          <div class="booking-modal-instr-label">
            🧫 {{ t('cellBox') }} №{{ cellBookingForm.boxNumber }}
            <span class="muted" v-if="cellBookingForm.date">· {{ cellBookingForm.date }}</span>
          </div>
          <div class="form-row">
            <label>{{ t('bookingWho') }} *</label>
            <input v-model="cellBookingForm.who" type="text" placeholder="Иванов И.И." />
          </div>
          <div class="form-row">
            <label>{{ t('bookingExp') }} *</label>
            <input v-model="cellBookingForm.experiment" type="text" placeholder="Посев клеток" />
          </div>
          <div class="form-row">
            <label>{{ t('bookingDuration') }}: {{ minutesToLabel(cellBookingForm.startMinutes) }} – {{ minutesToLabel(cellBookingForm.startMinutes + cellBookingForm.duration) }}</label>
            <div class="time-slider-block">
              <div class="time-slider-row">
                <span class="time-slider-tag">Начало</span>
                <input type="range" class="time-range" min="480" :max="DAY_END - cellBookingForm.duration" step="30" v-model.number="cellBookingForm.startMinutes" />
                <span class="time-slider-value">{{ minutesToLabel(cellBookingForm.startMinutes) }}</span>
              </div>
              <div class="time-slider-row">
                <span class="time-slider-tag">{{ t('bookingDuration') }}</span>
                <input type="range" class="time-range" min="30" max="240" step="30" v-model.number="cellBookingForm.duration" />
                <span class="time-slider-value">{{ DURATIONS.find(d=>d.val===cellBookingForm.duration)?.val || cellBookingForm.duration }} мин</span>
              </div>
            </div>
          </div>
          <div v-if="cellBookingError" class="form-error">{{ cellBookingError }}</div>
        </div>
      </div>
    </div>

    <!-- Conflict Confirmation Modal -->
    <div v-if="showConflictModal" class="modal-overlay" @click.self="closeConflictModal">
      <div class="modal-card modal-card-small">
        <div class="modal-header">
          <h3>⚠️ {{ t('confirmConflictTitle') }}</h3>
          <button class="modal-close" @click="closeConflictModal">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-error" style="background:color-mix(in srgb,var(--color-warning)10%,var(--color-surface));border-color:var(--color-warning);color:var(--color-warning);padding:1rem;border-radius:var(--radius-md);">
            {{ t('confirmConflictText').replace('{who}', conflictInfo.who).replace('{exp}', conflictInfo.experiment) }}
          </div>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="closeConflictModal">{{ t('cancelAnyway') }}</button>
          <button class="btn btn-primary" @click="confirmConflict">{{ t('confirmAnyway') }}</button>
        </div>
      </div>
    </div>

    <!-- Instrument Info Modal -->
    <div v-if="showInstrInfoModal" class="modal-overlay" @click.self="closeInstrInfoModal">
      <div class="modal-card modal-card-info">
        <div class="modal-header">
          <h3>{{ selectedInstr?.icon }} {{ selectedInstr ? t(selectedInstr.labelKey) : '' }}</h3>
          <button class="modal-close" @click="closeInstrInfoModal">✕</button>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="closeInstrInfoModal">{{ t('cancel') }}</button>
        </div>
        <div class="modal-body">
          <div class="info-tabs">
            <button class="info-tab" :class="{ active: bookingInfoTab === 'protocol' }" @click="bookingInfoTab = 'protocol'">📋 {{ t('bookingOperProtocol') }}</button>
            <button class="info-tab" :class="{ active: bookingInfoTab === 'postprocess' }" @click="bookingInfoTab = 'postprocess'">📊 {{ t('bookingPostProcess') }}</button>
            <button class="info-tab" :class="{ active: bookingInfoTab === 'articles' }" @click="bookingInfoTab = 'articles'">📄 {{ t('bookingExamples') }}</button>
          </div>

          <div v-if="bookingInfoTab === 'protocol'" class="info-content">
            <div class="info-hint">Следуйте этому протоколу при работе с прибором. Если у вас есть вопросы — обратитесь к ответственному за прибор или администратору лаборатории.</div>
            <pre class="info-text">{{ selectedInstrInfo.protocol || 'Протокол будет добавлен позже.' }}</pre>
          </div>
          <div v-if="bookingInfoTab === 'postprocess'" class="info-content">
            <div class="info-hint">Инструкция по обработке данных после измерения. Следуйте этим шагам для получения воспроизводимых результатов.</div>
            <pre class="info-text">{{ selectedInstrInfo.postprocess || 'Инструкция будет добавлена позже.' }}</pre>
          </div>
          <div v-if="bookingInfoTab === 'articles'" class="info-content">
            <div class="info-hint">Примеры статей, в которых использован данный метод. Обращайтесь к ним как к образцам оформления результатов.</div>
            <div v-if="selectedInstrInfo.articles && selectedInstrInfo.articles.length" class="articles-list">
              <div v-for="(a, i) in selectedInstrInfo.articles" :key="i" class="article-item">📄 {{ a }}</div>
            </div>
            <div v-else class="muted">Примеры статей будут добавлены позже.</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Admin Status Modal -->
    <div v-if="showAdminStatusModal" class="modal-overlay" @click.self="closeAdminStatusModal">
      <div class="modal-card modal-card-admin-status">
        <div class="modal-header">
          <h3>🔧 {{ t('bookingSetStatus') }} — {{ selectedInstr ? t(selectedInstr.labelKey) : '' }}</h3>
          <button class="modal-close" @click="closeAdminStatusModal">✕</button>
        </div>
        <div class="modal-footer-top">
          <button class="btn" @click="closeAdminStatusModal">{{ t('cancel') }}</button>
          <button class="btn btn-primary" @click="submitAdminStatus">{{ t('save') }}</button>
        </div>
        <div class="modal-body">
          <div class="admin-hint">Только администратор может изменить статус прибора. Пользователи видят предупреждение о недоступности.</div>

          <div class="form-row">
            <label>{{ t('bookingStatus') }}</label>
            <div class="status-radio-group">
              <label class="status-radio">
                <input type="radio" v-model="adminStatusForm.status" value="ok" />
                <span class="status-dot status-ok"></span> {{ t('bookingStatusOk') }}
              </label>
              <label class="status-radio">
                <input type="radio" v-model="adminStatusForm.status" value="maint" />
                <span class="status-dot status-maint"></span> {{ t('bookingStatusMaint') }}
              </label>
            </div>
          </div>

          <div class="form-row">
            <label>{{ t('bookingMaintReason') }}</label>
            <textarea v-model="adminStatusForm.reason" rows="2" placeholder="Плановое ТО, поломка лазера и т.д."></textarea>
          </div>

          <div class="form-row">
            <label>{{ t('maintSelectDates') }}</label>
            <div class="maint-date-picker">
              <div v-for="(week, wIdx) in maintDatePickerWeeks" :key="wIdx" class="maint-week-row">
                <div class="maint-week-label">{{ wIdx === 0 ? t('thisWeek') : t('nextWeek') }}</div>
                <div class="maint-days-row">
                  <button
                    v-for="day in week" :key="toDateStr(day)"
                    class="maint-date-btn"
                    :class="{ 'maint-date-selected': isMaintDateSelected(toDateStr(day)) }"
                    @click="toggleMaintDate(toDateStr(day))"
                  >
                    <span class="maint-date-weekday">{{ day.toLocaleDateString(language === 'ru' ? 'ru-RU' : 'en-GB', { weekday: 'short' }) }}</span>
                    <span class="maint-date-day">{{ day.getDate() }}.{{ String(day.getMonth()+1).padStart(2,'0') }}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
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
  --color-success: #16a34a;
  --color-warning: #d97706;
  --color-error: #dc2626;
  --shadow-sm: 0 4px 20px rgba(12,28,38,.07);
  --shadow-lg: 0 16px 60px rgba(12,28,38,.12);
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
  --color-success: #4ade80;
  --color-warning: #fbbf24;
  --color-error: #f87171;
  --shadow-sm: 0 4px 24px rgba(0,0,0,.28);
  --shadow-lg: 0 20px 80px rgba(0,0,0,.38);
}
* { box-sizing: border-box; }
html, body { min-height: 100%; margin: 0; overflow-x: hidden !important; overflow-y: auto !important; width: 100%; }
#app { min-height: 100dvh; overflow-x: hidden; width: 100%; }
body {
  font-family: var(--font-body);
  font-size: var(--text-base);
  background: radial-gradient(circle at top left, rgba(84,193,195,.10), transparent 28%),
    radial-gradient(circle at top right, rgba(63,125,177,.10), transparent 22%),
    var(--color-bg);
  color: var(--color-text);
}
body.modal-open { overflow: hidden !important; height: 100%; position: fixed; width: 100%; }
button, input, select, textarea { font: inherit; }
button { cursor: pointer; }

.app-shell { min-height: 100dvh; width: 100%; overflow-x: hidden; }
.workspace { display: grid; grid-template-rows: auto 1fr; min-width: 0; width: 100%; overflow-x: hidden; }
.desktop-header {
  padding: var(--space-4) var(--space-8);
  display: grid; gap: var(--space-4);
  border-bottom: 1px solid var(--color-border);
  background: color-mix(in srgb, var(--color-surface) 92%, transparent);
  backdrop-filter: blur(12px);
}
.desktop-header-top, .desktop-tabs-row, .desktop-filter-row, .desktop-context-row {
  display: flex; align-items: flex-start; justify-content: space-between; gap: var(--space-4); flex-wrap: wrap;
}
.brand { display: flex; align-items: center; gap: var(--space-4); min-width: 0; }
.brand-copy { min-width: 0; }
.brand h1 { margin: 0; font-family: var(--font-display); font-size: 1rem; line-height: 1.25; }
.brand p { margin: .2rem 0 0; color: var(--color-text-muted); font-size: var(--text-sm); }
.logo { width: 56px; height: 56px; border-radius: 50%; flex-shrink: 0; background: transparent; display: grid; place-items: center; overflow: hidden; }
.logo img { width: 100%; height: 100%; object-fit: contain; display: block; }
.mobile-logo { width: 72px; height: 72px; margin: 0 auto var(--space-3); }
.topbar-right-controls { display: flex; gap: .75rem; align-items: center; flex-wrap: wrap; }
.theme-toggle, .btn {
  border: 1px solid var(--color-border); background: var(--color-surface); color: var(--color-text);
  border-radius: 999px; padding: .72rem 1rem;
}
.btn-primary { background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2)); color: white; border-color: transparent; }
.btn-primary:disabled { opacity: .6; cursor: not-allowed; }
.btn-ghost { background: transparent; }
.btn-tiny { padding: .42rem .72rem; font-size: var(--text-xs); }
.btn-database { min-width: 44px; padding-inline: .9rem; }
.btn-admin-status { background: linear-gradient(135deg, #78350f, #d97706); color: white; border-color: transparent; }
.lang-btn, .lang-toggle-mini { font-size: var(--text-sm); min-width: 56px; font-weight: 700; color: var(--color-text); }
[data-theme="dark"] .lang-btn, [data-theme="dark"] .lang-toggle-mini, [data-theme="dark"] .back-btn { color: #ffffff; }
.admin-btn { font-size: var(--text-sm); }
.admin-btn-on { background: linear-gradient(135deg, #16a34a, #4ade80); border-color: transparent; color: #022c22; }
.admin-badge-mini { width: 40px; height: 40px; border-radius: 999px; border: none; background: linear-gradient(135deg, #16a34a, #4ade80); color: #ffffff; font-weight: 800; font-size: 1rem; display: grid; place-items: center; box-shadow: 0 4px 14px rgba(22,163,74,.35); flex-shrink: 0; }
.toolbar-block { display: flex; flex-direction: column; gap: .5rem; min-width: 0; }
.group-title { font-size: var(--text-xs); letter-spacing: .08em; text-transform: uppercase; color: var(--color-text-muted); }
.section-toolbar-full { width: 100%; }
.section-tabs-line { width: 100%; display: flex; align-items: flex-start; justify-content: space-between; gap: 1rem; flex-wrap: wrap; }
.section-left { display: grid; gap: .45rem; min-width: 0; }
.section-right-actions { display: flex; gap: .65rem; flex-wrap: wrap; align-items: center; }
.section-tabs { display: flex; flex-wrap: wrap; gap: .65rem; }
.section-tab {
  display: inline-flex; align-items: center; gap: .55rem;
  border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text);
  padding: .72rem 1rem; border-radius: 999px; font-size: var(--text-sm); white-space: nowrap;
}
.section-tab.active { background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2)); color: white; border-color: transparent; }
.section-tab-booking.active { background: linear-gradient(135deg, #7c3aed, #4f46e5); }
.section-tab-experiments.active { background: linear-gradient(135deg, #059669, #10b981); }
.tab-count, .room-chip-count { display: inline-flex; align-items: center; justify-content: center; min-width: 24px; height: 24px; padding: 0 .4rem; border-radius: 999px; font-size: .78rem; font-variant-numeric: tabular-nums; background: rgba(255,255,255,.15); }
.section-tab:not(.active) .tab-count, .room-chip:not(.active) .room-chip-count, .cabinet-chip:not(.active) .room-chip-count { background: var(--color-accent); color: var(--color-primary-2); }
.filters-block { width: 100%; }
.room-line, .cabinet-line { display: flex; flex-wrap: wrap; gap: .65rem; align-items: center; }
.room-chip, .cabinet-chip { display: inline-flex; align-items: center; gap: .55rem; border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); padding: .62rem .95rem; border-radius: 999px; font-size: var(--text-sm); }
.room-chip.active, .cabinet-chip.active { background: color-mix(in srgb, var(--color-primary) 16%, var(--color-surface)); border-color: color-mix(in srgb, var(--color-primary) 45%, var(--color-border)); }
.instr-chip { gap: .4rem; }
.instr-maint { border-color: var(--color-warning); background: color-mix(in srgb, var(--color-warning) 10%, var(--color-surface)); }
.instr-maint-dot { margin-left: .2rem; }
.desktop-context-row { align-items: stretch; }
.desktop-search-only-row { display: block; }
.desktop-search-only-row .context-search-block { width: 100%; max-width: none; }
.context-search-block, .history-card {
  background: var(--color-surface); border: 1px solid var(--color-border);
  border-radius: var(--radius-xl); box-shadow: var(--shadow-sm); padding: var(--space-4);
}
.search-block-wide { flex: 1 1 700px; min-width: 320px; }
.desktop-search-wrap, .protocol-search-wrap { display: flex; width: 100%; margin-top: .35rem; }
.search-history-under { margin-top: .9rem; }
.compact-history { gap: .45rem; }
.compact-history-item { padding: .68rem .82rem; }
.history-empty { margin-top: .5rem; }
.history-list { display: grid; gap: .6rem; margin-top: .6rem; }
.history-item { display: grid; gap: .18rem; text-align: left; width: 100%; border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); border-radius: var(--radius-md); padding: .75rem .85rem; }
.history-item span { color: var(--color-text-muted); font-size: var(--text-xs); }
.static-item { cursor: default; }
.main { padding: var(--space-5) var(--space-8) var(--space-8); width: 100%; overflow-x: hidden; }
.table-card { background: var(--color-surface); border: 1px solid var(--color-border); box-shadow: var(--shadow-sm); border-radius: var(--radius-xl); padding: var(--space-4); width: 100%; overflow-x: hidden; }
input[type="search"] { flex: 1; min-width: 0; padding: 1rem 1.1rem; border-radius: 999px; border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); width: 100%; }
.mobile-search-input { border-radius: 999px; width: 100%; padding: 0.95rem 1.2rem; }
.table-toolbar { display: flex; justify-content: space-between; align-items: end; padding: var(--space-2) var(--space-2) var(--space-4); }
.simple-toolbar { padding-top: 0; }
.section-title { font-family: var(--font-display); font-size: var(--text-lg); }
.table-wrap { overflow-x: auto; border-radius: 1rem; max-width: 100%; }
table { width: 100%; border-collapse: collapse; }
thead th { position: sticky; top: 0; background: var(--color-surface-2); backdrop-filter: blur(10px); font-size: var(--text-xs); letter-spacing: .08em; text-transform: uppercase; color: var(--color-text-muted); text-align: left; padding: 1rem; border-bottom: 1px solid var(--color-border); }
tbody td { padding: 1rem; border-bottom: 1px solid rgba(141,164,177,.12); vertical-align: top; }
tbody tr:hover { background: rgba(84,193,195,.06); }
.badge { display: inline-flex; align-items: center; border-radius: 999px; padding: .38rem .65rem; font-size: var(--text-xs); text-transform: uppercase; letter-spacing: .08em; background: var(--color-accent); color: var(--color-primary); margin-right: .6rem; }
.mono { font-variant-numeric: tabular-nums; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: var(--text-sm); word-break: break-all; }
.muted { color: var(--color-text-muted); }
.detail-list { display: grid; gap: .35rem; font-size: var(--text-sm); }
.icon-btn { border: 1px solid var(--color-border); background: var(--color-surface-2); border-radius: 999px; width: 34px; height: 34px; display: grid; place-items: center; font-size: .95rem; flex-shrink: 0; }
.icon-btn:hover { background: var(--color-accent); }
.row-actions { display: flex; gap: .3rem; }
.row-actions-split {
  width: 100%;
  justify-content: flex-start;
  gap: 1.25rem;
}
.row-actions-left,
.row-actions-right {
  display: flex;
  align-items: center;
  gap: .4rem;
}
.stock-plus,
.stock-minus {
  padding: 2px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.stock-plus:hover svg circle { fill: #bbf7d0; }
.stock-minus:hover svg circle { fill: #fecaca; }

.protocol-list { display: grid; gap: var(--space-4); width: 100%; }
.protocol-card { border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: var(--space-5); background: var(--color-surface-2); width: 100%; overflow-x: hidden; }
.protocol-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-3); flex-wrap: wrap; gap: .5rem; }
.protocol-title { font-family: var(--font-display); font-size: var(--text-base); overflow-wrap: break-word; }
.protocol-steps { white-space: pre-wrap; font-family: var(--font-body); font-size: var(--text-sm); margin: 0; color: var(--color-text); overflow-wrap: break-word; }

/* ═══ BOOKING STYLES ═══ */
.booking-section { display: grid; gap: var(--space-4); }
.maint-alert-banner {
  background: color-mix(in srgb, var(--color-error) 12%, var(--color-surface));
  border: 1.5px solid var(--color-error);
  color: var(--color-error);
  border-radius: var(--radius-lg);
  padding: var(--space-4) var(--space-5);
  font-size: var(--text-sm);
  display: flex; align-items: center; gap: var(--space-3); flex-wrap: wrap;
}
.maint-reason { color: var(--color-text-muted); font-style: italic; }
.booking-header-row {
  display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: var(--space-3);
  background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl);
  padding: var(--space-4) var(--space-5); box-shadow: var(--shadow-sm);
}
.booking-instr-title { display: flex; align-items: center; gap: var(--space-3); }
.booking-instr-icon { font-size: 2rem; }
.booking-header-actions { display: flex; gap: var(--space-2); flex-wrap: wrap; }
.week-toggle-row { display: flex; gap: .5rem; }
.week-tab { border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); border-radius: 999px; padding: .65rem 1.2rem; font-size: var(--text-sm); }
.week-tab.active { background: linear-gradient(135deg, #7c3aed, #4f46e5); color: white; border-color: transparent; }
.booking-inline-error { background: color-mix(in srgb, var(--color-error) 10%, var(--color-surface)); border: 1px solid var(--color-error); color: var(--color-error); border-radius: var(--radius-md); padding: var(--space-3) var(--space-4); font-size: var(--text-sm); }
.booking-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: var(--space-2);
  overflow-x: auto;
  min-width: 0;
}
.booking-day-col { min-width: 0; display: flex; flex-direction: column; gap: var(--space-2); }
.booking-day-header {
  background: var(--color-surface-2); border: 1px solid var(--color-border);
  border-radius: var(--radius-md); padding: var(--space-2) var(--space-3);
  text-align: center; font-size: var(--text-xs);
}
.booking-day-header.day-today { border-color: var(--color-primary); background: color-mix(in srgb, var(--color-primary) 10%, var(--color-surface)); }
.booking-day-header.day-unavail { border-color: var(--color-error); background: color-mix(in srgb, var(--color-error) 8%, var(--color-surface)); color: var(--color-error); }
.booking-day-name { font-weight: 600; }
.booking-day-maint-label { font-size: .7rem; color: var(--color-error); margin-top: .2rem; }
.booking-day-slots { display: flex; flex-direction: column; gap: var(--space-2); flex: 1; }
.booking-slot { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3); font-size: var(--text-sm); display: grid; gap: .25rem; }
.booking-slot-who { font-weight: 600; color: var(--color-primary); font-size: var(--text-xs); }
.booking-slot-exp { font-weight: 500; overflow-wrap: break-word; }
.booking-slot-dur { font-size: var(--text-xs); }
.booking-slot-comment { font-size: var(--text-xs); }
.booking-slot-actions { display: flex; gap: .25rem; justify-content: flex-end; margin-top: .25rem; }
.booking-empty-day { color: var(--color-text-muted); font-size: var(--text-xs); text-align: center; padding: var(--space-2); }
.booking-add-btn {
  border: 1.5px dashed var(--color-border); background: transparent; color: var(--color-text-muted);
  border-radius: var(--radius-md); padding: var(--space-2); font-size: var(--text-xs); width: 100%;
  transition: border-color .15s, color .15s;
}
.booking-add-btn:hover { border-color: var(--color-primary); color: var(--color-primary); }
.booking-maint-day { background: color-mix(in srgb, var(--color-error) 6%, var(--color-surface)); border: 1px solid color-mix(in srgb, var(--color-error) 30%, var(--color-border)); border-radius: var(--radius-md); padding: var(--space-3); font-size: var(--text-xs); color: var(--color-error); text-align: center; }
.booking-mobile-list { display: grid; gap: var(--space-3); }
.booking-mobile-day { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); overflow: hidden; }
.booking-mobile-day-header { padding: var(--space-3) var(--space-4); font-weight: 700; font-size: var(--text-sm); background: var(--color-surface-2); border-bottom: 1px solid var(--color-border); display: flex; justify-content: space-between; }
.booking-mobile-day-header.day-today { background: color-mix(in srgb, var(--color-primary) 12%, var(--color-surface)); }
.booking-mobile-day-header.day-unavail { background: color-mix(in srgb, var(--color-error) 10%, var(--color-surface)); }
.booking-slot-mobile { margin: var(--space-2) var(--space-3); }
.booking-no-entries { padding: var(--space-3) var(--space-4); font-size: var(--text-sm); }
.booking-add-btn-mobile { display: block; width: calc(100% - 2*var(--space-3)); margin: var(--space-2) var(--space-3) var(--space-3); border: 1.5px dashed var(--color-border); background: transparent; color: var(--color-text-muted); border-radius: var(--radius-md); padding: var(--space-3); font-size: var(--text-sm); text-align: center; }
.booking-modal-instr-label { font-size: var(--text-sm); font-weight: 600; color: var(--color-primary); }
.booking-form-hint { font-size: var(--text-sm); color: var(--color-text-muted); background: var(--color-surface-2); border-radius: var(--radius-md); padding: var(--space-3); }
.modal-card-info { width: min(760px, 100%); }
.info-tabs { display: flex; gap: .5rem; flex-wrap: wrap; margin-bottom: var(--space-3); }
.info-tab { border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); border-radius: 999px; padding: .6rem 1rem; font-size: var(--text-sm); }
.info-tab.active { background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2)); color: white; border-color: transparent; }
.info-content { display: grid; gap: var(--space-3); }
.info-hint { font-size: var(--text-sm); color: var(--color-text-muted); background: color-mix(in srgb, var(--color-primary) 8%, var(--color-surface)); border-left: 3px solid var(--color-primary); border-radius: 0 var(--radius-sm) var(--radius-sm) 0; padding: var(--space-3) var(--space-4); }
.info-text { white-space: pre-wrap; font-family: var(--font-body); font-size: var(--text-sm); margin: 0; color: var(--color-text); background: var(--color-surface-2); border-radius: var(--radius-md); padding: var(--space-4); overflow-wrap: break-word; }
.articles-list { display: grid; gap: .5rem; }
.article-item { font-size: var(--text-sm); background: var(--color-surface-2); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3) var(--space-4); }

/* Cell culture */
.cell-culture-divider { margin-top: var(--space-8); padding-top: var(--space-6); border-top: 2px solid var(--color-border); }
.cell-culture-title { font-family: var(--font-display); font-size: var(--text-lg); color: var(--color-primary); }
.cell-box-section { margin-top: var(--space-4); }
.cell-box-header { font-weight: 700; font-size: var(--text-sm); margin-bottom: var(--space-2); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: .05em; }
.cell-box-accordion-btn {
  width: 100%; display: flex; justify-content: space-between; align-items: center;
  padding: var(--space-4) var(--space-5);
  background: var(--color-surface); border: 1.5px solid var(--color-border);
  border-radius: var(--radius-lg); font-weight: 700; font-size: var(--text-base);
  color: var(--color-text); margin-bottom: var(--space-2);
  transition: border-color .15s, background .15s;
}
.cell-box-accordion-btn:hover { border-color: var(--color-primary); }
.cell-box-accordion-open { border-color: var(--color-primary); background: color-mix(in srgb, var(--color-primary) 8%, var(--color-surface)); }
.cell-box-accordion-arrow { font-size: var(--text-sm); color: var(--color-text-muted); }

/* Admin status modal with visual date picker */
.modal-card-admin-status { width: min(560px, 100%); }
.status-radio-group { display: flex; flex-direction: column; gap: .65rem; margin-top: .4rem; }
.status-radio { display: flex; align-items: center; gap: .6rem; font-size: var(--text-sm); cursor: pointer; }
.status-dot { width: 12px; height: 12px; border-radius: 999px; flex-shrink: 0; }
.status-ok { background: var(--color-success); }
.status-maint { background: var(--color-warning); }

/* Visual date picker for maintenance */
.maint-date-picker { display: grid; gap: var(--space-3); margin-top: .4rem; }
.maint-week-row { display: grid; gap: var(--space-2); }
.maint-week-label { font-size: var(--text-xs); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: .05em; }
.maint-days-row { display: grid; grid-template-columns: repeat(7, 1fr); gap: .4rem; }
.maint-date-btn {
  display: flex; flex-direction: column; align-items: center; gap: .15rem;
  border: 1.5px solid var(--color-border);
  background: var(--color-surface-2);
  color: var(--color-text);
  border-radius: var(--radius-md);
  padding: .5rem .3rem;
  font-size: var(--text-xs);
  cursor: pointer;
  transition: all .15s ease;
  min-width: 0;
}
.maint-date-btn:hover {
  border-color: var(--color-primary);
  background: color-mix(in srgb, var(--color-primary) 8%, var(--color-surface-2));
}
.maint-date-btn.maint-date-selected {
  border-color: var(--color-error);
  background: color-mix(in srgb, var(--color-error) 15%, var(--color-surface-2));
  color: var(--color-error);
  font-weight: 600;
}
.maint-date-btn.maint-date-selected:hover {
  background: color-mix(in srgb, var(--color-error) 22%, var(--color-surface-2));
}
.maint-date-weekday {
  font-size: .65rem;
  text-transform: uppercase;
  color: var(--color-text-muted);
}
.maint-date-btn.maint-date-selected .maint-date-weekday {
  color: var(--color-error);
  opacity: .8;
}
.maint-date-day {
  font-size: var(--text-sm);
  font-weight: 500;
}

/* Time Slider Styles */
.time-slider-block {
  display: grid;
  gap: var(--space-3);
  background: var(--color-surface-2);
  border-radius: var(--radius-md);
  padding: var(--space-4);
}
.time-slider-row {
  display: grid;
  grid-template-columns: 5.5rem 1fr 3.5rem;
  align-items: center;
  gap: var(--space-3);
}
.time-slider-tag { font-size: var(--text-xs); color: var(--color-text-muted); }
.time-slider-value { font-size: var(--text-sm); font-weight: 600; color: var(--color-primary); text-align: right; }
.time-range {
  -webkit-appearance: none; appearance: none;
  width: 100%; height: 6px; border-radius: 999px;
  background: var(--color-border); outline: none;
}
.time-range::-webkit-slider-thumb {
  -webkit-appearance: none; width: 18px; height: 18px; border-radius: 50%;
  background: var(--color-primary); cursor: pointer;
  border: 2px solid var(--color-surface); box-shadow: var(--shadow-sm);
}
.time-range::-moz-range-thumb {
  width: 18px; height: 18px; border-radius: 50%;
  background: var(--color-primary); cursor: pointer;
  border: 2px solid var(--color-surface); box-shadow: var(--shadow-sm);
}
.time-timeline { display: grid; gap: var(--space-1); margin-top: var(--space-1); }
.time-timeline-track {
  position: relative; height: 10px; border-radius: 999px;
  background: var(--color-border); overflow: hidden;
}
.time-timeline-fill {
  position: absolute; top: 0; bottom: 0;
  background: linear-gradient(90deg, var(--color-primary), var(--color-primary-2));
  border-radius: 999px;
}
.time-timeline-labels {
  display: flex; justify-content: space-between;
  font-size: var(--text-xs); color: var(--color-text-muted);
}

/* ═══ EXPERIMENTS STYLES ═══ */
.experiments-section { display: grid; gap: var(--space-4); }
.experiments-tabs { display: flex; gap: .65rem; flex-wrap: wrap; }
.experiments-tab {
  border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text);
  border-radius: 999px; padding: .72rem 1.2rem; font-size: var(--text-sm);
}
.experiments-tab.active { background: linear-gradient(135deg, #059669, #10b981); color: white; border-color: transparent; }
.experiments-tab:disabled { opacity: .5; cursor: not-allowed; }
.experiment-card { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); padding: var(--space-5); box-shadow: var(--shadow-sm); }
.experiment-hint { font-size: var(--text-sm); color: var(--color-text-muted); background: var(--color-surface-2); border-radius: var(--radius-md); padding: var(--space-3); }
.experiment-actions { display: flex; gap: .65rem; flex-wrap: wrap; margin-top: var(--space-3); }
.experiment-results { margin-top: var(--space-5); display: grid; gap: var(--space-4); }
.results-table-wrap { overflow-x: auto; border-radius: var(--radius-md); }
.results-table { width: 100%; border-collapse: collapse; font-size: var(--text-sm); }
.results-table th { background: var(--color-surface-2); text-align: left; padding: .75rem; border-bottom: 1px solid var(--color-border); font-size: var(--text-xs); text-transform: uppercase; letter-spacing: .05em; color: var(--color-text-muted); }
.results-table td { padding: .75rem; border-bottom: 1px solid rgba(141,164,177,.12); }
.results-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: var(--space-3); }
.result-kv { background: var(--color-surface-2); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3); display: flex; flex-direction: column; gap: .25rem; }
.result-k { font-size: var(--text-xs); color: var(--color-text-muted); text-transform: uppercase; }
.result-v { font-size: var(--text-lg); font-weight: 700; color: var(--color-primary); }
.release-profile-block { display: grid; gap: var(--space-3); }
.chart-block { background: var(--color-surface-2); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-4); }
.chart-title { font-size: var(--text-sm); font-weight: 600; margin-bottom: var(--space-3); }
.chart-bars { display: grid; gap: var(--space-2); }
.chart-bar-row { display: grid; grid-template-columns: 6rem 1fr 3.5rem; align-items: center; gap: var(--space-2); }
.chart-label { font-size: var(--text-xs); color: var(--color-text-muted); }
.chart-bar-track { height: 14px; border-radius: 999px; background: var(--color-border); overflow: hidden; }
.chart-bar-fill { height: 100%; border-radius: 999px; background: linear-gradient(90deg, var(--color-primary), var(--color-primary-2)); }
.chart-bar-fill.release-fill { background: linear-gradient(90deg, #7c3aed, #4f46e5); }
.chart-value { font-size: var(--text-sm); font-weight: 600; text-align: right; }
.formula-block { display: grid; gap: .35rem; font-size: var(--text-xs); color: var(--color-text-muted); font-family: ui-monospace, monospace; }

/* Modals */
.modal-overlay { position: fixed; inset: 0; background: rgba(4,10,14,.55); display: grid; place-items: center; z-index: 50; padding: var(--space-6); backdrop-filter: blur(4px); }
.modal-overlay-mobile-safe { padding-top: max(28px, env(safe-area-inset-top) + 20px); padding-bottom: max(16px, env(safe-area-inset-bottom) + 12px); }
.modal-card { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); box-shadow: var(--shadow-lg); width: min(760px, 100%); max-height: 88vh; display: flex; flex-direction: column; overflow: hidden; }
.modal-card-mobile-safe { max-height: min(82vh, calc(100dvh - 56px)); }
.modal-card-small { width: min(400px, 100%); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: var(--space-5) var(--space-6); border-bottom: 1px solid var(--color-border); flex-shrink: 0; }
.modal-header h3 { font-family: var(--font-display); margin: 0; font-size: var(--text-lg); }
.modal-close { border: none; background: transparent; font-size: 1.1rem; color: var(--color-text-muted); width: 32px; height: 32px; border-radius: 999px; }
.modal-close:hover { background: var(--color-surface-2); }
.modal-footer-top { display: flex; justify-content: flex-end; gap: var(--space-3); padding: var(--space-3) var(--space-6); border-bottom: 1px solid var(--color-border); background: var(--color-surface); flex-shrink: 0; }
.modal-footer-top-mobile-safe { padding-top: var(--space-4); padding-bottom: var(--space-4); }
.modal-body { padding: var(--space-6); overflow-y: auto; display: grid; gap: var(--space-4); overscroll-behavior: contain; -webkit-overflow-scrolling: touch; }
.form-row { display: grid; gap: .4rem; }
.form-row label { font-size: var(--text-xs); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: .05em; }
.form-row input, .form-row select, .form-row textarea { padding: .75rem .9rem; border-radius: var(--radius-md); border: 1px solid var(--color-border); background: var(--color-surface-2); color: var(--color-text); width: 100%; }
.form-row textarea { resize: vertical; }
.form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4); }
.form-grid-4 { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: var(--space-3); }
.form-section-title { font-size: var(--text-sm); font-weight: 600; color: var(--color-primary); margin-top: var(--space-2); }
.form-error { color: var(--color-error); font-size: var(--text-sm); }
.admin-hint { border: 1px dashed var(--color-border); background: var(--color-surface-2); border-radius: var(--radius-md); padding: .8rem .9rem; color: var(--color-text-muted); }
.repeat-last-line { display: grid; gap: .6rem; }
.repeat-last-buttons { display: flex; gap: .5rem; flex-wrap: wrap; }
.repeat-btn { max-width: 100%; overflow: hidden; text-overflow: ellipsis; }
.stock-plus, .stock-minus { padding: 2px; display: inline-flex; align-items: center; justify-content: center; }
.stock-plus:hover svg circle { fill: #bbf7d0; }
.stock-minus:hover svg circle { fill: #fecaca; }
tr:has(.stock-minus[title="Вернуть в наличие"]) { opacity: 0.6; }
.stock-plus, .stock-minus { padding: 2px; display: inline-flex; align-items: center; justify-content: center; }
.stock-plus:hover svg circle { fill: #bbf7d0; }
.stock-minus:hover svg circle { fill: #fecaca; }
tr:has(.stock-minus[title="Вернуть в наличие"]) { opacity: 0.6; }

/* Mobile layouts */
.mobile-catalog-view { display: grid; gap: var(--space-4); }
.mobile-search-block { display: grid; gap: .8rem; }
.mobile-item-list { display: grid; gap: var(--space-3); width: 100%; }
.mobile-item-card { border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: var(--space-4); background: var(--color-surface-2); width: 100%; }
.mobile-item-top { display: flex; justify-content: space-between; align-items: flex-start; gap: var(--space-3); margin-bottom: var(--space-2); }
.mobile-item-name { font-size: var(--text-base); overflow-wrap: break-word; word-break: break-word; }
.name-cell { display: flex; flex-direction: column; align-items: flex-start; gap: 0; }
.name-line { display: flex; align-items: center; gap: .4rem; flex-wrap: wrap; }
.stock-badge { font-size: var(--text-xs); padding: 1px 6px; border-radius: 999px; flex-shrink: 0; }
.stock-badge-low { background: #fef3c7; color: #92400e; }
.stock-badge-empty { background: #fee2e2; color: #991b1b; }
[data-theme="dark"] .stock-badge-low { background: #451a03; color: #fbbf24; }
[data-theme="dark"] .stock-badge-empty { background: #450a0a; color: #f87171; }
.name-truncate { display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; text-overflow: ellipsis; max-width: 220px; }
.name-toggle-btn { background: none; border: none; cursor: pointer; color: var(--color-text-muted); font-size: var(--text-xs); padding: 0; margin-top: 2px; line-height: 1; }
.name-toggle-btn:hover { color: var(--color-primary); }
.mobile-item-row { font-size: var(--text-sm); padding: .25rem 0; border-top: 1px dashed var(--color-border); overflow-wrap: anywhere; white-space: pre-wrap; }
.mobile-item-row:first-of-type { border-top: none; }
.mobile-item-label { color: var(--color-text-muted); margin-right: .4rem; }
.mobile-item-row a { color: var(--color-primary); margin-right: 1rem; }
.mobile-home { min-height: 100dvh; padding: var(--space-5); display: flex; flex-direction: column; gap: var(--space-4); width: 100%; overflow-x: hidden; }
.mobile-home-header { padding-top: var(--space-2); }
.mobile-home-topline { display: grid; grid-template-columns: auto 1fr auto; align-items: start; gap: .75rem; }
.mobile-home-title-wrap { text-align: center; min-width: 0; }
.mobile-home-title-wrap h1 { font-family: var(--font-display); font-size: var(--text-lg); margin: 0; }
.mobile-home-title-wrap p { color: var(--color-text-muted); font-size: var(--text-sm); margin: .3rem 0 0; line-height: 1.35; }
.mobile-header-actions { display: flex; gap: .5rem; justify-content: flex-end; align-items: flex-start; }
.mobile-admin-left { align-self: flex-start; }
.mobile-header-actions-inline { display: flex; gap: .5rem; }
.theme-toggle-mini, .lang-toggle-mini { border: 1px solid var(--color-border); background: var(--color-surface-2); border-radius: 999px; width: 40px; height: 40px; display: grid; place-items: center; font-size: 1rem; }
.mobile-badge { text-align: center; }
.mobile-big-grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-3); width: 100%; }
.big-btn { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: .5rem; border: 1px solid var(--color-border); border-radius: var(--radius-xl); min-height: 130px; padding: var(--space-4); box-shadow: var(--shadow-sm); transition: transform .15s ease, background .2s ease; }
.big-btn:active { transform: scale(.96); }
.big-btn-icon { font-size: 2.2rem; }
.big-btn-label { font-family: var(--font-display); font-size: var(--text-base); font-weight: 700; text-align: center; }
.big-btn-reagent { background: #11242d; color: #ffffff; }
.big-btn-consumable { background: linear-gradient(150deg, #ffe3b3, var(--color-surface)); color: #10222c; }
.big-btn-equipment { background: #dfe7f4; color: #0f1720; }
[data-theme="dark"] .big-btn-equipment { background: #1a2632; color: #ffffff; }
.big-btn-other { background: linear-gradient(150deg, #e4d6ff, var(--color-surface)); }
.big-btn-protocols { background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2)); color: white; }
.big-btn-booking { background: linear-gradient(135deg, #7c3aed, #4f46e5); color: white; }
.big-btn-experiments { background: linear-gradient(135deg, #059669, #10b981); color: white; }
.big-btn-secondary { border: 1px solid var(--color-border); background: var(--color-surface-2); border-radius: var(--radius-lg); padding: var(--space-4); font-size: var(--text-base); font-weight: 700; color: var(--color-text); }
.mobile-screen-header { display: flex; flex-direction: column; gap: var(--space-3); text-align: center; }
.mobile-screen-topline { display: flex; justify-content: space-between; align-items: center; gap: .75rem; }
.mobile-screen-header h2 { font-family: var(--font-display); margin: 0; }
.back-btn { border: 1px solid var(--color-border); background: var(--color-surface-2); border-radius: 999px; padding: .6rem 1rem; font-size: var(--text-sm); align-self: flex-start; white-space: nowrap; flex-shrink: 0; }
.current-location-badge { border: 1px solid var(--color-border); background: var(--color-surface-2); border-radius: 999px; padding: .65rem 1rem; }

@media (max-width: 1280px) {
  .desktop-context-row { flex-direction: column; }
}
@media (max-width: 900px) {
  html, body, #app, .app-shell, .workspace, .main, .table-card,
  .mobile-catalog-view, .mobile-search-block, .protocol-search-wrap,
  .mobile-search-history, .history-list, .history-item, .mobile-item-list, .mobile-item-card { min-width: 0; max-width: 100%; box-sizing: border-box; }
  body, #app, .app-shell, .workspace { overflow-x: hidden; }
  .main { width: 100%; padding: var(--space-4); }
  .table-card { width: 100%; padding: var(--space-4); overflow: hidden; }
  .mobile-catalog-view, .mobile-search-block, .protocol-search-wrap { width: 100%; }
  .protocol-search-wrap { display: grid; gap: .8rem; }
  .mobile-search-input, input[type="search"] { width: 100%; min-width: 0; max-width: 100%; box-sizing: border-box; }
  .history-item, .mobile-item-card { width: 100%; }
  .form-grid-2 { grid-template-columns: 1fr; }
  .form-grid-4 { grid-template-columns: 1fr 1fr; }
  .modal-overlay { padding: 12px; }
  .modal-overlay-mobile-safe { padding-top: max(34px, env(safe-area-inset-top) + 28px); padding-right: 12px; padding-left: 12px; padding-bottom: max(16px, env(safe-area-inset-bottom) + 12px); align-items: start; }
  .modal-card { width: 100%; max-width: 100%; max-height: 92vh; }
  .modal-card-mobile-safe { max-height: calc(100dvh - 76px); margin-top: 8px; }
  .modal-card-admin-status { width: 100%; }
  .modal-header { padding-top: var(--space-4); padding-bottom: var(--space-4); }
  .modal-footer-top-mobile-safe { padding-top: var(--space-5); padding-bottom: var(--space-3); }
  .booking-grid { grid-template-columns: repeat(7, minmax(120px, 1fr)); }
  .booking-header-row { flex-direction: column; }
  .maint-days-row { gap: .3rem; }
  .maint-date-btn { padding: .4rem .2rem; }
  .time-slider-row { grid-template-columns: 4.5rem 1fr 3rem; gap: var(--space-2); }
  .chart-bar-row { grid-template-columns: 4rem 1fr 3rem; }
}
@media (max-width: 900px) and (orientation: landscape) {
  .mobile-home { padding: var(--space-4); }
  .mobile-big-grid { grid-template-columns: 1fr 1fr 1fr; gap: var(--space-2); }
  .big-btn { min-height: 95px; padding: var(--space-3); }
  .big-btn-icon { font-size: 1.6rem; }
  .mobile-home-title-wrap h1 { font-size: var(--text-base); }
}
@media (max-width: 480px) {
  .mobile-big-grid { grid-template-columns: 1fr 1fr; }
  .big-btn { min-height: 115px; }
  .mobile-screen-topline { align-items: flex-start; }
  .form-grid-4 { grid-template-columns: 1fr; }
  .duration-btns { gap: .3rem; }
  .duration-btn { padding: .45rem .7rem; font-size: var(--text-xs); }
  .maint-days-row { grid-template-columns: repeat(7, 1fr); gap: .25rem; }
  .maint-date-btn { padding: .35rem .1rem; font-size: .7rem; }
  .maint-date-day { font-size: .8rem; }
  .time-slider-row { grid-template-columns: 1fr; gap: var(--space-1); }
  .time-slider-tag { display: none; }
  .time-slider-value { text-align: left; }
  .chart-bar-row { grid-template-columns: 1fr; gap: var(--space-1); }
}
</style>

