import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const octopusMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: "Let's gooo!",
      subtitle: 'All eight arms say outside!',
      meta: 'quiet so far',
      footer: 'Brimming with energy — fancy a wander?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Hey, you.',
      subtitle: 'Eight arms, all relaxed.',
      meta: 'drifting along',
      footer: 'Drifting along — out for a wander whenever.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'All squished out.',
      subtitle: 'Big swim today. Sinking into a nap.',
      meta: 'all swum out',
      footer: 'A full day. Drifting off now.',
    },
  ],
}
