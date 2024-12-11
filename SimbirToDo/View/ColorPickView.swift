
import UIKit

class ColorPickView: UIControl {
    
    //Layers
    private var circleLayer = CAShapeLayer()
    private var strokeLayer = CAShapeLayer()
    
    //UI
    var color: UIColor = .systemBlue { didSet { circleLayer.fillColor = color.cgColor } }
    var selectedInset: CGFloat = 5
    override var bounds: CGRect { didSet { updateBounds() } }
    override var isSelected: Bool { didSet { animCircleLayer(isSelected: isSelected); animStrokeLayer(isSelected: isSelected) } }
    
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
        setupCircleLayer()
        setupStrokeLayer()
    }
    
    //MARK: - Setup Circle Layer
    private func setupCircleLayer(){
        self.layer.addSublayer(circleLayer)
        circleLayer.fillColor = UIColor.systemBlue.cgColor
    }
    
    private func animCircleLayer(isSelected: Bool){
        let sign: CGFloat = isSelected ? 1 : 0
        
        let anim = CABasicAnimation(keyPath: "path")
        let path = CGPath(ellipseIn: self.bounds.insetBy(dx: selectedInset * sign, dy: selectedInset * sign), transform: nil)
        anim.fromValue = circleLayer.path
        anim.toValue = path
        anim.duration = 0.05
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.circleLayer.add(anim, forKey: "path")
        circleLayer.path = path
    }
    
    //MARK: - Setup Stroke Layer
    private func setupStrokeLayer(){
        
        self.layer.addSublayer(strokeLayer)
        strokeLayer.fillColor = nil
        strokeLayer.strokeColor = UIColor.systemPink.cgColor
        strokeLayer.lineWidth = 0
        
    }
    
    private func animStrokeLayer(isSelected: Bool){
        
        let anim = CABasicAnimation(keyPath: "lineWidth")
        anim.fromValue = strokeLayer.lineWidth
        anim.toValue = isSelected ? 3 : 0
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.duration = 0.1
        self.strokeLayer.add(anim, forKey: "lineWidth")
        
        strokeLayer.lineWidth = isSelected ? 3 : 0
    }
    
    //
    //MARK: - Other
    //
    private func updateBounds(){
        var circleRect = self.bounds
        var strokeRect = self.bounds.insetBy(dx: 2, dy: 2)
        
        if isSelected{
            circleRect = circleRect.insetBy(dx: selectedInset, dy: selectedInset)
            strokeRect = strokeRect.insetBy(dx: selectedInset, dy: selectedInset)
        }
        
        circleLayer.path = CGPath(ellipseIn: circleRect, transform: nil)
        
        strokeLayer.path = CGPath(ellipseIn: strokeRect, transform: nil)
    }
    
}
