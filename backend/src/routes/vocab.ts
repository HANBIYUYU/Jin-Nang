import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

// GET /vocab/:id  (full detail for Vocab Battle)
app.get('/:id', requireAuth, async (c) => {
  const id = Number(c.req.param('id'))

  const v = await c.env.DB.prepare(`
    SELECT id, chinese, pinyin, part_of_speech, english_meaning,
           chinese_meaning, chinese_meaning_pinyin, audio_key
    FROM vocab WHERE id = ?
  `).bind(id).first<{
    id: number; chinese: string; pinyin: string; part_of_speech: string
    english_meaning: string; chinese_meaning: string; chinese_meaning_pinyin: string
    audio_key: string
  }>()
  if (!v) return c.json({ error: 'Not found' }, 404)

  const [examples, related, phrases] = await Promise.all([
    c.env.DB.prepare('SELECT chinese, pinyin, english FROM vocab_examples WHERE vocab_id = ? ORDER BY sort_order').bind(id).all(),
    c.env.DB.prepare('SELECT type, chinese, pinyin, english FROM vocab_related WHERE vocab_id = ?').bind(id).all(),
    c.env.DB.prepare('SELECT chinese, english FROM vocab_phrases WHERE vocab_id = ? ORDER BY sort_order').bind(id).all(),
  ])

  return c.json({
    id: v.id,
    chinese: v.chinese,
    pinyin: v.pinyin,
    part_of_speech: v.part_of_speech,
    english_meaning: v.english_meaning,
    chinese_meaning: v.chinese_meaning,
    chinese_meaning_pinyin: v.chinese_meaning_pinyin,
    audio_url: `${c.env.WORKER_URL}/audio/${v.audio_key}`,
    examples: examples.results,
    related_words: related.results,
    phrases: phrases.results,
  })
})

export default app
