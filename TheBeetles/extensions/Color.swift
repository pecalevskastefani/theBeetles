import UIKit
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Color {
    static let appRed = Color.appCustomRed
    static let appBlue = Color.appCustomBlue
}
