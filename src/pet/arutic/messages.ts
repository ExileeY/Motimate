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
    {
      headline: "Trail's callin'.",
      subtitle: "Horse is rested, partner. So am I.",
      meta: 'barely stirred',
      footer: "Ain't no use sittin' still — come on now.",
    },
    {
      headline: 'Itchin to move.',
      subtitle: "Reckon that horizon won't wait on us.",
      meta: 'still in camp',
      footer: "Whole frontier's out there waitin'.",
    },
    {
      headline: "Daylight's wastin'.",
      subtitle: "Sun's up and we're standin' around.",
      meta: 'hardly a step',
      footer: "Let's not waste good light, partner.",
    },
    {
      headline: 'Rarin to go.',
      subtitle: "Got more spirit than a green-broke colt.",
      meta: 'fresh out the gate',
      footer: "Point me at the open country.",
    },
    {
      headline: 'Boots are on.',
      subtitle: "Spurs jinglin', ready when you are.",
      meta: "mornin's young",
      footer: "Say the word and we're gone.",
    },
    {
      headline: "Restless soul.",
      subtitle: "A man wasn't made to sit, partner.",
      meta: 'no ground covered',
      footer: "There's miles out there with our name on 'em.",
    },
    {
      headline: "Let's ride out.",
      subtitle: "Coffee's drunk and the trail is dry.",
      meta: 'fresh legs',
      footer: "Whole day ahead — best we use it.",
    },
    {
      headline: 'Got the itch.',
      subtitle: "Can't keep a wild heart penned up.",
      meta: 'barely moved',
      footer: "Open road's the only cure I know.",
    },
    {
      headline: "Mornin', partner.",
      subtitle: "Sky's clear and my feet are eager.",
      meta: 'just woke up',
      footer: "Lead on — I'll keep right beside you.",
    },
  ],
  [Mood.CALM]: [
    {
      headline: 'Ready to ride.',
      subtitle: "Say the word and we'll head out.",
      meta: 'good ground covered',
      footer: "Good ground covered — trail's open when you are.",
    },
    {
      headline: 'Steady pace.',
      subtitle: "Made fair distance, no need to rush.",
      meta: 'fair distance',
      footer: "We're makin' honest time, partner.",
    },
    {
      headline: 'Easy in the saddle.',
      subtitle: "Found our rhythm out on the trail.",
      meta: 'good rhythm',
      footer: "This is the pace that gets you home.",
    },
    {
      headline: 'Holdin steady.',
      subtitle: "Mile after mile, nice and even.",
      meta: 'on the trail',
      footer: "Slow and sure beats fast and foolish.",
    },
    {
      headline: 'Fair bit of road.',
      subtitle: "Behind us now, more if you fancy.",
      meta: 'road behind us',
      footer: "Plenty of light left to keep on goin'.",
    },
    {
      headline: 'Content enough.',
      subtitle: "A good walk does a body right.",
      meta: "movin' along",
      footer: "No complaints from me, partner.",
    },
    {
      headline: 'Trail suits us.',
      subtitle: "Wind's fair and the goin's smooth.",
      meta: "smooth goin'",
      footer: "Could carry on like this all day.",
    },
    {
      headline: 'Honest miles.',
      subtitle: "We've earned 'em, one step at a time.",
      meta: 'miles earned',
      footer: "Keep it steady and we'll do just fine.",
    },
    {
      headline: 'Findin our stride.',
      subtitle: "Legs warm, breath easy, all's well.",
      meta: 'in our stride',
      footer: "This here's good walkin' weather.",
    },
    {
      headline: 'Right as rain.',
      subtitle: "Made good ground and feelin' fine.",
      meta: "feelin' fine",
      footer: "Lead on when you're ready, partner.",
    },
  ],
  [Mood.TIRED]: [
    {
      headline: "Restin' easy.",
      subtitle: "Long ride today. Hat's over my eyes.",
      meta: 'all rode out',
      footer: "A hard day's ride. Wakin' at dawn.",
    },
    {
      headline: 'Rode hard.',
      subtitle: "Bones are weary and the fire's warm.",
      meta: 'plumb wore out',
      footer: "Earned this rest, partner. Every bit of it.",
    },
    {
      headline: "Hangin' up the spurs.",
      subtitle: "Covered enough ground for one day.",
      meta: 'spurs hung up',
      footer: "Camp's made. Catch you come mornin'.",
    },
    {
      headline: 'All rode out.',
      subtitle: "These legs have carried me far enough.",
      meta: 'legs spent',
      footer: "Time to let the fire die down slow.",
    },
    {
      headline: 'Weary bones.',
      subtitle: "A man's gotta rest after a ride like that.",
      meta: 'bone-tired',
      footer: "Wake me when the sun comes up.",
    },
    {
      headline: "Settlin' in.",
      subtitle: "Bedroll's down and the stars are out.",
      meta: 'turned in',
      footer: "Long trail behind us. Rest is the reward.",
    },
    {
      headline: 'Done for the day.',
      subtitle: "Reckon we've gone far enough, partner.",
      meta: "trail's end",
      footer: "Coffee'll be on at first light.",
    },
    {
      headline: "Worn to the bone.",
      subtitle: "Saddle's off, fire's low, eyes are heavy.",
      meta: 'worn through',
      footer: "Let me sleep this hard ride off.",
    },
    {
      headline: "Campfire's low.",
      subtitle: "Did our miles. Now we let 'em settle.",
      meta: "restin' up",
      footer: "Nothin' left but the quiet and the dark.",
    },
    {
      headline: 'Hat over the eyes.',
      subtitle: "Earned my rest the honest way today.",
      meta: 'fast asleep',
      footer: "See you at dawn, partner. Sleep well.",
    },
  ],
  [Mood.SAD]: [
    {
      headline: 'No trail to ride.',
      subtitle: 'Sure is lonesome out here…',
      meta: 'none in days',
      footer: 'No trail in days — I miss it, partner.',
    },
    {
      headline: 'Quiet on the range.',
      subtitle: 'Been a long spell since we last set out.',
      meta: 'feeling low',
      footer: 'A little ride would do this heart good.',
    },
    {
      headline: 'Missin\' the open road.',
      subtitle: "It's awful still without you, partner.",
      meta: 'lonely',
      footer: 'Saddle up with me? Even a short one.',
    },
  ],
}
