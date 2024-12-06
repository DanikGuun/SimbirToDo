
import UIKit

class TaskEditContoller: UIViewController{
    
    //Behaviors
    var taskProcessBehavior: TaskProcessBehavior?
    var deletionBehavior: DeletionBehavior? { didSet { deletionBehaviorChanged() } }
    
    //UI
    private var deleteBarItem: UIBarButtonItem!
    private var applyBarItem: UIBarButtonItem!
    private var taskEditerTable: TaskEditerProtocol!
    
    
    //
    //MARK: - Lifecycle
    //
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
    
    //
    //MARK: - UI
    //
    func setupUI() {
        setupApplyButton()
        setupDeleteBarItem()
        setupFormTableView()
    }
    
    //
    //MARK: - Apply BarButton
    //
    private func setupApplyButton(){
        let image = UIImage(named: "checkmark")
        applyBarItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(applyBarItemPressed))
        
        self.navigationItem.rightBarButtonItems = [applyBarItem]
    }
    
    @objc private func applyBarItemPressed(){
        guard let taskInfo = taskEditerTable.getInfo() else { return }
        taskProcessBehavior?.process(with: taskInfo)
    }
    
    //
    //MARK: Delete BarButton
    //
    private func setupDeleteBarItem(){
        let image = UIImage(named: "trash")
        deleteBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteBarItemPressed))
        
        deleteBarItem.tintColor = .red
        deletionBehaviorChanged()
    }
    
    @objc func deleteBarItemPressed(){
        deletionBehavior?.delete()
    }
    
    //
    //MARK: - Form TableView
    //
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
    
    //
    //MARK: - Other
    //
    private func deletionBehaviorChanged(){
        if deletionBehavior == nil{
            self.navigationItem.rightBarButtonItems?.removeAll(where: { $0 == deleteBarItem })
        }
        else{
            self.navigationItem.rightBarButtonItems?.append(deleteBarItem)
        }
    }
}
