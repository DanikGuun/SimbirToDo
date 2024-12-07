
import RealmSwift

class ToDoTask: Object {
    let id = UUID()
    @Persisted dynamic var title: String
    @Persisted dynamic var taskDescription: String
    @Persisted dynamic var dateStart: Double //TimeStamp
    @Persisted dynamic var dateEnd: Double //TimeStamp
    
    override init() {
        self.title = ""
        self.taskDescription = ""
        self.dateStart = Date().timeIntervalSince1970
        self.dateEnd = Date(timeIntervalSinceNow: 3600).timeIntervalSince1970
    }
}

enum TaskProcessType{
    case add
    case edit
}

///ToDoTask для проброски во вьюшки, чтобы не привязывать их к модели
struct TaskInfo{
    let id: UUID?
    let name: String
    let taskDescription: String
    let dateInterval: DateInterval
    
    init(id: UUID?, name: String, taskDescription: String, dateInterval: DateInterval){
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.dateInterval = dateInterval
    }
    
    init (name: String, taskDescription: String, dateInterval: DateInterval){
        self.init(id: nil, name: name, taskDescription: taskDescription, dateInterval: dateInterval)
    }
    
    init (task: ToDoTask?){
        var name = ""
        var taskDescription = ""
        var dateInterval = DateInterval(start: Date(), duration: 3600)
        var id: UUID? = nil
        
        if let task{
            name = task.title
            taskDescription = task.taskDescription
            id = task.id
            
            let startDate = Date(timeIntervalSince1970: task.dateStart)
            let endDate = Date(timeIntervalSince1970: task.dateEnd)
            dateInterval = DateInterval(start: startDate, end: endDate)
        }
        
        self.init(id: id, name: name, taskDescription: taskDescription, dateInterval: dateInterval)
    }
}
