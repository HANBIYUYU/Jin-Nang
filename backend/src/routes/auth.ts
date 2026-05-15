import { Hono } from 'hono'
import { signJwt } from '../lib/jwt'
import { hashPassword, verifyPassword } from '../lib/crypto'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

const TOKEN_TTL = 60 * 60 * 24 * 30 // 30 days

function makeToken(userId: number, secret: string) {
  return signJwt({ sub: userId, exp: Math.floor(Date.now() / 1000) + TOKEN_TTL }, secret)
}

function rankToLabel(rank: string): string {
  const map: Record<string, string> = {
    Bronze: 'Beginner',
    Silver: 'Elementary Learner',
    Gold: 'Intermediate Learner',
    Platinum: 'Advanced Learner',
  }
  return map[rank] ?? 'Learner'
}

app.post('/register', async (c) => {
  const body = await c.req.json<{ email: string; password: string; display_name: string }>()
  if (!body.email || !body.password || !body.display_name) {
    return c.json({ error: 'Missing fields' }, 400)
  }

  const existing = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?')
    .bind(body.email).first()
  if (existing) return c.json({ error: 'Email already registered' }, 409)

  const password_hash = await hashPassword(body.password)
  const row = await c.env.DB
    .prepare('INSERT INTO users (email, password_hash, display_name) VALUES (?, ?, ?) RETURNING id')
    .bind(body.email, password_hash, body.display_name)
    .first<{ id: number }>()

  const token = await makeToken(row!.id, c.env.JWT_SECRET)
  return c.json({ token }, 201)
})

app.post('/login', async (c) => {
  const body = await c.req.json<{ email: string; password: string }>()
  const user = await c.env.DB
    .prepare('SELECT id, password_hash FROM users WHERE email = ?')
    .bind(body.email)
    .first<{ id: number; password_hash: string }>()

  if (!user || !(await verifyPassword(body.password, user.password_hash))) {
    return c.json({ error: 'Invalid credentials' }, 401)
  }

  const token = await makeToken(user.id, c.env.JWT_SECRET)
  return c.json({ token })
})

app.get('/me', requireAuth, async (c) => {
  const user = await c.env.DB
    .prepare('SELECT display_name, rank, streak_days, total_words_seen, avg_score FROM users WHERE id = ?')
    .bind(c.get('userId'))
    .first<{ display_name: string; rank: string; streak_days: number; total_words_seen: number; avg_score: number }>()

  if (!user) return c.json({ error: 'Not found' }, 404)
  return c.json({ ...user, level_label: rankToLabel(user.rank) })
})

export default app
