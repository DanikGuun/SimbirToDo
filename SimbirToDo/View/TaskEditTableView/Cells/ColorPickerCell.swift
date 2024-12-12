
import UIKit

class ColorPickerCell: TaskEditCell, TaskEditCellProtocol {
    typealias InfoType = UIColor
    
    //UI
    private var mainStackView: UIStackView!
    private var currentColor: UIColor = .black
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        setupMainStackView()
        
        for color in [UIColor.systemBlue, .systemGreen, .systemRed, .yellowSunrise, .aquamarine, .lightPurple, .systemGray]{
            addColorPick(color)
        }
        setInfo(.systemBlue)
    }
    
    //MARK: Main StackView
    private func setupMainStackView() {
        mainStackView = UIStackView()
        self.contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(5)
            maker.height.equalTo(30)
        }
        
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 3
    }
    
    //MARK: - Color Picks
    private func addColorPick(_ color: UIColor){
        
        let pick = ColorPickView()
        pick.color = color
        pick.addTarget(self, action: #selector(colorPickSelect), for: .touchUpInside)
        mainStackView.addArrangedSubview(pick)
        
    }
    
    @objc private func colorPickSelect(_ colorPick: UIControl){
        
        if let picker = (colorPick as? ColorPickView), colorPick.isSelected == false{
            colorPick.isSelected = true
            setInfo(picker.color)
        }
        
    }
    //
    //MARK: - Task Edit Cell Protocol
    //
    func getInfo() -> UIColor {
        return currentColor
    }
    
    func setInfo(_ info: UIColor) {
        currentColor = info
        
        for color in mainStackView.arrangedSubviews{
            if let picker = color as? ColorPickView {
                picker.isSelected = picker.color == info
            }
        }
    }
    
}
