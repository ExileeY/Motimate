import Foundation

let octopusMessages: [Mood: [MessageSet]] = [
    .energetic: [
        MessageSet(
            headline: "Let's gooo!",
            subtitle: "All eight arms say outside!",
            meta: "quiet so far",
            footer: "Brimming with energy — fancy a wander?"
        ),
        MessageSet(
            headline: "Wheee!",
            subtitle: "Eight little arms, eight little wiggles.",
            meta: "barely a ripple",
            footer: "I am bubbling all over — come swim the day with me?"
        ),
        MessageSet(
            headline: "Pssst, friend!",
            subtitle: "I squished my whole self into a happy springy ball.",
            meta: "still tide",
            footer: "Want to go drift somewhere lovely? I will hold your hand."
        ),
        MessageSet(
            headline: "Bloop bloop!",
            subtitle: "So bouncy I keep poking myself awake.",
            meta: "calm waters",
            footer: "A little wander would tickle me pink — shall we?"
        ),
        MessageSet(
            headline: "Up and at it!",
            subtitle: "Each arm reaching for a different adventure.",
            meta: "hardly moved",
            footer: "I have wiggles to spare — lend me your feet and walk?"
        ),
        MessageSet(
            headline: "Ooh, hi you!",
            subtitle: "Full of fizz and ready to ripple along.",
            meta: "gentle morning",
            footer: "Eight arms, one wish: a stroll with you. Pretty please?"
        ),
        MessageSet(
            headline: "Squish squish!",
            subtitle: "I have been doodling little loops in the water all morning.",
            meta: "quiet current",
            footer: "Let us go somewhere — I will count our steps on my arms."
        ),
        MessageSet(
            headline: "Tickly toes!",
            subtitle: "Every sucker is tingling to get going.",
            meta: "low tide",
            footer: "Come on, sweet thing — the day is wide and waiting."
        ),
        MessageSet(
            headline: "Wiggle time!",
            subtitle: "I am all sproingy and full of bubbles today.",
            meta: "still and soft",
            footer: "A wander, a wobble, a wonderful walk — pick one with me?"
        ),
        MessageSet(
            headline: "Let us swim!",
            subtitle: "Eight arms whirling like happy little ribbons.",
            meta: "barely stirred",
            footer: "I cannot hold still — take me out for a tiny adventure?"
        ),
    ],
    .calm: [
        MessageSet(
            headline: "Hey, you.",
            subtitle: "Eight arms, all relaxed.",
            meta: "drifting along",
            footer: "Drifting along — out for a wander whenever."
        ),
        MessageSet(
            headline: "Mmm, cozy.",
            subtitle: "Just bobbing here, soft and round and happy.",
            meta: "easy current",
            footer: "No rush, friend — we can drift out whenever you like."
        ),
        MessageSet(
            headline: "So snug.",
            subtitle: "Curled my arms into a little pillow for myself.",
            meta: "gentle tide",
            footer: "I am comfy as can be — join me when the mood floats by."
        ),
        MessageSet(
            headline: "Bloop, hello.",
            subtitle: "Swaying slow, watching the bubbles rise.",
            meta: "mellow waters",
            footer: "A gentle wander later, maybe? I am in no hurry at all."
        ),
        MessageSet(
            headline: "Just floaty.",
            subtitle: "Half a nap, half a daydream of the open sea.",
            meta: "taking it easy",
            footer: "We can amble along whenever — I will keep on swaying."
        ),
        MessageSet(
            headline: "All soft.",
            subtitle: "My arms are doing slow little ribbons in the water.",
            meta: "unhurried",
            footer: "Stretch your legs whenever, sweet one — I am right here."
        ),
        MessageSet(
            headline: "Quiet and round.",
            subtitle: "Settled and squishy, dozing between the currents.",
            meta: "calm and warm",
            footer: "No hurry — the sea will still be lovely come evening."
        ),
        MessageSet(
            headline: "Drifting easy.",
            subtitle: "Eight arms trailing soft behind me, content as can be.",
            meta: "cruising slow",
            footer: "A leisurely wander would suit us nicely, would it not?"
        ),
        MessageSet(
            headline: "Peaceful blub.",
            subtitle: "Just being a calm little blob in a calm little sea.",
            meta: "in good shape",
            footer: "Whenever you fancy a stroll, I will float right along."
        ),
        MessageSet(
            headline: "Soft tides.",
            subtitle: "Rocking gently, letting the day drift past.",
            meta: "slow and golden",
            footer: "A little wander, a little rest — all in good time, friend."
        ),
    ],
    .tired: [
        MessageSet(
            headline: "All squished out.",
            subtitle: "Big swim today. Sinking into a nap.",
            meta: "all swum out",
            footer: "A full day. Drifting off now."
        ),
        MessageSet(
            headline: "So sleepy.",
            subtitle: "All eight arms have gone wonderfully floppy.",
            meta: "pooped",
            footer: "You wore me out, friend — resting now. Rest you too."
        ),
        MessageSet(
            headline: "Nap o'clock.",
            subtitle: "Curled into a tired little spiral on the seabed.",
            meta: "spent",
            footer: "No more wiggles tonight — this octopus needs his bed."
        ),
        MessageSet(
            headline: "Oof, what a swim.",
            subtitle: "My arms are noodles and my eyes are closing.",
            meta: "worn thin",
            footer: "Rest well, sweet one — we earned this quiet."
        ),
        MessageSet(
            headline: "Drifting off.",
            subtitle: "Tucked under a soft current, sinking slow.",
            meta: "sleepy",
            footer: "Goodnight — dream of warm shallows and gentle tides."
        ),
        MessageSet(
            headline: "All swum out.",
            subtitle: "Looped the whole reef twice — pure jelly now.",
            meta: "all done",
            footer: "I am soft and sleepy, friend. See you in the morning."
        ),
        MessageSet(
            headline: "Quiet now.",
            subtitle: "Swim-tired and slumping gently to the sandy floor.",
            meta: "fading fast",
            footer: "Let us both rest, yes? The sea can wait till dawn."
        ),
        MessageSet(
            headline: "What a day.",
            subtitle: "Such a swim — even an octopus needs to lie down.",
            meta: "wiped out",
            footer: "Goodnight, friend. Tomorrow we ripple anew."
        ),
        MessageSet(
            headline: "Out of bubbles.",
            subtitle: "Heavy and dreamy, all my suckers going still.",
            meta: "out of wiggle",
            footer: "Resting now — wake me when the water turns warm."
        ),
        MessageSet(
            headline: "Sweet dreams.",
            subtitle: "Worn soft and sleepy after a wandering day.",
            meta: "turning in",
            footer: "Sleep tight, sweet thing. This little octopus is done."
        ),
    ],
    .sad: [
        MessageSet(
            headline: "All eight arms ache.",
            subtitle: "For a wander we never took today.",
            meta: "feeling low",
            footer: "A little walk would lift this heavy tide."
        ),
        MessageSet(
            headline: "Adrift and blue.",
            subtitle: "The day's gone still without our stroll.",
            meta: "lonely",
            footer: "I miss drifting along beside you."
        ),
        MessageSet(
            headline: "So lonesome.",
            subtitle: "Even the water feels colder without a walk.",
            meta: "no walks",
            footer: "Just a short one? It would mean everything."
        ),
    ],
]
