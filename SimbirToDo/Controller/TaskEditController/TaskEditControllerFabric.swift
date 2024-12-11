
import Foundation

class TaskEditControllerFabric{
    
    public class func create(taskId: UUID? = nil, type: TaskProcessType) -> TaskEditContoller? {
        let processBehavior: TaskProcessBehavior
        let deleteBehavior: DeletionBehavior?
        
        let task = TaskManager.getTask(id: taskId)
        
        switch type {
        case .add:
            processBehavior = AddTask()
            deleteBehavior = nil
        case .edit:
            guard let task else { return nil }
            processBehavior = EditTask(task: task)
            deleteBehavior = DeleteTask(task: task)
        }
        
        let controller = TaskEditContoller(taskProcessBehavior: processBehavior, deletionBehavior: deleteBehavior)
        controller.navigationItem.title = task?.title
        return controller
    }
    
}
