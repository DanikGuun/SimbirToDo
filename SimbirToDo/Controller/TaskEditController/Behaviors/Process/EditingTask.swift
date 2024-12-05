
import RealmSwift

class EditingTask: TaskProcessBehavior{
    
    var task: ToDoTask
    
    func process(with info: TaskInfo) {
        
        guard let realm = try? Realm() else { return }
        
        task.title = info.name
        task.taskDescription = info.taskDescription
        task.dateStart = info.dateInterval.start.timeIntervalSince1970
        task.dateEnd = info.dateInterval.end.timeIntervalSince1970
        
        try? realm.write {
            realm.add(task)
        }
    }
    
    init(task: ToDoTask) {
        self.task = task
    }
    
}
