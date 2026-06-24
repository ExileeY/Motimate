import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const dogMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: 'Walk? Walk?!',
      subtitle: "Leash is by the door — let's go!",
      meta: 'quiet so far',
      footer: 'Come on — out for a lap of the block?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Ready to roam.',
      subtitle: 'A gentle lap sounds lovely.',
      meta: 'good and steady',
      footer: 'Good and steady — out whenever you like.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'Tuckered out.',
      subtitle: 'Best walk ever. Snoozing now.',
      meta: 'all walked out',
      footer: 'Huge day. Curling up till morning.',
    },
  ],
}
