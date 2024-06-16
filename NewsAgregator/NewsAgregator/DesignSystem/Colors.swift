import UIKit

extension UIColor {
    static let inlyBlack = UIColor { traits in
        if traits.userInterfaceStyle == .dark {
            return UIColor.inlyWhiteUniversal
        } else {
            return UIColor.inlyBlackUniversal
        }
    }

    static let inlyWhite = UIColor { traits in
        if traits.userInterfaceStyle == .dark {
            return UIColor.inlyBlackUniversal
        } else {
            return UIColor.inlyWhiteUniversal
        }
    }

    static let inlyLightGray = UIColor { traits in
        if traits.userInterfaceStyle == .dark {
            return UIColor(hexString: "#2C2C2E")
        } else {
            return UIColor(hexString: "#F7F7F8")
        }
    }

    static let inlyGrayUniversal = UIColor(hexString: "625C5C")
    static let inlyRedUniversal = UIColor(hexString: "F56B6C")
    static let inlyBackgroundUniversal = UIColor(hexString: "1A1B2280")
    static let inlyGreenUniversal = UIColor(hexString: "1C9F00")
    static let inlyBlueUniversal = UIColor(hexString: "0A84FF")
    static let inlyBlackUniversal = UIColor(hexString: "1A1B22")
    static let inlyWhiteUniversal = UIColor(hexString: "FFFFFF")
    static let inlyYellowUniversal = UIColor(hexString: "FEEF0D")
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
}
