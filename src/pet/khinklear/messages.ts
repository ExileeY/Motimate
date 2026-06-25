import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const khinklearMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: "Let's wander!",
      subtitle: "I'm bursting — come on, come on!",
      meta: 'quiet so far',
      footer: 'So much pep — fancy a little walk?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Cosy and content.',
      subtitle: "A gentle stroll? I'd love that.",
      meta: 'out and about',
      footer: 'Lovely and steady — out whenever you like.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'All tuckered out.',
      subtitle: 'You wore me out — napping it off.',
      meta: 'all worn out',
      footer: 'What a day. Let me snooze this one off.',
    },
  ],
}
