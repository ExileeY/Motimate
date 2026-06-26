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
    {
      headline: 'Just dug up!',
      subtitle: 'Shook the soil off, feeling spry.',
      meta: 'fresh from the dirt',
      footer: "A young bulba can't sit in the dark all day.",
    },
    {
      headline: 'Sprouts are itching.',
      subtitle: 'Little green shoots want to stretch out.',
      meta: 'barely budged',
      footer: 'Come on, the garden path is waiting.',
    },
    {
      headline: 'Bulba on the move?',
      subtitle: "I've got energy for a whole sotka today.",
      meta: 'still in the patch',
      footer: 'Lead the way and I roll right after you.',
    },
    {
      headline: 'Cellar door is open!',
      subtitle: 'Out of the dark and into the sun, da?',
      meta: 'just woke up',
      footer: "Don't fancy going back in just yet — let's stroll.",
    },
    {
      headline: 'Firm and frisky.',
      subtitle: 'Not a soft spot on me, ready to go.',
      meta: 'hardly a step',
      footer: 'A good bulba needs a good wander.',
    },
    {
      headline: 'Eyes wide open.',
      subtitle: 'All my little eyes are sprouting at once.',
      meta: 'fresh-dug',
      footer: "Plenty of daylight — let's not waste it.",
    },
    {
      headline: 'Skin still on!',
      subtitle: 'Unpeeled, unbothered, and raring to roll.',
      meta: 'quiet morning',
      footer: 'Point me down the row and I follow.',
    },
    {
      headline: 'Bursting with starch.',
      subtitle: 'Got enough in me for a long ramble.',
      meta: 'no ground covered',
      footer: 'Could outwalk a whole field today, honest.',
    },
    {
      headline: 'Hello from the soil!',
      subtitle: "Sun's up and so am I, ready to go.",
      meta: 'barely stirred',
      footer: 'Walk with me — the bulba insists.',
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Soaking it in.',
      subtitle: 'Happy to amble whenever.',
      meta: 'in the sun',
      footer: 'Photosynthesising nicely — out when you are.',
    },
    {
      headline: 'Warm and easy.',
      subtitle: 'Good ground covered, no need to rush.',
      meta: 'easy pace',
      footer: 'A steady bulba is a happy bulba.',
    },
    {
      headline: 'Sun on my skin.',
      subtitle: 'Made fair distance, feeling just right.',
      meta: 'fair distance',
      footer: "We're walking nice and honest, da?",
    },
    {
      headline: 'Settled in the row.',
      subtitle: 'Roots are comfy, legs are willing.',
      meta: 'good rhythm',
      footer: 'This here is a fine pace, friend.',
    },
    {
      headline: 'Content as draniki.',
      subtitle: 'A good walk does a bulba right.',
      meta: 'movin along',
      footer: 'No complaints from the patch today.',
    },
    {
      headline: 'Mellow and round.',
      subtitle: "Warmed through and steppin' easy.",
      meta: 'on the path',
      footer: 'Could keep this gentle pace all day.',
    },
    {
      headline: 'Honest miles.',
      subtitle: "We've earned 'em, one row at a time.",
      meta: 'miles earned',
      footer: 'Slow and sure fills the cellar, friend.',
    },
    {
      headline: 'Sotka well-tended.',
      subtitle: 'Nice and even, the way bulba likes it.',
      meta: 'steady going',
      footer: 'Plenty of light left to keep on.',
    },
    {
      headline: 'Cosy in the field.',
      subtitle: 'Breath easy, soil warm, all is well.',
      meta: 'in our stride',
      footer: 'Lead on whenever you fancy it.',
    },
    {
      headline: 'Right as rain.',
      subtitle: 'Good ground behind us and feeling fine.',
      meta: 'feeling fine',
      footer: "A watered bulba walks happy — let's keep on.",
    },
  ],
  [Mood.TIRED]: [
    {
      headline: 'Wilting a little.',
      subtitle: 'Big day in the sun. Time to rest.',
      meta: 'all grown out',
      footer: 'All grown out for today. Night night.',
    },
    {
      headline: 'Off to the cellar.',
      subtitle: 'Bulba is tired and the dark is cosy.',
      meta: 'cellar-bound',
      footer: "Earned this rest. See you at first light.",
    },
    {
      headline: 'Soft and sleepy.',
      subtitle: 'Walked the whole patch, now I sag.',
      meta: 'plumb wilted',
      footer: 'Let me settle into the soil a while.',
    },
    {
      headline: 'Sprouts are drooping.',
      subtitle: 'Even a bulba runs out of starch.',
      meta: 'worn through',
      footer: 'Tuck me in the dark and let me be.',
    },
    {
      headline: 'Done for the day.',
      subtitle: 'Covered enough rows for one bulba.',
      meta: 'rows are done',
      footer: 'Quiet cellar, warm dark. Goodnight.',
    },
    {
      headline: 'Back in the dirt.',
      subtitle: 'A weary potato needs its bed of soil.',
      meta: 'turned in',
      footer: 'Long day behind us. Rest is the reward.',
    },
    {
      headline: 'Heavy as a sack.',
      subtitle: 'Whole sotka walked, now I rest easy.',
      meta: 'bone-tired',
      footer: 'Wake me when the sun warms the field.',
    },
    {
      headline: 'Eyes shutting slow.',
      subtitle: "Did my miles. Now I let 'em settle.",
      meta: 'resting up',
      footer: "Nothing left but the cool and the quiet.",
    },
    {
      headline: 'Tucked away.',
      subtitle: 'Earned my rest the honest way today.',
      meta: 'fast asleep',
      footer: 'Sleep well, friend. Bulba surely will.',
    },
    {
      headline: 'Spent and snug.',
      subtitle: 'A hard-walked bulba sleeps the soundest.',
      meta: 'all rested out',
      footer: 'See you at dawn, da? Night night.',
    },
  ],
}
