
import UIKit

class ColorPickerCell: TaskEditCell, TaskEditCellProtocol {
    typealias InfoType = UIColor
    
    //UI
    private var mainStackView: UIStackView!
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        setupMainStackView()
        
        for t in [UIColor.systemRed, .systemBlue, .systemGreen, .systemPink]{
            addColorPick(t)
        }
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
    
    @objc private func colorPickSelect(_ view: UIControl){
        view.isSelected.toggle()
        mainStackView.subviews.forEach { if $0 != view { ($0 as! ColorPickView).isSelected = false } }
    }
    //
    //MARK: - Task Edit Cell Protocol
    //
    func getInfo() -> UIColor {
        return .green
    }
    
    func setInfo(_ info: UIColor) {
        
    }
    
}
