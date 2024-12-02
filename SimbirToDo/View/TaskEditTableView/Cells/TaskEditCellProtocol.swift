
import UIKit

protocol TaskEditCellProtocol: UITableViewCell {
    associatedtype InfoType
    
    func setInfo(_ info: InfoType)
    func getInfo() -> InfoType
    
}
