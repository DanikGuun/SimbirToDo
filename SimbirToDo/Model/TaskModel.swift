
import RealmSwift

//
//MARK: - ToDoTask
//
///Объект для хранения в Realm
class ToDoTask: Object {
    @Persisted var id = UUID()
    @Persisted dynamic var title: String
    @Persisted dynamic var taskDescription: String
    @Persisted dynamic var dateStart: Double //TimeStamp
    @Persisted dynamic var dateEnd: Double //TimeStamp
    @Persisted dynamic private var colorData: Data
    
    var color: UIColor{
        get{
            if let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData){
                return color
            }
            return .systemBlue
        }
        set{
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false){
                colorData = data
            }
            else{
                colorData = Data()
            }
        }
    }
    
    override init() {
        self.title = ""
        self.taskDescription = ""
        self.dateStart = Date().timeIntervalSince1970
        self.dateEnd = Date(timeIntervalSinceNow: 3600).timeIntervalSince1970
        
    }
}

extension Array<ToDoTask> {
    
    //для создания меты
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

//
//MARK: - TaskInfo
//
///Информация о задании, чтобы добавлять во сью и не связывать её с моделю
struct TaskInfo: CustomStringConvertible{
    let id: UUID?
    let name: String
    let dateInterval: DateInterval
    let color: UIColor
    let taskDescription: String
    
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
    
    init(id: UUID? = nil, name: String, taskDescription: String, dateInterval: DateInterval, color: UIColor){
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.dateInterval = dateInterval
        self.color = color
    }
    
    init (name: String, taskDescription: String, dateInterval: DateInterval){
        self.init(id: nil, name: name, taskDescription: taskDescription, dateInterval: dateInterval, color: .black)
    }
    
    init (task: ToDoTask?){
        var name = ""
        var taskDescription = ""
        var dateInterval = DateInterval(start: Date(), duration: 3600)
        var id: UUID? = nil
        var color: UIColor = .black
        
        if let task{
            name = task.title
            taskDescription = task.taskDescription
            id = task.id
            color = task.color
            
            let startDate = Date(timeIntervalSince1970: task.dateStart)
            let endDate = Date(timeIntervalSince1970: task.dateEnd)
            dateInterval = DateInterval(start: startDate, end: endDate)
        }
        
        self.init(id: id, name: name, taskDescription: taskDescription, dateInterval: dateInterval, color: color)
    }
    
    var description: String{
        var description: String = ""
        if let id = id { description.append("ID: \(id)\n") }
        description.append("Name: \(name)")
        description.append("\nTask description: \(taskDescription)")
        description.append("Date interval: \(dateInterval)")
        return description
    }
}

extension TaskInfo: Equatable{
    static func == (lhs: TaskInfo, rhs: TaskInfo) -> Bool {
        lhs.id == rhs.id
    }
}

//
//MARK: - TaskMetaData
//
///Содержит доп инфу для отображения, макс. кол-во задач в блоке, позиция задачи
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
    
    //Смотрим наличие задания по id
    func contains(toDoTask: ToDoTask) -> Bool{
        for task in self{
            if let id = task.task.id, id == toDoTask.id{
                return true
            }
        }
        return false
    }
    
    //Минимальная возможная позиция в блоке
    var minPosition: Int{
        let positions = self.map { $0.position }
        for position in 0..<self.count{
            if positions.contains(position) == false { return position }
        }
        return self.count
    }
    
}
