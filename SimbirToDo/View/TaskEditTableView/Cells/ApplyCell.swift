
import UIKit

class ApplyCell: TaskEditCell {
    
    //UI
    private var applyButton: UIButton!
    
    var action: () -> Void = {}
    var buttonType: ButtonType = .add { didSet { updateAppearance() } }
    //
    //MARK: - UI
    //
    override func setupUI() {
        setupApplyButton()
    }
    
    //
    //MARK: ApplyButton
    //
    private func setupApplyButton(){
        applyButton = UIButton()
        self.contentView.addSubview(applyButton)
        
        applyButton.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.height/20.5)
        }
        
        applyButton.addTarget(self, action: #selector(applyButtonPressed), for: .touchUpInside)
        applyButton.setTitleColor(.blueAction, for: .normal)
        applyButton.setTitleColor(.blueActionHighlited, for: .highlighted)
        applyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        updateAppearance()
    }
    
    private func updateAppearance(){
        let title: String?
        let image: UIImage?
        let highlitedImage: UIImage?
        
        switch buttonType {
        case .add:
            title = "Добавить"
            image = UIImage(named: "plusSquare")
            highlitedImage = UIImage(named: "plusSquareHighlited")
        case .edit:
            title = "Применть"
            image = UIImage(named: "pencilSquare")
            highlitedImage = UIImage(named: "pencilSquareHighlited")
        }
        
        applyButton.setTitle(title, for: .normal)
        applyButton.setImage(image, for: .normal)
        applyButton.setImage(highlitedImage, for: .highlighted)
    }
    
    @objc private func applyButtonPressed(){
        action()
    }
}

enum ButtonType {
    case add
    case edit
}
