
import UIKit
import SnapKit

class TasksListController: UIViewController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup(){
        
        self.view.backgroundColor = .primaryContollerBackground
        self.navigationItem.title = "Задачи"
        
        setupUI()
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
        
    }
}

