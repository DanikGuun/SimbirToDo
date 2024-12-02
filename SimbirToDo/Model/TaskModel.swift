
import RealmSwift

class ToDoTask: Object {
    let id = UUID()
    @Persisted var title: String
    @Persisted var taskDescription: String
    @Persisted var dateStart: Double //TimeStamp
    @Persisted var dateEnd: Double //TimeStamp
}

enum TaskProcessType{
    case add
    case edit
}
