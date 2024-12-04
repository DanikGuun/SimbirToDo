
import UIKit

protocol DateComponentsPickerProtocol: UITableViewCell{
    
    var delegate: DateComponentsPickerDelegate? { get set }
    
}

protocol DateComponentsPickerDelegate{
    
    func dateComponentsPicker(didSelect dateComponents: DateComponents)
    
}
