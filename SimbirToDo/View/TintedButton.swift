
import UIKit

class TintedButton: UIButton{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.adjustsImageWhenHighlighted = false
        self.alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.setTitleColor(self.tintColor, for: .normal)
    }
    
}
