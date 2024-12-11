
import UIKit
import SnapKit
import RealmSwift

class TasksListController: UIViewController, TasksPresenterDelegate {

    
    //UI
    private var mainScroll: UIScrollView!
    private var datePicker: UIDatePicker!
    private var taskPresenterView: TasksPresenterProtocol!
    private var dateBarButton: UIBarButtonItem!
    
    //Service
    private var isScrollViewAnimating = false
    private var isScrollViewDecelerating = false
    private var isDatePickerCollapsed = false
    
    //
    //MARK: - Lifecycle
    //
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    var isInitialAppear: Bool = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskPresenterView.clearTasks()
        setTasksForDate(datePicker.date)
    }
    
    private func setup(){
        self.view.backgroundColor = .primaryContollerBackground
        self.navigationItem.title = "Задачи"

    }
    
    
    //
    //MARK: - UI
    //
    private func setupUI(){
        setupAddBarButton()
        setupDateBarButton()
        setupMainScroll()
        setupDatePicker()
        setupTaskPresenter()
    }
    
    //MARK: Right Bar Button (Добавить)
    private func setupAddBarButton(){
        let button = Button()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        button.tintColor = .systemBlue
        button.backgroundColor = .blueActionSecondary
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.setTitle("Добавить", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)

        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(addTaskButtonPreessed), for: .touchUpInside)
    }
    
    @objc private func addTaskButtonPreessed(){
        guard let vc = TaskEditControllerFabric.create(type: .add) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Date Bar Button
    private func setupDateBarButton()
    {
        let image = UIImage(named: "calendar.minus")
        dateBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dateBarButtonPressed))
        dateBarButton.tintColor = .systemRed
        self.navigationItem.leftBarButtonItems = [dateBarButton]
    }
    
    @objc private func dateBarButtonPressed(){
        isScrollViewAnimating = true
        changeDatePickerState(isCollapsed: !isDatePickerCollapsed)
        mainScroll.setContentOffset(.zero, animated: true)
    }
    
    //MARK: MainScroll
    private func setupMainScroll(){
        mainScroll = UIScrollView()
        mainScroll.delegate = self
        self.view.addSubview(mainScroll)
        
        mainScroll.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalToSuperview()
        }

    }
    
    //MARK: Date Picker
    private func setupDatePicker(){
        datePicker = UIDatePicker()
        mainScroll.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.height / 2.5)
        }
        
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.addTarget(self, action: #selector(datePickerDateUpdated), for: .valueChanged)
    }
    
    private func changeDatePickerState(isCollapsed: Bool){
        isDatePickerCollapsed = isCollapsed
        
        let targetHeight: CGFloat = isCollapsed ? 0 : UIScreen.main.bounds.height / 2.5
        let targetAlpha: CGFloat = isCollapsed ? 0 : 1
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.datePicker.snp.updateConstraints { maker in
                maker.height.equalTo(targetHeight)
            }
            self?.datePicker.alpha = targetAlpha
            self?.mainScroll.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.isScrollViewAnimating = false
        })
        
        let imageName = isCollapsed ? "calendar" : "calendar.minus"
        dateBarButton.image = UIImage(named: imageName)
        dateBarButton.tintColor = isCollapsed ? .systemBlue : .systemRed
        
    }
    
    @objc func datePickerDateUpdated(_ datePicker: UIDatePicker){
        setTasksForDate(datePicker.date)
    }
    
    //MARK: Task Presenter
    private func setupTaskPresenter(){
        taskPresenterView = DailyTaskView()
        taskPresenterView.delegate = self
        mainScroll.addSubview(taskPresenterView)
        
        taskPresenterView.snp.makeConstraints { maker in
            maker.top.equalTo(datePicker.snp.bottom)
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(1500)
        }
        
    }
    
    func tasksPresenter(requestToEditTaskWith id: UUID) {
        guard let controller = TaskEditControllerFabric.create(taskId: id, type: .edit) else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //
    //MARK: - Service
    //
    
    //MARK: Task Presenting
    private func setTasksForDate(_ date: Date){
        taskPresenterView.clearTasks()
        for task in generateTaskMetadata(date){
            taskPresenterView.addTask(taskMeta: task)
        }
    }
    
    ///Создание меты для заданий (Позиция, макс. кол-во одновременных заданий)
    private func generateTaskMetadata(_ date: Date) -> [TaskMetadata] {
        let calendar = Calendar.current
        
        //Задания для конкретного момента времени
        func tasksForTime(tasks: [ToDoTask], for curDate: Date) -> [ToDoTask]{
            return tasks.filter { $0.dateStart < curDate.timeIntervalSince1970 && $0.dateEnd > curDate.timeIntervalSince1970 }
        }
        
        //Мета для конкретного момента времени
        func metaForTime(meta: [TaskMetadata], for curDate: Date) -> [TaskMetadata]{
            return meta.filter { $0.task.dateInterval.start.timeIntervalSince1970 < curDate.timeIntervalSince1970 && $0.task.dateInterval.end.timeIntervalSince1970 > curDate.timeIntervalSince1970 }
        }
        
        //Соседи для задания (Чтобы ставить макс. значение сразу на весь блок заданий)
        var neighbours: Dictionary<TaskMetadata, NSMutableSet> = [:]
        func updateNeghboursMax(tasks: [TaskMetadata], updated: [TaskMetadata] = []){
            var updated = updated
            let max = tasks.map { $0.maxParallelTask }.max() ?? 0
            
            for task in tasks{
                task.maxParallelTask = max
                
                if updated.contains(task) == false{
                    updated.append(task)
                    if let tasksMap = neighbours[task]?.allObjects.compactMap({ ($0 as? TaskMetadata) ?? nil }){
                        updateNeghboursMax(tasks: tasksMap, updated: updated)
                    }
                }
                
            }
            
        }
        
        
        var allTasks = TaskManager.getTasksForDate(date)//все задания на день
        var metadata: [TaskMetadata] = [] //мета
        var windowMeta: [TaskMetadata] = [] //окно с текущей метой

        var currentTime = calendar.startOfDay(for: date) //Дата по которой смотрим задания, сдвигаем на 5 мин.
        
        while calendar.component(.day, from: currentTime) == calendar.component(.day, from: date){
            
            let currentTasks = tasksForTime(tasks: allTasks, for: currentTime)
            
            for windowTask in windowMeta{
                //Обновляем максимум одновременных заданий, если необходимо
                if windowTask.maxParallelTask <= currentTasks.count{
                    windowTask.maxParallelTask = currentTasks.count
                    updateNeghboursMax(tasks: [windowTask])
                }
                //
                
                //Если текщего заданий нет в заданиях на это время, значит оно кончилось, убираем с окна, переносим в мету
                if currentTasks.contains(windowTask) == false{
                    metadata.append(windowTask)
                    windowMeta.removeAll { $0 == windowTask }
                    allTasks.removeAll { $0.id == windowTask.task.id }
                }
                //
                
                //Обновляем список соседей
                if neighbours[windowTask] == nil{
                    neighbours[windowTask] = NSMutableSet()
                }
                windowMeta.forEach { neighbours[windowTask]?.add($0) }
                //
                
            }
            
            //Если задания нет в окне, т.е. встретилось первый раз, добавляем и задаем мин. позицию
            for task in currentTasks{
                
                if windowMeta.contains(toDoTask: task) == false{
                    let meta = TaskMetadata(toDoTask: task)
                    meta.position = windowMeta.minPosition
                    windowMeta.append(meta)
                }
                
            }
            //
            
            currentTime = currentTime.addingTimeInterval(60)
        }

        return metadata
    }

}

//
//MARK: - UIScrollView Delegate
//
extension TasksListController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        if isScrollViewAnimating == false && isScrollViewDecelerating == false{
            if offset < -80{
                changeDatePickerState(isCollapsed: false)
            }
            else if offset > 30 {
                changeDatePickerState(isCollapsed: true)
            }
        }
        
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollViewAnimating = false
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isScrollViewDecelerating = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrollViewDecelerating = false
    }
}

