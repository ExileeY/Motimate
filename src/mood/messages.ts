import { Mood } from '@/mood/mood'

export interface MoodMessage {
  headline: string
  subtitle: string
  meta: string
  footer: string
}

export const mochiMessages: Record<Mood, MoodMessage[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: 'Walk with me?',
      subtitle: "I'm full of beans — let's head out!",
      meta: 'quiet so far',
      footer: 'Plenty in the tank — fancy a short walk?',
    },
    {
      headline: "Let's go!",
      subtitle: 'My little paws are itching to move.',
      meta: 'barely started',
      footer: 'So much energy — where are we off to?',
    },
    {
      headline: 'Adventure time?',
      subtitle: 'My whiskers are twitching to explore.',
      meta: 'just woke up',
      footer: 'Wide awake and ready — lead the way!',
    },
    {
      headline: 'Bursting to move!',
      subtitle: "I've got the zoomies — let's burn them off.",
      meta: 'still resting',
      footer: 'All charged up — a quick lap would be purrfect.',
    },
    {
      headline: 'Pretty please?',
      subtitle: 'Just a tiny walk? Pretty please?',
      meta: 'not much yet',
      footer: "My ears perk up at the very thought of going out.",
    },
    {
      headline: 'Feeling springy!',
      subtitle: 'Bouncy paws, ready to pounce on the day.',
      meta: 'fresh start',
      footer: 'Loads of pep today — fancy stretching our legs?',
    },
    {
      headline: 'Outside calls!',
      subtitle: 'Can you hear it? The day is waiting.',
      meta: 'early still',
      footer: 'Sun is out and so am I — shall we?',
    },
    {
      headline: 'So much pep!',
      subtitle: "Let's shake off the morning together.",
      meta: 'slow start',
      footer: 'Brimming with energy — point me anywhere.',
    },
    {
      headline: 'The door, look!',
      subtitle: "It's right there. We could just... go?",
      meta: 'hardly moved',
      footer: 'Feeling quick on my paws — a little dash, maybe?',
    },
    {
      headline: 'Let’s explore!',
      subtitle: "There's a whole world out that door.",
      meta: 'just begun',
      footer: 'Curious and full of beans — somewhere new today?',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Ready when you are.',
      subtitle: "A little stroll? I'm up for it.",
      meta: 'nicely warmed up',
      footer: 'Nice and steady — out again whenever.',
    },
    {
      headline: 'Feeling good.',
      subtitle: "We've found a lovely rhythm today.",
      meta: 'in the groove',
      footer: 'Cruising along — happy to keep going.',
    },
    {
      headline: 'Just right.',
      subtitle: 'Content as a cat in a sunbeam.',
      meta: 'comfy and content',
      footer: 'Comfy pace — no rush, no fuss.',
    },
    {
      headline: 'Nice and easy.',
      subtitle: 'A gentle day suits me just fine.',
      meta: 'easygoing',
      footer: 'Settled and steady — whenever you like.',
    },
    {
      headline: 'Mellow mood.',
      subtitle: 'Happy to potter along beside you.',
      meta: 'pottering along',
      footer: 'Easygoing today — out again, no pressure.',
    },
    {
      headline: 'All balanced.',
      subtitle: 'We’ve struck a lovely middle ground.',
      meta: 'in the sweet spot',
      footer: 'Right in the sweet spot — keep it up.',
    },
    {
      headline: 'Quietly happy.',
      subtitle: 'A slow blink for you — this pace is just my speed.',
      meta: 'calm and content',
      footer: 'Calm and content — a stroll sounds lovely.',
    },
    {
      headline: 'Coasting along.',
      subtitle: 'Soft little steps, easy breaths.',
      meta: 'smooth sailing',
      footer: 'Smooth sailing — happy either way.',
    },
    {
      headline: 'At ease.',
      subtitle: "We're in a good groove, you and me.",
      meta: 'relaxed and ready',
      footer: 'Relaxed and ready — no rush at all.',
    },
    {
      headline: 'Comfy and content.',
      subtitle: 'A little more, a little rest — both sound lovely.',
      meta: 'cosy pace',
      footer: 'Cosy pace today — let’s keep it gentle.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'All worn out.',
      subtitle: "You moved so much — I'm napping it off.",
      meta: 'a big day',
      footer: 'A big day. Let me sleep this one off.',
    },
    {
      headline: 'So sleepy…',
      subtitle: 'We earned this rest, every step of it.',
      meta: 'well earned',
      footer: 'Whew. Curling up for a well-earned nap.',
    },
    {
      headline: 'Out cold.',
      subtitle: 'Such a busy day — time to recharge.',
      meta: 'all tuckered out',
      footer: 'Done and dusted. Resting up now.',
    },
    {
      headline: 'Yaaawn…',
      subtitle: 'My little legs are jelly — what a day!',
      meta: 'thoroughly pooped',
      footer: 'Plenty banked today — snoozing now.',
    },
    {
      headline: 'Pooped.',
      subtitle: 'We really went for it today, huh?',
      meta: 'fully spent',
      footer: 'Big effort done — fully in rest mode.',
    },
    {
      headline: 'Recharging…',
      subtitle: 'Eyes heavy, heart happy.',
      meta: 'happily worn out',
      footer: 'Earned every yawn — back to dozing.',
    },
    {
      headline: 'Nap o’clock.',
      subtitle: 'Not one more step in these paws today.',
      meta: 'a marathon day',
      footer: 'A marathon of a day — time to power down.',
    },
    {
      headline: 'Wiped out.',
      subtitle: 'You wore me out, in the best way.',
      meta: 'gently exhausted',
      footer: 'So well done. I’m off to dreamland.',
    },
    {
      headline: 'Dozing off…',
      subtitle: 'Couldn’t lift a paw if I tried.',
      meta: 'sleepy and content',
      footer: 'Loads of movement today — now, sweet rest.',
    },
    {
      headline: 'Snoozeville.',
      subtitle: 'Tuckered out and totally content.',
      meta: 'curled up and cosy',
      footer: 'Today was a lot — curled up and resting.',
    },
  ],
}

const pickRandomFrom = <T,>(collection: T[]): T => collection[Math.floor(Math.random() * collection.length)]

export const sessionMessages: Record<Mood, MoodMessage> = {
  [Mood.ENERGETIC]: pickRandomFrom(mochiMessages[Mood.ENERGETIC]),
  [Mood.CALM]: pickRandomFrom(mochiMessages[Mood.CALM]),
  [Mood.TIRED]: pickRandomFrom(mochiMessages[Mood.TIRED]),
}
