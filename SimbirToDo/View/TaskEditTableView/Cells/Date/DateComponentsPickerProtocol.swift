
import UIKit

protocol DateComponentsPickerProtocol: UITableViewCell{
    
    var delegate: DateComponentsPickerDelegate? { get set }
    
}

protocol DateComponentsPickerDelegate{
    
    func dateComponentsPicker(_ picker: DateComponentsPickerProtocol, didSelect dateComponents: DateComponents)
    
}
