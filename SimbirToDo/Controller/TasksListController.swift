
import UIKit
import SnapKit
import RealmSwift

class TasksListController: UIViewController {

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

    private func setup(){
        self.view.backgroundColor = .primaryContollerBackground
        self.navigationItem.title = "Задачи"

    }
    
    
    //
    //MARK: - UI
    //
    private func setupUI(){
        setupRightBarButton()
        setupMainScroll()
    }
    
    //
    //MARK: - Right Bar Button (Добавить)
    //
    private func setupRightBarButton(){
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
    
    //
    //MARK: - Tasks
    //
    private func setupMainScroll(){
        let mainScroll = UIScrollView()
        self.view.addSubview(mainScroll)
        
        mainScroll.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalToSuperview()
        }
        
        let v = DailyTaskView()
        mainScroll.addSubview(v)
        v.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(1500)
        }
    }
}

