
import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholder: String? { willSet {
        if self.text == "" || self.text == placeholder{
            self.text = newValue
            self.textColor = placeholderColor
        }
    } }
    
    private var nonPlaceholderColor: UIColor? = .label1
    override var textColor: UIColor? { didSet{
        if textColor != placeholderColor{
            nonPlaceholderColor = textColor
        }
    } }
    
    var placeholderColor: UIColor? = .gray3{ didSet {
        if self.text == "" || self.text == placeholder{
            self.textColor = placeholderColor
        }
    } }
    
    //MARK: - InputHandle
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        if self.text == placeholder{
            self.text = ""
            self.textColor = nonPlaceholderColor
        }
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        if self.text == ""{
            self.text = placeholder
            self.textColor = placeholderColor
        }
        return true
    }
}
