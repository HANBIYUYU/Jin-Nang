const enc = new TextEncoder()

const b64url = (buf: ArrayBuffer) =>
  btoa(String.fromCharCode(...new Uint8Array(buf)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')

const fromB64url = (s: string) =>
  Uint8Array.from(atob(s.replace(/-/g, '+').replace(/_/g, '/')), c => c.charCodeAt(0))

async function importKey(secret: string): Promise<CryptoKey> {
  return crypto.subtle.importKey(
    'raw', enc.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false, ['sign', 'verify']
  )
}

export async function signJwt(payload: Record<string, unknown>, secret: string): Promise<string> {
  const header = b64url(enc.encode(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).buffer as ArrayBuffer)
  const body   = b64url(enc.encode(JSON.stringify(payload)).buffer as ArrayBuffer)
  const key    = await importKey(secret)
  const sig    = await crypto.subtle.sign('HMAC', key, enc.encode(`${header}.${body}`))
  return `${header}.${body}.${b64url(sig)}`
}

export async function verifyJwt(token: string, secret: string): Promise<{ sub: number; exp: number }> {
  const parts = token.split('.')
  if (parts.length !== 3) throw new Error('malformed token')

  const [header, body, sig] = parts
  const key = await importKey(secret)
  const ok  = await crypto.subtle.verify(
    'HMAC', key,
    fromB64url(sig),
    enc.encode(`${header}.${body}`)
  )
  if (!ok) throw new Error('invalid signature')

  const payload = JSON.parse(new TextDecoder().decode(fromB64url(body)))
  if (payload.exp && payload.exp < Math.floor(Date.now() / 1000)) throw new Error('token expired')
  return payload as { sub: number; exp: number }
}
