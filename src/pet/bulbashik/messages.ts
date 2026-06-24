import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const bulbashikMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: "Let's get growing!",
      subtitle: 'Fresh sprouts and ready to roll.',
      meta: 'quiet so far',
      footer: 'Roots are restless — fancy a little walk?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Soaking it in.',
      subtitle: 'Happy to amble whenever.',
      meta: 'in the sun',
      footer: 'Photosynthesising nicely — out when you are.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'Wilting a little.',
      subtitle: 'Big day in the sun. Time to rest.',
      meta: 'all grown out',
      footer: 'All grown out for today. Night night.',
    },
  ],
}
