import CoreGraphics

let BOX_SIZE: CGFloat = 236
let PET_SIZE: CGFloat = 180

let BOX_CENTER = BOX_SIZE / 2

/// Where a pet's feet sit below its center, as a fraction of `PET_SIZE`
/// (every pet's 180pt canvas puts its feet at ~y 165).
let PET_FOOT_OFFSET: CGFloat = 0.42
