import UIKit
import SwiftUI

extension Color {
    static let appBlue = Color("appCustomBlue")
    static let appLightGray = Color("appCustomLightGray")
    static let appRed = Color("appCustomRed")
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
