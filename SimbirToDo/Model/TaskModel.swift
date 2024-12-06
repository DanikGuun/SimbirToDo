
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
    let name: String
    let taskDescription: String
    let dateInterval: DateInterval
    
    init (name: String, description: String, dateInterval: DateInterval){
        self.name = name
        self.taskDescription = description
        self.dateInterval = dateInterval
    }
    
    init (task: ToDoTask?){
        var name = ""
        var description = ""
        var dateInterval = DateInterval(start: Date(), duration: 3600)
        
        if let task{
            name = task.title
            description = task.taskDescription
            
            let startDate = Date(timeIntervalSince1970: task.dateStart)
            let endDate = Date(timeIntervalSince1970: task.dateEnd)
            dateInterval = DateInterval(start: startDate, end: endDate)
        }
        
        self.init(name: name, description: description, dateInterval: dateInterval)
    }
}
