
import UIKit
import SnapKit
import RealmSwift

class TasksListController: UIViewController {

    //MARK: - Lifecycle
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setup(){
        
        self.view.backgroundColor = .primaryContollerBackground
        self.navigationItem.title = "Задачи"

    }
    
    //MARK: - UI
    private func setupUI(){
        setupRightBarButton()
    }
    
    //MARK: - Right Bar Button (Добавить)
    private func setupRightBarButton(){
        let button = UIButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        button.tintColor = .blueAction
        button.backgroundColor = .blueActionSecondary
        button.setTitleColor(.blueAction, for: .normal)
        button.setTitleColor(.blueActionHighlited, for: .highlighted)
        
        button.setTitle("Добавить", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)

        let image = UIImage(named: "plus")
        let highlightedImage = UIImage(named: "plusHighlighted")
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(addTaskButtonPreessed), for: .touchUpInside)
    }
    
    @objc private func addTaskButtonPreessed(){
        let task = try! Realm().objects(ToDoTask.self).last
        guard let vc = TaskEditControllerFabric.create(task: task, type: .edit) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

