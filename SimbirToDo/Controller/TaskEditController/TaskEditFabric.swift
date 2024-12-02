
class TaskEditFabric{
    
    public class func create(task: ToDoTask? = nil, type: TaskProcessType) -> TaskEditContoller? {
        let processBehavior: TaskProcessBehavior
        let deleteBehavior: DeletionBehavior?
        
        switch type {
        case .add:
            processBehavior = AddingTask()
            deleteBehavior = nil
        case .edit:
            guard let task else { return nil }
            processBehavior = EditingTask(task: task)
            deleteBehavior = TaskDeletion(task: task)
        }
        
        return TaskEditContoller(taskProcessBehavior: processBehavior, deletionBehavior: deleteBehavior)
    }
    
}
