import { Mood } from '@/pet/mood'
import { MessageSet } from '@/pet/messages'

export const schnauzerMessages: Record<Mood, MessageSet[]> = {
  [Mood.ENERGETIC]: [
    {
      headline: "Let's patrol!",
      subtitle: "Leash by the door — I'll lead the way.",
      meta: 'quiet so far',
      footer: 'Come on — out for a lap of the block?',
    },
    {
      headline: 'Boots on?',
      subtitle: 'The perimeter checks itself. Inspection at dawn, partner.',
      meta: 'barely moved',
      footer: 'One round of the block and the streets are secure again.',
    },
    {
      headline: 'Beard at attention.',
      subtitle: 'I groomed the whiskers and I am ready for duty.',
      meta: 'still resting',
      footer: 'Grab the leash — these sidewalks won\'t sniff themselves.',
    },
    {
      headline: 'Reporting for walks!',
      subtitle: 'Tail standing by, ears up, nose primed and twitching.',
      meta: 'fresh start',
      footer: 'A brisk march would set the whole day straight.',
    },
    {
      headline: 'Hup, two, three!',
      subtitle: 'I have been pacing the hallway like a tiny sergeant.',
      meta: 'quiet so far',
      footer: 'Out we go — left paw, right paw, around the block.',
    },
    {
      headline: 'Door watch begins.',
      subtitle: 'I have my eye on that handle and my whole back end is wiggling.',
      meta: 'barely moved',
      footer: 'Just one patrol? The neighbourhood needs us, you know.',
    },
    {
      headline: 'Whiskers twitching.',
      subtitle: 'Something interesting is out there and I intend to find it.',
      meta: 'fresh start',
      footer: 'A lap of the park and I promise to file a full report.',
    },
    {
      headline: 'On guard, ready!',
      subtitle: 'Bushy brows up, beard combed, leash located. All systems go.',
      meta: 'still resting',
      footer: 'You hold the lead, I\'ll handle the scouting. Deal?',
    },
    {
      headline: 'Leash, please!',
      subtitle: 'I brought it over and dropped it at your feet. Subtle, I know.',
      meta: 'quiet so far',
      footer: 'A short walkies before the day gets busy — what do you say?',
    },
    {
      headline: 'March with me?',
      subtitle: 'My little legs have zoomies loaded and the door in their sights.',
      meta: 'barely moved',
      footer: 'Out for a wander — I\'ll trot point and you bring up the rear.',
    },
  ],
  [Mood.CALM]: [
    {
      headline: "All's well.",
      subtitle: 'Happy to potter about the yard.',
      meta: '5,200 steps',
      footer: 'Good and steady — out whenever you like.',
    },
    {
      headline: 'Perimeter secure.',
      subtitle: 'Did my rounds, all is quiet, beard nicely settled.',
      meta: 'good and steady',
      footer: 'A gentle amble later would suit me fine — no rush at all.',
    },
    {
      headline: 'Steady on patrol.',
      subtitle: 'Tail wagging slow and even, just the way a good dog likes it.',
      meta: 'cruising',
      footer: 'Whenever your feet feel like wandering, mine are ready.',
    },
    {
      headline: 'Comfy post found.',
      subtitle: 'Warm sunbeam, full belly, my favourite human within sniffing range.',
      meta: 'mellow',
      footer: 'A short stroll would be nice — but here is rather nice too.',
    },
    {
      headline: 'Beard at ease.',
      subtitle: 'I leaned against your shin and I am quite content about it.',
      meta: 'good and steady',
      footer: 'Let\'s mosey out together when the mood feels right.',
    },
    {
      headline: 'Just right.',
      subtitle: 'Not too bouncy, not too sleepy — a steady old guard dog.',
      meta: 'easy pace',
      footer: 'A gentle wander down the lane, perhaps? No hurry, friend.',
    },
    {
      headline: 'Pottering nicely.',
      subtitle: 'Inspected the garden, nodded at a bee, declared all in order.',
      meta: 'mellow',
      footer: 'We can stretch our legs whenever you fancy it.',
    },
    {
      headline: 'Easy does it.',
      subtitle: 'Paws relaxed, whiskers still, heart full and quietly proud.',
      meta: 'cruising',
      footer: 'A soft stroll would suit us both, don\'t you think?',
    },
    {
      headline: 'Content and combed.',
      subtitle: 'Had a big stretch, a small yawn, and a very dignified sit.',
      meta: 'good and steady',
      footer: 'Out whenever you like — I\'ll be right at your heel.',
    },
    {
      headline: 'All in order.',
      subtitle: 'Belly rubs received, naps approved, you are present and accounted for.',
      meta: 'easy pace',
      footer: 'A leisurely loop sounds lovely — at your pace, always.',
    },
  ],
  [Mood.TIRED]: [
    {
      headline: "Beard's done in.",
      subtitle: 'Big day on patrol. Time to flop.',
      meta: '12,400 steps',
      footer: 'Huge day. Curling up till morning.',
    },
    {
      headline: 'Off duty.',
      subtitle: 'We marched so far my little legs have officially clocked out.',
      meta: 'all walked out',
      footer: 'Thank you for the patrol. Lights out for this good dog.',
    },
    {
      headline: 'Worn-out warden.',
      subtitle: 'Sniffed every post there was to sniff. Mission accomplished.',
      meta: 'spent',
      footer: 'Curling into a donut now — wake me for the morning shift.',
    },
    {
      headline: 'Floppy and proud.',
      subtitle: 'The beard managed one last wag, then surrendered to gravity.',
      meta: 'all walked out',
      footer: 'Best day. Resting my whiskers by your feet now.',
    },
    {
      headline: 'Big day, old dog.',
      subtitle: 'Chased a leaf, greeted a friend, secured the block. Now: yawns.',
      meta: 'pooped',
      footer: 'Tuck me in? I\'ll dream of the perfect patrol.',
    },
    {
      headline: 'Standing down.',
      subtitle: 'Warm, weary, and deeply satisfied after a long day on the beat.',
      meta: 'turning in',
      footer: 'Goodnight, partner. We held the line today.',
    },
    {
      headline: 'Heavy paws.',
      subtitle: 'Every limb is sandbags and every part of me is happy.',
      meta: 'spent',
      footer: 'No more steps tonight — just cosy, well-earned dreams.',
    },
    {
      headline: 'Time to curl.',
      subtitle: 'Locating the softest patch in the house to flop into.',
      meta: 'turning in',
      footer: 'Wake me gently in the morning, would you?',
    },
    {
      headline: 'Fully done in.',
      subtitle: 'Nose tired, legs jelly, beard flat, heart absolutely full.',
      meta: 'all walked out',
      footer: 'Sweet dreams from your sleepy old patrol dog.',
    },
    {
      headline: 'Nap o\'clock.',
      subtitle: 'Gave today every ounce I had, and it was a fine, fine day.',
      meta: 'pooped',
      footer: 'Curling up tight now — thank you for the long walks.',
    },
  ],
  [Mood.SAD]: [
    {
      headline: 'The door stayed shut.',
      subtitle: 'No walk today… again.',
      meta: 'none in days',
      footer: 'No walks for days — I miss the door.',
    },
    {
      headline: 'No patrol?',
      subtitle: 'My beard droops and my post sits empty.',
      meta: 'feeling low',
      footer: 'Just one round of the block? My tail would wag again.',
    },
    {
      headline: 'Waiting by the door.',
      subtitle: 'Leash in mouth, ears down, watching the handle that won\'t turn.',
      meta: 'lonely',
      footer: 'A short stroll and I\'d be the proudest dog on the street.',
    },
  ],
}
