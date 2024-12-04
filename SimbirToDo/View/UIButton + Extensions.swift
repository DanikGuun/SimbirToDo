
import UIKit

extension UIButton {
    
    func apply(_ style: ButtonStyleType) {
        switch style {
        case .gray(let selectedColor):
            self.setTitleColor(.label1, for: .normal)
            self.setTitleColor(selectedColor, for: .selected)
            self.setTitleColor(selectedColor, for: .highlighted)
            self.backgroundColor = .tertiaryFill
            self.layer.cornerRadius = 5
        }
    }
}

enum ButtonStyleType {
    case gray(selectedColor: UIColor = .label1)
}
