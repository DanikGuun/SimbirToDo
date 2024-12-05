
import UIKit

class TaskEditContoller: UIViewController{
    
    //Behaviors
    var taskProcessBehavior: TaskProcessBehavior?
    var deletionBehavior: DeletionBehavior? { didSet { deletionBehaviorChanged() } }
    
    //UI
    private var deleteBarItem: UIBarButtonItem!
    private var taskEditerTable: TaskEditerProtocol!
    
    
    //MARK: - Lifecycle
    convenience init(taskProcessBehavior: TaskProcessBehavior, deletionBehavior: DeletionBehavior? = nil){
        self.init(nibName: nil, bundle: nil)
        self.taskProcessBehavior = taskProcessBehavior
        self.deletionBehavior = deletionBehavior
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setup() {
        self.view.backgroundColor = .primaryContollerBackground
    }
    
    //MARK: - UI
    func setupUI() {
        setupDeleteBarItem()
        setupFormTableView()
    }
    
    //MARK: Delete Bar Button
    private func setupDeleteBarItem(){
        let image = UIImage(named: "trash")
        deleteBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteBarItemPressed))
        
        deleteBarItem.tintColor = .red
        self.navigationItem.rightBarButtonItem = deleteBarItem
        deletionBehaviorChanged()
    }
    
    @objc func deleteBarItemPressed(){
        
    }
    
    //MARK: - Form TableView
    private func setupFormTableView(){
        
        let style: UITableView.Style
        if #available(iOS 15.0, *) {
            style = .insetGrouped
        } else {
            style = .grouped
        }
        
        taskEditerTable = TaskEditTableView(frame: .zero, style: style)
        self.view.addSubview(taskEditerTable)
        
        taskEditerTable.snp.makeConstraints {[weak self] maker in
            guard let self = self else { return }
            maker.leading.top.trailing.equalToSuperview()
            
            if #available(iOS 17.0, *) {
                self.view.keyboardLayoutGuide.usesBottomSafeArea = false
                maker.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            } else {
                maker.bottom.equalToSuperview()
            }
        }
        
        taskEditerTable.initialInfo = TaskInfo(task: taskProcessBehavior?.task)
    }
    
    //MARK: - Other
    private func deletionBehaviorChanged(){
        self.navigationItem.rightBarButtonItem = deletionBehavior != nil ? deleteBarItem : nil
    }
}

//
//MARK: - Task Editer Delegate
//
extension TaskEditContoller: TaskEditerDelegate {
    
    func taskEditer(_ taskEditer: any TaskEditerProtocol, didFinishEditingWith info: TaskInfo) {
        
        taskProcessBehavior?.process(with: info)
        
    }
    
}
