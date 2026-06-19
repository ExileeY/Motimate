import { Mood } from '@/mood/mood'

export interface MoodMessage {
  headline: string
  subtitle: string
  meta: string
  footer: string
}

export const mochiMessages: Record<Mood, MoodMessage> = {
  [Mood.ENERGETIC]: {
    headline: 'Walk with me?',
    subtitle: "I'm full of beans — let's head out!",
    meta: 'quiet so far',
    footer: 'Plenty in the tank — fancy a short walk?',
  },
  [Mood.CALM]: {
    headline: 'Ready when you are.',
    subtitle: "A little stroll? I'm up for it.",
    meta: '5,200 steps',
    footer: 'Nice and steady — out again whenever.',
  },
  [Mood.TIRED]: {
    headline: 'All worn out.',
    subtitle: "You moved so much — I'm napping it off.",
    meta: '12,400 steps',
    footer: 'A big day. Let me sleep this one off.',
  },
}
