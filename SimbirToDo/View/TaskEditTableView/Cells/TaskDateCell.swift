
import UIKit
import SnapKit

class TaskDateCell: TaskEditCell, TaskEditCellProtocol {
    typealias InfoType = DateInterval
    
    //MARK: - UI
    override func setupUI() {
        super.setupUI()
        self.contentView.backgroundColor = .green
    }
    
    //MARK: - EditCell protocol
    func setInfo(_ info: DateInterval) {
        
    }
    
    func getInfo() -> DateInterval {
        return DateInterval(start: Date(), end: Date())
    }
}
