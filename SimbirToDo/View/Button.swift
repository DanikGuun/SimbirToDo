
import UIKit

class Button: UIButton{
    
    var isSelectionPrimaryAction: Bool = false { didSet { if isSelectionPrimaryAction { changeSelection() } } }
    var selectedColor: UIColor = .systemBlue
    override var isSelected: Bool { didSet { changeSelection() } }
    var action: ((UIButton) -> Void)?
    
    //
    //MARK: - Lifecycle
    //
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        self.adjustsImageWhenHighlighted = false
        self.tintColor = .systemBlue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = isSelectionPrimaryAction ? 1 : 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1
        
        if let touch = touches.first {
            if isSelectionPrimaryAction, self.bounds.contains(touch.location(in: self)){
                self.isSelected.toggle()
            }
        }
        
        self.action?(self)
        
    }
    
    private func changeSelection(){
        self.tintColor = isSelected ? selectedColor : .label1
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.setTitleColor(self.tintColor, for: .normal)
    }
    
    //
    //MARK: - Style
    //
    func apply(_ style: ButtonStyleType) {
        switch style {
        case .gray(let selectedColor):
            self.selectedColor = selectedColor
            self.backgroundColor = .tertiaryFill
            self.layer.cornerRadius = 5
        }
    }
}

enum ButtonStyleType {
    case gray(selectedColor: UIColor = .label1)
}
