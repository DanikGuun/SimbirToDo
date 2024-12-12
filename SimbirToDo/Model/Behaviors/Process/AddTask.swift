
import RealmSwift

class AddTask: TaskProcessBehavior{
    
    var task: ToDoTask
    private let realm: Realm?
    
    func process(with info: TaskInfo) {
        
        task.title = info.name
        task.dateStart = info.dateInterval.start.timeIntervalSince1970
        task.dateEnd = info.dateInterval.end.timeIntervalSince1970
        task.color = info.color
        task.taskDescription = info.taskDescription
        
        do{
            try realm?.write {
                realm?.add(task)
            }
        }
        catch { print("Failed to add task: \(error.localizedDescription)") }
    }
    
    init() {
        self.task = ToDoTask()
        
        do{
            realm = try Realm()
        }
        catch{
            realm = nil
            print("Realm failed to initialize: \(error.localizedDescription)")
        }
        
    }
    
}
