import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

// GET /scenes
app.get('/', requireAuth, async (c) => {
  const rows = await c.env.DB
    .prepare('SELECT id, name_en, name_zh, subtitle_en, color_hex, is_unlocked_default FROM scenes ORDER BY sort_order')
    .all()
  return c.json(rows.results)
})

// GET /scenes/:id/vocab  (learning card fields only)
app.get('/:id/vocab', requireAuth, async (c) => {
  const sceneId = Number(c.req.param('id'))
  const rows = await c.env.DB
    .prepare('SELECT id, chinese, pinyin, english, audio_key FROM vocab WHERE scene_id = ? ORDER BY sort_order')
    .bind(sceneId)
    .all<{ id: number; chinese: string; pinyin: string; english: string; audio_key: string }>()

  const base = c.env.WORKER_URL
  return c.json(rows.results.map(v => ({
    id: v.id,
    chinese: v.chinese,
    pinyin: v.pinyin,
    english: v.english,
    audio_url: `${base}/audio/${v.audio_key}`,
  })))
})

// GET /scenes/:id/levels  (levels + questions + user progress)
app.get('/:id/levels', requireAuth, async (c) => {
  const sceneId = Number(c.req.param('id'))
  const userId = c.get('userId')

  const lvls = await c.env.DB.prepare(`
    SELECT
      l.id, l.level_num, l.title, l.subtitle, l.pass_threshold,
      COALESCE(p.stars, 0)       AS stars,
      COALESCE(p.best_score, 0)  AS best_score,
      COALESCE(p.is_unlocked, CASE WHEN l.level_num = 1 THEN 1 ELSE 0 END) AS is_unlocked
    FROM levels l
    LEFT JOIN user_level_progress p ON p.level_id = l.id AND p.user_id = ?
    WHERE l.scene_id = ?
    ORDER BY l.sort_order
  `).bind(userId, sceneId).all<{
    id: number; level_num: number; title: string; subtitle: string;
    pass_threshold: number; stars: number; best_score: number; is_unlocked: number
  }>()

  const result = await Promise.all(lvls.results.map(async l => {
    const qs = await c.env.DB
      .prepare('SELECT id, question_text, options, correct_index, explanation FROM questions WHERE level_id = ? ORDER BY sort_order')
      .bind(l.id)
      .all<{ id: number; question_text: string; options: string; correct_index: number; explanation: string }>()

    return {
      ...l,
      is_unlocked: l.is_unlocked === 1,
      questions: qs.results.map(q => ({ ...q, options: JSON.parse(q.options) })),
    }
  }))

  return c.json(result)
})

export default app
