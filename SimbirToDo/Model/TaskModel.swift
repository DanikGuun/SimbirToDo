
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

extension Array<ToDoTask> {
    
    func contains(_ taskMeta: TaskMetadata) -> Bool{
        for task in self{
            if task.id == taskMeta.task.id { return true }
        }
        return false
    }
    
}

enum TaskProcessType{
    case add
    case edit
}

///ToDoTask для проброски во вьюшки, чтобы не привязывать их к модели
struct TaskInfo: CustomStringConvertible{
    let id: UUID?
    let name: String
    let taskDescription: String
    let dateInterval: DateInterval
    
    ///время начала дела с начала дня в секундах
    var startTimeSeconds: Double{
        let comps = Calendar.current.dateComponents([.minute, .hour], from: dateInterval.start)
        guard let minutes = comps.minute, let hours = comps.hour else{ return 0 }
        return Double(hours * 3600 + minutes * 60)
    }
    
    ///время конца дела с начала дня в секундах
    var endTimeSeconds: Double{
        let comps = Calendar.current.dateComponents([.minute, .hour], from: dateInterval.end)
        guard let minutes = comps.minute, let hours = comps.hour else{ return 0 }
        return Double(hours * 3600 + minutes * 60)
    }
    
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
    
    var description: String{
        "ID: \(id)\nName: \(name)\nTask description: \(taskDescription)\nDate interval: \(dateInterval)"
    }
}

extension TaskInfo: Equatable{
    static func == (lhs: TaskInfo, rhs: TaskInfo) -> Bool {
        lhs.id == rhs.id
    }
}

class TaskMetadata: Hashable, CustomStringConvertible{
    var task: TaskInfo
    var maxParallelTask: Int
    var position: Int
    
    init(task: TaskInfo, maxParallelTask: Int, position: Int){
        self.task = task
        self.maxParallelTask = maxParallelTask
        self.position = position
    }
    
    init(toDoTask: ToDoTask){
        self.task = TaskInfo(task: toDoTask)
        self.maxParallelTask = 1
        self.position = 0
    }
    
    var description: String{
        "\(task.description)\nPosition: \(position)\nMaximum parallel task: \(maxParallelTask)\n"
    }
    
    func hash(into hasher: inout Hasher) {
        if let id = task.id{
            hasher.combine(id)
        }
        hasher.combine(task.name)
        hasher.combine(task.taskDescription)
        hasher.combine(task.dateInterval)
    }
}

extension TaskMetadata: Equatable{
    static func == (lhs: TaskMetadata, rhs: TaskMetadata) -> Bool {
        lhs.task == rhs.task
    }
}

extension Array<TaskMetadata>{
    func contains(toDoTask: ToDoTask) -> Bool{
        for task in self{
            if let id = task.task.id, id == toDoTask.id{
                return true
            }
        }
        return false
    }
    
    var minPosition: Int{
        let positions = self.map { $0.position }
        for position in 0..<self.count{
            if positions.contains(position) == false { return position }
        }
        return self.count
    }
    
    var maxPosition: Int{
        let positions = self.map { $0.position }
        for position in stride(from: self.count-1, to: 0, by: -1){
            if positions.contains(position) == false { return position }
        }
        return 0
    }
    
}
