
import UIKit

class DailyTaskView: UIView, TasksPresenterProtocol {
    
    var delegate: (any TasksPresenterDelegate)?
    
    //UI
    private var mainStackView: TimeLineStackView!
    private var taskParentView: UIView!
    
    //Service
    private var pinchStartHeight: CGFloat = 0
    private let secondsPerDay: Double = 86400
    
    //
    //MARK: - Lifecycle
    //
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        setupUI()
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(updateHieght))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func updateHieght(_ gesture: UIPinchGestureRecognizer){
        if gesture.state == .began { pinchStartHeight = self.frame.height }
        
        let minHeight = UIScreen.main.bounds.height / 1.5
        let maxHeight = UIScreen.main.bounds.height * 3
        let targetHeight = (gesture.scale * pinchStartHeight).clamp(to: minHeight...maxHeight)
        
        self.snp.updateConstraints{ maker in
            maker.height.equalTo(targetHeight)
            self.mainStackView.setNeedsDisplay()
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.taskParentView.subviews.forEach { $0.setNeedsDisplay() }
    }
    
    //
    //MARK: - UI
    //
    private func setupUI(){
        setupTimeLineStack()
        setupTaskParentView()
    }
    
    
    //MARK: SupplementaryView
    private func setupTimeLineStack(){
        mainStackView = TimeLineStackView()
        self.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
    }
    
    //MARK: Task Parent
    private func setupTaskParentView(){
        taskParentView = UIView()
        self.addSubview(taskParentView)
        
        taskParentView.snp.makeConstraints { maker in
            maker.edges.equalTo(mainStackView.contentLayout)
        }
        
        taskParentView.backgroundColor = .clear
    }
    
    //
    //MARK: - Tasks Presenter Protocol
    //
    
    func addTask(taskMeta: TaskMetadata) {
        let taskInfo = taskMeta.task
        
        let taskView = TaskInfoView()
        taskParentView.addSubview(taskView)
        
        let startTaskOffset = taskInfo.startTimeSeconds / secondsPerDay
        let endTaskOffset = taskInfo.endTimeSeconds / secondsPerDay

        //если брать верхний констрейн и умножать на startTaskOffset, то не работает
        //Поэтому берем нижний + высоту
        taskView.snp.makeConstraints { maker in
            maker.width.equalToSuperview().dividedBy(taskMeta.maxParallelTask)
            maker.leading.equalToSuperview().inset(Int(taskParentView.bounds.width)/taskMeta.maxParallelTask*taskMeta.position)
            maker.height.equalToSuperview().multipliedBy(endTaskOffset - startTaskOffset)
            maker.bottom.equalToSuperview().multipliedBy(endTaskOffset)
        }
        
        taskView.tintColor = [.systemBlue, .systemRed, .systemGreen].randomElement()!
        taskView.title = taskInfo.name
        taskView.id = taskInfo.id
        taskView.backgroundColor = .clear
        
        taskView.addTarget(self, action: #selector(taskViewSelected), for: .touchUpInside)
    }
    
    func clearTasks() {
        taskParentView.subviews.forEach {
            if type(of: $0) == TaskInfoView.self {
                $0.removeFromSuperview()
            }
        }
    }
    
    //NonProtocol
    @objc private func taskViewSelected(_ taskView: TaskInfoView){
        if let id = taskView.id{
            delegate?.tasksPresenter(requestToEditTaskWith: id)
        }
    }
}
