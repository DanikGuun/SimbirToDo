
import UIKit

class TaskEditContoller: UIViewController {
    
    //Behaviors
    var taskProcessBehavior: TaskProcessBehavior?
    var deletionBehavior: DeletionBehavior? { didSet { deletionBehaviorChanged() } }
    
    //UI
    private var applyBarItem: UIBarButtonItem!
    private var deleteBarItem: UIBarButtonItem!
    private var backButton: UIButton!
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
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    //
    //MARK: - UI
    //
    func setupUI() {
        setupApplyButton()
        setupDeleteBarItem()
        setupBackButton()
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
        self.navigationController?.popViewController(animated: true)
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
        
        let accept: (() -> Void) = { [weak self] in
            self?.deletionBehavior?.delete()
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.confirmAlert(title: "Вы уверены, что хотите удалить задачу?", accept: accept)
    }
    
    //
    //MARK: - Back Button
    //
    private func setupBackButton(){
        
        backButton = Button()
        backButton.setTitle("Назад", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.setImage(UIImage(named: "chevronLeft"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        backButton.adjustsImageWhenHighlighted = false
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    @objc private func backButtonPressed(_ button: UIButton){

        let accept: (() -> Void) = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            button.setTitleColor(.systemBlue, for: .normal)
        }
        
        self.confirmAlert(title: "Вы уверены, что хотите Выйти?", message: "Изменения не сохранятся", accept: accept)
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
