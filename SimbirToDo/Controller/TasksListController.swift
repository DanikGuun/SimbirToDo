
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
        
    }
    
}

//
//MARK: - UIScrollView Delegate
//
extension TasksListController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        if isScrollViewAnimating == false{
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

}
