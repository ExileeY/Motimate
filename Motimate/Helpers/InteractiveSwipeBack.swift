import SwiftUI
import UIKit

private struct InteractiveSwipeBack: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Controller()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private final class Controller: UIViewController {
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}

extension View {
    func enableInteractiveSwipeBack() -> some View {
        background(
            InteractiveSwipeBack()
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)
        )
    }
}
