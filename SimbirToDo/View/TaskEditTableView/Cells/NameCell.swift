
import UIKit
import SnapKit

class NameCell: TaskEditCell, TaskEditCellProtocol{
    typealias InfoType = String
    
    //UI
    private var nameField: UITextField!
    
    //MARK: - UI
    override func setupUI(){
        super.setupUI()
        
        nameField = UITextField()
        self.contentView.addSubview(nameField)
        
        nameField.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.height.equalTo(UIScreen.main.bounds.height/20)
        }
        
        nameField.placeholder = "Название..."
    }
    
    //MARK: - EditCell Protocol
    
    func setInfo(_ info: InfoType) {
        nameField.text = info
    }
    
    func getInfo() -> InfoType {
        return nameField.text ?? ""
    }
}
