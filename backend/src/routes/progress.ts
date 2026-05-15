import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

app.get('/', requireAuth, async (c) => {
  const rows = await c.env.DB
    .prepare('SELECT level_id, stars, best_score, is_unlocked, completed_at FROM user_level_progress WHERE user_id = ?')
    .bind(c.get('userId'))
    .all()
  return c.json(rows.results)
})

app.post('/', requireAuth, async (c) => {
  const userId = c.get('userId')
  const { level_id, stars, score } = await c.req.json<{ level_id: number; stars: number; score: number }>()

  await c.env.DB.prepare(`
    INSERT INTO user_level_progress (user_id, level_id, stars, best_score, is_unlocked, completed_at)
    VALUES (?, ?, ?, ?, 1, datetime('now'))
    ON CONFLICT(user_id, level_id) DO UPDATE SET
      stars      = MAX(stars, excluded.stars),
      best_score = MAX(best_score, excluded.best_score),
      is_unlocked = 1,
      completed_at = excluded.completed_at
  `).bind(userId, level_id, stars, score).run()

  // Unlock the next level in the same scene when passed (stars > 0)
  if (stars > 0) {
    await c.env.DB.prepare(`
      INSERT INTO user_level_progress (user_id, level_id, stars, best_score, is_unlocked)
      SELECT ?, l.id, 0, 0, 1
      FROM levels l
      WHERE l.scene_id = (SELECT scene_id FROM levels WHERE id = ?)
        AND l.level_num = (SELECT level_num FROM levels WHERE id = ?) + 1
      ON CONFLICT(user_id, level_id) DO UPDATE SET is_unlocked = 1
    `).bind(userId, level_id, level_id).run()
  }

  // Update user running stats
  await c.env.DB.prepare(`
    UPDATE users SET
      avg_score = ROUND(avg_score * 0.8 + ? * 0.2, 2)
    WHERE id = ?
  `).bind(score, userId).run()

  return c.json({ ok: true })
})

export default app
