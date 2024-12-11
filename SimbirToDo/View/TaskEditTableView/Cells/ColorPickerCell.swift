
import UIKit

class ColorPickerCell: TaskEditCell, TaskEditCellProtocol {
    typealias InfoType = UIColor
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        
    }
    
    
    
    //
    //MARK: - TaskEditCellProtocol
    //
    func getInfo() -> UIColor {
        return .green
    }
    
    func setInfo(_ info: UIColor) {
        
    }
    
}
