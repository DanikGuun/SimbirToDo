
import Foundation
import UIKit

protocol TaskEditerProtocol: UIView{
    
    var initialInfo: TaskInfo? { get set }
    func setInfo(_ info: TaskInfo)
    func getInfo() -> TaskInfo?
    
}
