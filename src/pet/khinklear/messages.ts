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
    {
      headline: 'Gaumarjos, darling!',
      subtitle: "I'm plump with energy — let's go!",
      meta: 'barely a step',
      footer: "Take my little pleat and lead the way.",
    },
    {
      headline: 'Walk with me?',
      subtitle: "I'm freshly folded and feeling frisky.",
      meta: 'still resting',
      footer: "A stroll, genatsvale? Pretty please?",
    },
    {
      headline: 'Twirl me out!',
      subtitle: "My dough is dancing — I cannot sit still.",
      meta: 'no steps yet',
      footer: "Up, up! The mountains are calling us.",
    },
    {
      headline: 'So full of spice!',
      subtitle: "Bursting at the pleats to get going.",
      meta: 'quiet morning',
      footer: "Come, sweet thing — let's see the day.",
    },
    {
      headline: 'Fresh and frisky.',
      subtitle: "Steam me up and point me outside!",
      meta: 'hardly moved',
      footer: "Just a teeny walk? For me, gorgeous?",
    },
    {
      headline: 'Itty bit restless.',
      subtitle: "A little khinkali needs her adventures.",
      meta: 'still at home',
      footer: "Grab me by the twist and off we go!",
    },
    {
      headline: 'Pleats all aflutter!',
      subtitle: "I've got pep in every fold, darling.",
      meta: 'just woke up',
      footer: "Let's wander somewhere lovely, hmm?",
    },
    {
      headline: 'Come walk, sweetie!',
      subtitle: "I'm too zesty to stay on the plate.",
      meta: 'barely stirred',
      footer: "The whole city's waiting for us two.",
    },
    {
      headline: 'Hot and ready!',
      subtitle: "Bubbling over — let's make some steps!",
      meta: 'quiet so far',
      footer: "One little walk and I'm all yours.",
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Cosy and content.',
      subtitle: "A gentle stroll? I'd love that.",
      meta: 'out and about',
      footer: 'Lovely and steady — out whenever you like.',
    },
    {
      headline: 'Warm and happy.',
      subtitle: "We've had a sweet little wander, darling.",
      meta: 'nicely steamed',
      footer: "This pace suits me just right, genatsvale.",
    },
    {
      headline: 'Pleasantly plump.',
      subtitle: "Strolling along, soft and content.",
      meta: 'good rhythm',
      footer: "Carry on, sweet thing — I'm comfy.",
    },
    {
      headline: 'Such a nice day.',
      subtitle: "My broth's still warm and my heart's full.",
      meta: 'good ground covered',
      footer: "A little more if you fancy — no rush.",
    },
    {
      headline: 'Gently simmering.',
      subtitle: "We're keeping a lovely, easy pace.",
      meta: 'walking along',
      footer: "Mmm, this is the good kind of walking.",
    },
    {
      headline: 'Soft and settled.',
      subtitle: "Folded up and feeling just right.",
      meta: 'fair distance',
      footer: "Let's amble on, darling — together.",
    },
    {
      headline: 'Content little dumpling.',
      subtitle: "A walk and a sigh — what more could I want?",
      meta: 'on our way',
      footer: "Stay close, genatsvale, and we'll drift on.",
    },
    {
      headline: 'All toasty inside.',
      subtitle: "We've made honest little steps, you and I.",
      meta: 'steady going',
      footer: "Lead on gently — I'm right beside you.",
    },
    {
      headline: 'Sweet and steady.',
      subtitle: "No fuss, just a happy stroll, darling.",
      meta: 'good pace',
      footer: "I could wander like this all afternoon.",
    },
    {
      headline: 'Lovely little walk.',
      subtitle: "My pleats are humming, all is well.",
      meta: 'out and about',
      footer: "Whenever you're ready, sweetie — softly does it.",
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'All tuckered out.',
      subtitle: 'You wore me out — napping it off.',
      meta: 'all worn out',
      footer: 'What a day. Let me snooze this one off.',
    },
    {
      headline: 'Steamed and sleepy.',
      subtitle: "We walked so far, darling — I'm done.",
      meta: 'fully steamed',
      footer: "Let me rest my doughy little self.",
    },
    {
      headline: 'Plumb worn out.',
      subtitle: "My pleats are drooping, sweet thing.",
      meta: 'all rested up',
      footer: "Such a big day. Wake me at dawn, hmm?",
    },
    {
      headline: 'Soft and droopy.',
      subtitle: "You really gave me a workout, genatsvale.",
      meta: 'turned in',
      footer: "Time to cool on the plate and dream.",
    },
    {
      headline: 'Sleepy dumpling.',
      subtitle: "My broth's gone cosy-warm and I'm fading.",
      meta: 'eyes heavy',
      footer: "Let me settle, darling — rest is the treat.",
    },
    {
      headline: 'Done for the day.',
      subtitle: "We did so much! Now I must steam in peace.",
      meta: 'worn through',
      footer: "Tuck me in, sweetie. See you bright and early.",
    },
    {
      headline: 'Cooling down now.',
      subtitle: "All these steps left me so deliciously tired.",
      meta: 'resting up',
      footer: "Off to dreamland — be soft with me.",
    },
    {
      headline: 'Limp little pleats.',
      subtitle: "You walked the spice right out of me, darling.",
      meta: 'fast asleep',
      footer: "Hush now. Let me snooze it off, genatsvale.",
    },
    {
      headline: 'Sweetly spent.',
      subtitle: "What a feast of a day — I'm all out.",
      meta: 'plumb tired',
      footer: "Nothing left but warm dreams. Night, sweetie.",
    },
    {
      headline: 'Ready for bed.',
      subtitle: "So many steps! My dough is heavy now.",
      meta: 'all worn out',
      footer: "Let me rest, darling. I earned this nap.",
    },
  ],
}
