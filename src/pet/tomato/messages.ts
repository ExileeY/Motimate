import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const tomatoMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: '¡Vámonos!',
      subtitle: "Ripe, red and raring — let's seize the morning.",
      meta: 'quiet so far',
      footer: 'Bursting with sun — shall we take a stroll?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Tranquilo.',
      subtitle: 'Soaking up the warm afternoon sun.',
      meta: 'in the sun',
      footer: 'Ripe and rested — a wander whenever you like.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'Buenas noches.',
      subtitle: 'A long day in the sun — turning in now.',
      meta: 'all worn out',
      footer: 'Vine-ripe and worn out. See you mañana.',
    },
  ],
}
