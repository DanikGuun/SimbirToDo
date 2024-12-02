
import UIKit

class TaskEditContoller: UIViewController{
    
    var taskProcessBehavior: TaskProcessBehavior?
    var deletionBehavior: DeletionBehavior? { didSet { deletionBehaviorChanged() } }
    
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
        self.view.backgroundColor = .gray
    }
    
    //MARK: - UI
    func setupUI() {
        
    }
    
    //MARK: - Other
    private func deletionBehaviorChanged(){
        if deletionBehavior != nil{
            
        }
    }
}
