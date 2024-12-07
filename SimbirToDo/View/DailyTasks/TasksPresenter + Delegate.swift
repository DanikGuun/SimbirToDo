
import Foundation
import UIKit

protocol TasksPresenterProtocol: UIView {
    
    var delegate: TasksPresenterDelegate? { get set }
    
    func addTask(taskInfo: TaskInfo)
    func reloadData()
    func updateTask(taskInfo: TaskInfo)
    func removeTask(taskInfo: TaskInfo)
    
}

protocol TasksPresenterDelegate {
    
    func tasksPresenter(requestToEditTaskWith id: UUID)
    
}
