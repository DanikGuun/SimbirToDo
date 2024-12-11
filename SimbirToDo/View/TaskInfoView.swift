
import UIKit

class TaskInfoView: UIControl {
    
    //UI
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    
    //Design
    var leftLineWidth: CGFloat = 4 { didSet { self.setNeedsDisplay() } }
    var cornerRadius: CGFloat = 5 { didSet { self.setNeedsDisplay() } }
    override var isSelected: Bool{ didSet { backgroundAlpha = isSelected ? 0.8 : 0.3 } }
    private var backgroundAlpha: CGFloat = 0.3 { didSet { self.setNeedsDisplay() } }
    
    //Service
    var title: String? { didSet { self.titleLabel?.text = title } }
    var time: String? { didSet { self.timeLabel?.text = time } }
    var id: UUID?
    
    override var tintColor: UIColor? { didSet { self.setNeedsDisplay() } }
    
    
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
        isSelected = false
    }
    
    //
    //MARK: - UI
    //
    private func setupUI(){
        setupTitleLabel()
    }
    
    //MARK: TitleLabel
    private func setupTitleLabel(){
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(2)
            maker.leading.equalToSuperview().inset(leftLineWidth + 5)
            maker.trailing.equalToSuperview()
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .opagueText
        
    }
    
    
    //
    //MARK: Draw
    //
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //Clip
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        clipPath.addClip()
        
        //Back
        self.tintColor?.withAlphaComponent(backgroundAlpha).set()
        
        let backRectanglePath = UIBezierPath(rect: rect)
        backRectanglePath.fill()
        
        //Line
        self.tintColor?.set()
        
        let leftLineRect = CGRect(x: 0, y: 0, width: leftLineWidth, height: self.bounds.height)
        let leftLinePath = UIBezierPath(rect: leftLineRect)
        leftLinePath.fill()
        
    }
    
}
