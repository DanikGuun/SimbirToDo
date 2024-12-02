
import UIKit

class TaskEditContoller: UIViewController{
    
    //Behaviors
    var taskProcessBehavior: TaskProcessBehavior?
    var deletionBehavior: DeletionBehavior? { didSet { deletionBehaviorChanged() } }
    
    //UI
    private var deleteBarItem: UIBarButtonItem!
    
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
    
    //MARK: - Other
    private func deletionBehaviorChanged(){
        self.navigationItem.rightBarButtonItem = deletionBehavior != nil ? deleteBarItem : nil
    }
}
