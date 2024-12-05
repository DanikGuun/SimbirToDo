
import Foundation
import UIKit

protocol TaskEditerProtocol: UIView{
    
    var taskDelegate: TaskEditerDelegate? { get set }
    var initialInfo: TaskInfo? { get set }
    func setInfo(_ info: TaskInfo)
    func getInfo() -> TaskInfo?
    
}

protocol TaskEditerDelegate{
    
    func taskEditer(_ taskEditer: TaskEditerProtocol, updateWith info: TaskInfo)
    func taskEditer(_ taskEditer: TaskEditerProtocol, didFinishEditingWith info: TaskInfo)
    
}

extension TaskEditerDelegate{
    func taskEditer(_ taskEditer: TaskEditerProtocol, updateWith info: TaskInfo){}
    func taskEditer(_ taskEditer: TaskEditerProtocol, didFinishEditingWith info: TaskInfo){}
}
