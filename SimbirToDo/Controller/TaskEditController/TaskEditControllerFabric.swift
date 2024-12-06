
class TaskEditControllerFabric{
    
    public class func create(task: ToDoTask? = nil, type: TaskProcessType) -> TaskEditContoller? {
        let processBehavior: TaskProcessBehavior
        let deleteBehavior: DeletionBehavior?
        
        switch type {
        case .add:
            processBehavior = AddTask()
            deleteBehavior = nil
        case .edit:
            guard let task else { return nil }
            processBehavior = EditTask(task: task)
            deleteBehavior = DeleteTask(task: task)
        }
        
        return TaskEditContoller(taskProcessBehavior: processBehavior, deletionBehavior: deleteBehavior)
    }
    
}
