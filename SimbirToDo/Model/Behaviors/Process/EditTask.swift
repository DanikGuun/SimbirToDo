
import RealmSwift

class EditTask: TaskProcessBehavior{
    
    var task: ToDoTask
    private let realm: Realm?
    
    func process(with info: TaskInfo) {
        
        task.title = info.name
        task.taskDescription = info.taskDescription
        task.dateStart = info.dateInterval.start.timeIntervalSince1970
        task.dateEnd = info.dateInterval.end.timeIntervalSince1970
        
        do{
            try realm?.write {
                realm?.add(task, update: .modified)
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