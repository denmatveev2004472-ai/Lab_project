const API_BASE = 'http://127.0.0.1:8000'

export async function api(url) {
  const r = await fetch(`${API_BASE}${url}`)
  if (!r.ok) throw new Error(await r.text())
  return r.json()
}

export function qs(obj) {
  const p = new URLSearchParams()
  Object.entries(obj).forEach(([k, v]) => {
    if (v) p.set(k, v)
  })
  return p.toString()
}