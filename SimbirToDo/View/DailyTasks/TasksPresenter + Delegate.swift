
import Foundation
import UIKit

protocol TasksPresenterProtocol: UIView {
    
    var delegate: TasksPresenterDelegate? { get set }
    
    func addTask(taskMeta: TaskMetadata)
    func clearTasks()
    
}

protocol TasksPresenterDelegate {
    
    func tasksPresenter(requestToEditTaskWith id: UUID)
    
}
