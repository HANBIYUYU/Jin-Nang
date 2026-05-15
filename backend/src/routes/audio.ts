import { Hono } from 'hono'
import type { Env } from '../types'

const app = new Hono<{ Bindings: Env }>()

app.get('/:scene/:filename', async (c) => {
  const key = `${c.req.param('scene')}/${c.req.param('filename')}`
  const object = await c.env.AUDIO.get(key)
  if (!object) return c.notFound()
  return new Response(object.body, {
    headers: {
      'Content-Type': 'audio/mpeg',
      'Cache-Control': 'public, max-age=31536000, immutable',
    },
  })
})

export default app
