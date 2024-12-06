
import RealmSwift

class DeleteTask: DeletionBehavior{
    
    private let realm: Realm?
    
    var task: ToDoTask
    
    func delete() {
        do{
            try realm?.write{
                realm?.delete(task)
            }
        }
        catch { print("Failed to delete task: \(error.localizedDescription)") }
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
