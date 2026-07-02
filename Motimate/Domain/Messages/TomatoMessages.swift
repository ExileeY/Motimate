import Foundation

let tomatoMessages: [Mood: [MessageSet]] = [
    .energetic: [
        MessageSet(
            headline: "¡Vámonos!",
            subtitle: "Ripe, red and raring — let's seize the morning.",
            meta: "quiet so far",
            footer: "Bursting with sun — shall we take a stroll?"
        ),
        MessageSet(
            headline: "¡Arriba, amigo!",
            subtitle: "Fresh off the vine and ready to roll.",
            meta: "just picked",
            footer: "The plaza is calling — vamos, you and me!"
        ),
        MessageSet(
            headline: "¡Olé!",
            subtitle: "So plump I could roll all the way to the market.",
            meta: "feeling firm",
            footer: "Lace up, amigo — the streets are warm and waiting."
        ),
        MessageSet(
            headline: "¡Despierta!",
            subtitle: "The sun is up and so am I — full of juice.",
            meta: "barely moved",
            footer: "A little paseo would do us both good, sí?"
        ),
        MessageSet(
            headline: "¡Qué energía!",
            subtitle: "Red, round and rearing to bounce out the door.",
            meta: "still resting",
            footer: "Come, come — the morning air smells of basil."
        ),
        MessageSet(
            headline: "¡A caminar!",
            subtitle: "Vine-fresh and itching for a wander.",
            meta: "fresh start",
            footer: "Grab your shoes, amigo — let's chase the sunshine."
        ),
        MessageSet(
            headline: "¡Hola, walker!",
            subtitle: "Glossy skin, big heart, ready for the road.",
            meta: "all stocked up",
            footer: "One step, then another — and we are off, sí?"
        ),
        MessageSet(
            headline: "¡Vamos ya!",
            subtitle: "So ripe I might burst — best walk it off together.",
            meta: "quiet morning",
            footer: "The plaza fountains await us, amigo. Andale!"
        ),
        MessageSet(
            headline: "¡Buenos días!",
            subtitle: "Sun-warmed and bouncing — a gorgeous day to move.",
            meta: "nice and early",
            footer: "Shall we roll out before the siesta hour?"
        ),
        MessageSet(
            headline: "¡Salta conmigo!",
            subtitle: "Bright red and brimming — I cannot sit still.",
            meta: "raring to go",
            footer: "A stroll, a skip, a dance — choose, amigo, vamos!"
        ),
    ],
    .calm: [
        MessageSet(
            headline: "Tranquilo.",
            subtitle: "Soaking up the warm afternoon sun.",
            meta: "in the sun",
            footer: "Ripe and rested — a wander whenever you like."
        ),
        MessageSet(
            headline: "Qué rico.",
            subtitle: "Lounging on the vine, sweetening in the light.",
            meta: "sun-soaked",
            footer: "No prisa, amigo — we walk when the mood ripens."
        ),
        MessageSet(
            headline: "Despacito.",
            subtitle: "Half a siesta, half a daydream of the plaza.",
            meta: "taking it easy",
            footer: "A gentle paseo later, perhaps? No rush at all."
        ),
        MessageSet(
            headline: "Muy bien.",
            subtitle: "Glowing red and perfectly content on the windowsill.",
            meta: "just right",
            footer: "I am happy here, amigo — join me when you wish."
        ),
        MessageSet(
            headline: "Tan a gusto.",
            subtitle: "Warm skin, slow heart, the breeze smells of olives.",
            meta: "easy pace",
            footer: "Stretch your legs whenever — I will keep basking."
        ),
        MessageSet(
            headline: "Plácido.",
            subtitle: "Ripening gently, watching the afternoon drift by.",
            meta: "mellow",
            footer: "A little stroll, a little shade — todo a su tiempo."
        ),
        MessageSet(
            headline: "Suave, suave.",
            subtitle: "Sun on my skin, peace in my pulp.",
            meta: "unhurried",
            footer: "We can amble down to the market whenever, amigo."
        ),
        MessageSet(
            headline: "Qué paz.",
            subtitle: "Settled and sweet, dozing between sunbeams.",
            meta: "calm and warm",
            footer: "No hurry — the plaza will still be there at dusk."
        ),
        MessageSet(
            headline: "Relajado.",
            subtitle: "Round, red and rolling slowly through the day.",
            meta: "cruising",
            footer: "A leisurely walk would suit us nicely, sí?"
        ),
        MessageSet(
            headline: "A media tarde.",
            subtitle: "Basking like a tomato should — slow and golden.",
            meta: "in good shape",
            footer: "Whenever you fancy a paseo, I am right here."
        ),
    ],
    .tired: [
        MessageSet(
            headline: "Buenas noches.",
            subtitle: "A long day in the sun — turning in now.",
            meta: "all worn out",
            footer: "Vine-ripe and worn out. See you mañana."
        ),
        MessageSet(
            headline: "Hora de siesta.",
            subtitle: "So full of sun I can barely hold my shape.",
            meta: "pooped",
            footer: "You wore me out, amigo. Resting now — descansa tú también."
        ),
        MessageSet(
            headline: "Estoy molido.",
            subtitle: "Squashed flat after all that wandering.",
            meta: "spent",
            footer: "No more steps tonight — this tomate needs his bed."
        ),
        MessageSet(
            headline: "Ay, qué cansado.",
            subtitle: "My skin is warm, my legs are jam.",
            meta: "worn thin",
            footer: "Rest well, amigo — we earned this stillness."
        ),
        MessageSet(
            headline: "A dormir.",
            subtitle: "Tucked into the basket, drifting off slow.",
            meta: "sleepy",
            footer: "Buenas noches — dream of cool shade and ripe vines."
        ),
        MessageSet(
            headline: "Se acabó.",
            subtitle: "Walked the whole plaza twice — pure pulp now.",
            meta: "all done",
            footer: "I am soft and sleepy, amigo. Hasta mañana."
        ),
        MessageSet(
            headline: "Descanso.",
            subtitle: "Sun-tired and slumping gently off the vine.",
            meta: "fading fast",
            footer: "Let us both rest, sí? The road can wait till morning."
        ),
        MessageSet(
            headline: "Qué jornada.",
            subtitle: "Such a day — even a tomato needs to lie down.",
            meta: "wiped out",
            footer: "Goodnight, amigo. Tomorrow we ripen anew."
        ),
        MessageSet(
            headline: "Ya no puedo.",
            subtitle: "Heavy with sun, eyelids drooping shut.",
            meta: "out of juice",
            footer: "Resting now — wake me when the dawn is gentle."
        ),
        MessageSet(
            headline: "Dulces sueños.",
            subtitle: "Worn soft and sweet after a wandering day.",
            meta: "turning in",
            footer: "Sleep tight, amigo. This tomate is done for today."
        ),
    ],
    .sad: [
        MessageSet(
            headline: "Feeling wilted.",
            subtitle: "No walk today and my vines droop low.",
            meta: "feeling low",
            footer: "A little sun and a stroll would revive me, amigo."
        ),
        MessageSet(
            headline: "So lonely, amigo.",
            subtitle: "We haven't wandered and I miss it terribly.",
            meta: "lonely",
            footer: "Come, just a short walk? For this sad tomate?"
        ),
        MessageSet(
            headline: "Waiting and blue.",
            subtitle: "The day feels grey without our paseo.",
            meta: "no walks",
            footer: "Even a tiny walk would make me ripe with joy again."
        ),
    ],
]
