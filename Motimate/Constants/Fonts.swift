import SwiftUI

enum Fonts {
    static func heading(_ size: CGFloat) -> Font { .custom("Fredoka-SemiBold", size: size) }
    static func headingMedium(_ size: CGFloat) -> Font { .custom("Fredoka-Medium", size: size) }
    static func bodyRegular(_ size: CGFloat) -> Font { .custom("Nunito-Regular", size: size) }
    static func bodyBold(_ size: CGFloat) -> Font { .custom("Nunito-Bold", size: size) }
}
