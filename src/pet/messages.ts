import { Mood } from '@/pet/mood'

export interface MessageSet {
  headline: string
  subtitle: string
  meta: string
  footer: string
}

const randomFrom = <T,>(items: T[]): T =>
  items[Math.floor(Math.random() * items.length)]

export const pickMessages = (pools: Record<Mood, MessageSet[]>): Record<Mood, MessageSet> => {
  const moodMessages = Object
    .values(Mood)
    .map((mood) => [mood, randomFrom(pools[mood])])

  return Object.fromEntries(moodMessages)
}
