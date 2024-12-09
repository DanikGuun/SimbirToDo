
import RealmSwift

class TaskManager{
    
    class func getTasksForDate(_ date: Date) -> [ToDoTask] {
        var tasks: [ToDoTask] = []
        
        guard let realm = try? Realm() else { return tasks }
        
        for task in realm.objects(ToDoTask.self) {
            
            let startComps = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let startDay = Calendar.current.date(from: startComps)!
            let dayInterval = DateInterval(start: startDay, duration: 86399)
            
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            
            if dayInterval.contains(taskDate){
                tasks.append(task)
            }
            
        }
        
        return tasks
    }
    
    //задания, которыые активны в момент времени
    class func getTasksForTime(_ time: Date) -> [ToDoTask] {
        
        var tasks: [ToDoTask] = []
        
        guard let realm = try? Realm() else { return tasks }
        
        for task in realm.objects(ToDoTask.self) {

            if task.dateStart <= time.timeIntervalSince1970 && task.dateEnd >= time.timeIntervalSince1970 {
                tasks.append(task)
            }

        }
        return tasks
        
    }
    
}
