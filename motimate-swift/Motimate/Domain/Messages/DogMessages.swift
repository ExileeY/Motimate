import Foundation

let dogMessages: [Mood: [MessageSet]] = [
    .energetic: [
        MessageSet(
            headline: "Walk? Walk?!",
            subtitle: "Leash is by the door — let's go!",
            meta: "quiet so far",
            footer: "Come on — out for a lap of the block?"
        ),
        MessageSet(
            headline: "You're up!",
            subtitle: "I heard your feet on the floor and now my tail won't stop.",
            meta: "barely moved",
            footer: "Just one little walk? Pretty please, with a treat on top?"
        ),
        MessageSet(
            headline: "Outside? Outside!",
            subtitle: "There are so many smells out there waiting for us.",
            meta: "still resting",
            footer: "Grab your shoes and I'll grab my leash — deal?"
        ),
        MessageSet(
            headline: "Ready, ready, ready!",
            subtitle: "I did three spins by the door already, just in case.",
            meta: "fresh start",
            footer: "A short stroll would make this the best day ever."
        ),
        MessageSet(
            headline: "Pick me, pick me!",
            subtitle: "I'll be the goodest boy if we go for a wander.",
            meta: "quiet so far",
            footer: "The grass is dewy and perfect — shall we sniff it together?"
        ),
        MessageSet(
            headline: "Hi! Hi! Hi!",
            subtitle: "Every time you look at me my whole back end wiggles.",
            meta: "barely moved",
            footer: "Let's go say good morning to the whole street!"
        ),
        MessageSet(
            headline: "Bouncy paws!",
            subtitle: "I cannot sit still — there's a whole world to trot through.",
            meta: "fresh start",
            footer: "One loop around the park and I promise to be calm. Promise!"
        ),
        MessageSet(
            headline: "Adventure time?",
            subtitle: "My nose is twitching at the door — it knows something fun is near.",
            meta: "still resting",
            footer: "You, me, and the sidewalk. Best team ever, right?"
        ),
        MessageSet(
            headline: "Leash o'clock!",
            subtitle: "I brought it to you. It's right here. See? See?",
            meta: "quiet so far",
            footer: "Just a little walkies before the day gets busy?"
        ),
        MessageSet(
            headline: "Let's GO!",
            subtitle: "My zoomies are loaded and ready to launch out the door.",
            meta: "barely moved",
            footer: "I'll lead the way — you just hold the other end, okay?"
        ),
    ],
    .calm: [
        MessageSet(
            headline: "Ready to roam.",
            subtitle: "A gentle lap sounds lovely.",
            meta: "good and steady",
            footer: "Good and steady — out whenever you like."
        ),
        MessageSet(
            headline: "Cozy and content.",
            subtitle: "I've had a nice morning sniff, and now I'm just happy you're near.",
            meta: "easy pace",
            footer: "A slow amble later would be perfect — no rush at all."
        ),
        MessageSet(
            headline: "Good day so far.",
            subtitle: "Tail wagging soft and slow, just the way I like it.",
            meta: "cruising",
            footer: "Whenever your feet feel like wandering, mine are ready."
        ),
        MessageSet(
            headline: "Comfy spot found.",
            subtitle: "Warm sunbeam, full belly, my favourite human close by.",
            meta: "mellow",
            footer: "A short stroll would be nice — but here is nice too."
        ),
        MessageSet(
            headline: "Soft and snuggly.",
            subtitle: "I leaned my head on your foot and I'm so glad I did.",
            meta: "good and steady",
            footer: "Let's mosey out together when the mood feels right."
        ),
        MessageSet(
            headline: "Just right.",
            subtitle: "Not too bouncy, not too sleepy — a happy little pup.",
            meta: "easy pace",
            footer: "A gentle wander down the lane, maybe? No hurry, friend."
        ),
        MessageSet(
            headline: "Pleasantly pottering.",
            subtitle: "I sniffed the garden, said hi to a bee, all is well.",
            meta: "mellow",
            footer: "We can stretch our legs whenever you fancy it."
        ),
        MessageSet(
            headline: "Easy does it.",
            subtitle: "My paws are relaxed and my heart is full.",
            meta: "cruising",
            footer: "A soft stroll would suit us both nicely, don't you think?"
        ),
        MessageSet(
            headline: "Happy and calm.",
            subtitle: "I did a big stretch, a little yawn, and now I'm smiling.",
            meta: "good and steady",
            footer: "Out whenever you like — I'll be right by your side."
        ),
        MessageSet(
            headline: "All is well.",
            subtitle: "Belly rubs were had, naps were good, you are here.",
            meta: "easy pace",
            footer: "A leisurely loop sounds lovely — at your pace, always."
        ),
    ],
    .tired: [
        MessageSet(
            headline: "Tuckered out.",
            subtitle: "Best walk ever. Snoozing now.",
            meta: "all walked out",
            footer: "Huge day. Curling up till morning."
        ),
        MessageSet(
            headline: "Sleepy paws.",
            subtitle: "We walked so far — my little legs are all done.",
            meta: "pooped",
            footer: "Thank you for the adventure. Nap time for this good boy."
        ),
        MessageSet(
            headline: "So worn out.",
            subtitle: "I sniffed everything there was to sniff. Mission complete.",
            meta: "spent",
            footer: "Curling into a donut now — see you after my snooze."
        ),
        MessageSet(
            headline: "Happy and floppy.",
            subtitle: "My tail managed one last wag, then flopped right down.",
            meta: "all walked out",
            footer: "Best day. Resting my eyes by your feet now."
        ),
        MessageSet(
            headline: "Big day, little dog.",
            subtitle: "I chased a leaf, met a friend, and now I'm all yawns.",
            meta: "pooped",
            footer: "Tuck me in? I'll dream of all our walks."
        ),
        MessageSet(
            headline: "Snooze mode on.",
            subtitle: "Warm, tired, and so very content after all that wandering.",
            meta: "turning in",
            footer: "Goodnight, friend. We did so well today."
        ),
        MessageSet(
            headline: "Pooped pup.",
            subtitle: "Every paw is heavy and every part of me is happy.",
            meta: "spent",
            footer: "No more steps tonight — just cozy dreams."
        ),
        MessageSet(
            headline: "Time for a curl.",
            subtitle: "I'm finding my softest spot to flop into.",
            meta: "turning in",
            footer: "Wake me gently in the morning, okay?"
        ),
        MessageSet(
            headline: "All done in.",
            subtitle: "My nose is tired, my legs are jelly, my heart is full.",
            meta: "all walked out",
            footer: "Sweet dreams from your sleepy little dog."
        ),
        MessageSet(
            headline: "Nap o'clock.",
            subtitle: "I gave today everything I had, and it was wonderful.",
            meta: "pooped",
            footer: "Curling up tight now — thank you for the best walks."
        ),
    ],
    .sad: [
        MessageSet(
            headline: "I've been waiting.",
            subtitle: "By the door, leash in mouth, all day.",
            meta: "feeling low",
            footer: "Just one walk? My tail would wag again."
        ),
        MessageSet(
            headline: "No walkies?",
            subtitle: "It makes my ears droop something awful.",
            meta: "lonely",
            footer: "I miss the smell of the path with you."
        ),
        MessageSet(
            headline: "Sad puppy.",
            subtitle: "The day feels long without our adventure.",
            meta: "no walks",
            footer: "A short stroll and I promise to be the happiest pup."
        ),
    ],
]
