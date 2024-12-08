
import UIKit

class DailyTaskView: UIView, TasksPresenterProtocol {
    
    var delegate: (any TasksPresenterDelegate)?
    
    //UI
    private var mainStackView: TimeLineStackView!
    
    //Service
    private var pinchStartHeight: CGFloat = 0
    
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
        }
    }
    
    //
    //MARK: - UI
    //
    private func setupUI(){
        setupSupplementaryViews()
    }
    
    
    //MARK: SupplementaryView
    private func setupSupplementaryViews(){
        mainStackView = TimeLineStackView()
        self.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        let daySeconds: Double = 24*60*60
        let currentProp = 3600 * 1.5 / daySeconds
        
        let v = TaskInfoView()
        v.backgroundColor = .tertiaryFill
        addSubview(v)
        v.snp.makeConstraints({ maker in
            maker.leading.trailing.equalTo(mainStackView.contentLayout).inset(10)
            maker.top.equalTo(mainStackView.contentLayout)
            maker.height.equalToSuperview().multipliedBy(currentProp)
        })
        v.backgroundColor = .clear
        
    }
    
    //
    //MARK: - Tasks Presenter Protocol
    //
    
    func addTask(taskInfo: TaskInfo) {
        
    }
    
    func reloadData() {
        
    }
    
    func updateTask(taskInfo: TaskInfo) {
        
    }
    
    func removeTask(taskInfo: TaskInfo) {
        
    }
    
}
