
import RealmSwift

class EditTask: TaskProcessBehavior{
    
    var task: ToDoTask
    private let realm: Realm?
    
    func process(with info: TaskInfo) {
        
        do{
            try realm?.write {
                task.title = info.name
                task.dateStart = info.dateInterval.start.timeIntervalSince1970
                task.dateEnd = info.dateInterval.end.timeIntervalSince1970
                task.color = info.color
                task.taskDescription = info.taskDescription
            }
        }
        catch { print("Error to submit task: \(error.localizedDescription)") }
    }
    
    init(task: ToDoTask) {
        
        self.task = task
        do{
            realm = try Realm()
        }
        catch{
            realm = nil
            print("Realm failed to initialize: \(error.localizedDescription)")
        }
        
    }
    
}
