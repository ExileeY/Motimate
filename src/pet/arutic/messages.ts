import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const aruticMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: 'Saddle up!',
      subtitle: "Daylight's burnin' — let's ride.",
      meta: 'quiet so far',
      footer: "Raring to go — fancy hittin' the trail?",
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Ready to ride.',
      subtitle: "Say the word and we'll head out.",
      meta: 'good ground covered',
      footer: "Good ground covered — trail's open when you are.",
    },
  ],
  [Mood.TIRED]: [
    {
      headline: "Restin' easy.",
      subtitle: "Long ride today. Hat's over my eyes.",
      meta: 'all rode out',
      footer: "A hard day's ride. Wakin' at dawn.",
    },
  ],
}
