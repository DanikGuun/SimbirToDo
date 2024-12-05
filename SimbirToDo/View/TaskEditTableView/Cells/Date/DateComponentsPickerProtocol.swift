
import UIKit

protocol DateComponentsPickerProtocol: UITableViewCell{
    
    var delegate: DateComponentsPickerDelegate? { get set }
    var minimumDate: Date { get set }
    
    func setDate(_ date: Date)
}

protocol DateComponentsPickerDelegate{
    
    func dateComponentsPicker(_ picker: DateComponentsPickerProtocol, didSelect dateComponents: DateComponents)
    
}
