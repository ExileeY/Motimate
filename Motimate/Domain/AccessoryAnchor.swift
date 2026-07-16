import CoreGraphics

struct AccessoryAnchor: Equatable {
    let position: CGPoint
    let scale: CGFloat
    let spread: CGFloat
    let rotationDegrees: Double

    init(
        position: CGPoint,
        scale: CGFloat,
        spread: CGFloat = 1,
        rotationDegrees: Double
    ) {
        self.position = position
        self.scale = scale
        self.spread = spread
        self.rotationDegrees = rotationDegrees
    }

    static let identity = AccessoryAnchor(
        position: CGPoint(x: 90, y: 90),
        scale: 1,
        rotationDegrees: 0
    )
}

func uniformAnchor(_ anchor: AccessoryAnchor) -> [PetId: AccessoryAnchor] {
    Dictionary(uniqueKeysWithValues: PetId.allCases.map { ($0, anchor) })
}

private let babyCompanionAnchor = AccessoryAnchor(
    position: CGPoint(x: 150, y: 150),
    scale: 1,
    rotationDegrees: 0
)

let ACCESSORY_ANCHORS: [AccessoryId: [PetId: AccessoryAnchor]] = [
    .coolShades: [
        .mochi: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 1,
            rotationDegrees: 0
        ),
        .bulbashik: AccessoryAnchor(
            position: CGPoint(x: 90, y: 92),
            scale: 1.05,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .dog: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .octopus: AccessoryAnchor(
            position: CGPoint(x: 90, y: 55),
            scale: 1.28,
            spread: 1.5,
            rotationDegrees: 0
        ),
        .arutic: AccessoryAnchor(
            position: CGPoint(x: 90, y: 105),
            scale: 0.95,
            spread: 0.85,
            rotationDegrees: 0
        ),
        .khinklear: AccessoryAnchor(
            position: CGPoint(x: 90, y: 95),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .tomato: AccessoryAnchor(
            position: CGPoint(x: 90, y: 110),
            scale: 1.1,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .schnauzer: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
    ],
    .threeDGlasses: [
        .mochi: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 1,
            rotationDegrees: 0
        ),
        .bulbashik: AccessoryAnchor(
            position: CGPoint(x: 90, y: 92),
            scale: 1.05,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .dog: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .octopus: AccessoryAnchor(
            position: CGPoint(x: 90, y: 55),
            scale: 1.28,
            spread: 1.5,
            rotationDegrees: 0
        ),
        .arutic: AccessoryAnchor(
            position: CGPoint(x: 90, y: 105),
            scale: 0.95,
            spread: 0.85,
            rotationDegrees: 0
        ),
        .khinklear: AccessoryAnchor(
            position: CGPoint(x: 90, y: 95),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .tomato: AccessoryAnchor(
            position: CGPoint(x: 90, y: 110),
            scale: 1.1,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .schnauzer: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
    ],
    .heartShades: [
        .mochi: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 1,
            rotationDegrees: 0
        ),
        .bulbashik: AccessoryAnchor(
            position: CGPoint(x: 90, y: 92),
            scale: 1.05,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .dog: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .octopus: AccessoryAnchor(
            position: CGPoint(x: 90, y: 55),
            scale: 1.28,
            spread: 1.5,
            rotationDegrees: 0
        ),
        .arutic: AccessoryAnchor(
            position: CGPoint(x: 90, y: 105),
            scale: 0.95,
            spread: 0.85,
            rotationDegrees: 0
        ),
        .khinklear: AccessoryAnchor(
            position: CGPoint(x: 90, y: 95),
            scale: 0.95,
            rotationDegrees: 0
        ),
        .tomato: AccessoryAnchor(
            position: CGPoint(x: 90, y: 110),
            scale: 1.1,
            spread: 0.9,
            rotationDegrees: 0
        ),
        .schnauzer: AccessoryAnchor(
            position: CGPoint(x: 90, y: 85),
            scale: 0.95,
            rotationDegrees: 0
        ),
    ],
    .babyMochi: uniformAnchor(babyCompanionAnchor),
    .babySchnauzer: uniformAnchor(babyCompanionAnchor),
    .babyDuckling: uniformAnchor(babyCompanionAnchor)
]

func accessoryAnchor(_ accessory: AccessoryId, _ pet: PetId) -> AccessoryAnchor {
    ACCESSORY_ANCHORS[accessory]?[pet] ?? .identity
}
