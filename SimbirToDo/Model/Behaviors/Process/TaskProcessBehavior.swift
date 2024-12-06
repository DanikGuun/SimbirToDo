
protocol TaskProcessBehavior {
    var task: ToDoTask { get set }
    func process(with info: TaskInfo)
}
