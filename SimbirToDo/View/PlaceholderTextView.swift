
import UIKit
import SnapKit

class PlaceholderTextView: UITextView {
    
    private var placeholderLabel = UILabel()
    
    override var font: UIFont? { didSet { placeholderLabel.font = font } }
    var placeholderColor: UIColor? = .gray3{ didSet { placeholderLabel.textColor = placeholderColor } }
    var placeholder: String? { didSet { placeholderLabel.text = placeholder } }
    
    
    //MARK: - Lifecycle
    convenience init(){
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: nil)
        setupPlaceholderLabel()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: UITextView.textDidChangeNotification, object: self)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    //MARK: - UI
    private func setupPlaceholderLabel(){
        self.addSubview(placeholderLabel)
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        
        placeholderLabel.snp.makeConstraints { maker in
            maker.leading.top.equalToSuperview().inset(3)
        }
        
    }
    
    //MARK: - Other
    
    @objc private func updateText(){
        placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    }



    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }

}
