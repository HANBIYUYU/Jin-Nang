export type Env = {
  DB: D1Database
  AUDIO: R2Bucket
  JWT_SECRET: string
  WORKER_URL: string
}

export type Variables = {
  userId: number
}
