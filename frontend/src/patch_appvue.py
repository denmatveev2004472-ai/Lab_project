import re, shutil

path = "App.vue"
shutil.copy(path, path + ".bak")
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

def replace_function(content, name, new_body, is_async=False):
    kw = ("async function " if is_async else "function ") + name + "("
    start = content.find(kw)
    if start == -1:
        alt_kw = ("function " if is_async else "async function ") + name + "("
        start = content.find(alt_kw)
        if start == -1:
            raise SystemExit(f"NOT FOUND: {name}")
        kw = alt_kw
    brace_open = content.find("{", start)
    depth = 0
    i = brace_open
    while i < len(content):
        if content[i] == "{":
            depth += 1
        elif content[i] == "}":
            depth -= 1
            if depth == 0:
                break
        i += 1
    end = i + 1
    return content[:start] + new_body.strip() + content[end:]

# 1. loadAllMaintenance -> use /api/instrument-maintenance/all, key by instrument_id
content = replace_function(content, "loadAllMaintenance", """
async function loadAllMaintenance() {
  try {
    maintenanceRecords.value = await api(`/api/instrument-maintenance/all`)
  } catch (e) {
    maintenanceRecords.value = []
  }
}
""", is_async=True)

# 2. isDateUnavail -> compare by instrument_id directly
content = replace_function(content, "isDateUnavail", """
function isDateUnavail(instrId, dateStr) {
  return maintenanceRecords.value.some(m => m.instrument_id === instrId && dateStr >= m.date_from && dateStr <= m.date_to)
}
""")

# 3. getMaintReason -> compare by instrument_id directly
content = replace_function(content, "getMaintReason", """
function getMaintReason(instrId) {
  const rec = maintenanceRecords.value.find(m => m.instrument_id === instrId)
  return rec?.reason || ''
}
""")

# 4. getInstrStatus -> no itemId lookup needed
content = replace_function(content, "getInstrStatus", """
function getInstrStatus(instrId) {
  const hasMaint = maintenanceRecords.value.some(m => m.instrument_id === instrId)
  const reason = getMaintReason(instrId)
  return { status: hasMaint ? 'maint' : 'ok', reason }
}
""")

# 5. loadAllBookings -> use /api/instrument-usage
content = replace_function(content, "loadAllBookings", """
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
""", is_async=True)

# 6. loadBookingData -> drop equipment matching step
content = replace_function(content, "loadBookingData", """
function loadBookingData() {
  loadAllBookings()
  loadAllMaintenance()
  loadCellBookings()
}
""")

# 7. submitBooking -> no itemId check, POST to /api/instrument-usage, PATCH on edit
content = replace_function(content, "submitBooking", """
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
""", is_async=True)

# 8. deleteBooking -> use /api/instrument-usage
content = replace_function(content, "deleteBooking", """
async function deleteBooking(b) {
  if (!confirm(`${b.who}: ${b.experiment}?`)) return
  try {
    if (b.apiId) await api(`/api/instrument-usage/${b.apiId}`, { method: 'DELETE' })
    await loadAllBookings()
  } catch (e) {}
}
""", is_async=True)

# 9. openAdminStatusModal -> no itemId lookup, use instrument_id directly
content = replace_function(content, "openAdminStatusModal", """
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
""")

# 10. submitAdminStatus -> use /api/instrument-maintenance
content = replace_function(content, "submitAdminStatus", """
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
""", is_async=True)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)

print("OK: App.vue patched. Backup saved as App.vue.bak")