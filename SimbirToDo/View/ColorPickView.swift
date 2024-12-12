
import UIKit

class ColorPickView: UIControl, CAAnimationDelegate {
    
    //Layers
    private var circleLayer = CAShapeLayer()
    private var strokeLayer = CAShapeLayer()
    
    //UI
    var color: UIColor = .systemBlue { didSet { circleLayer.fillColor = color.cgColor } }
    var strokeColor: UIColor = .gray { didSet { strokeLayer.strokeColor = strokeColor.cgColor } }
    var selectedInset: CGFloat = 5
    override var bounds: CGRect { didSet { updateBounds() } }
    override var isSelected: Bool { willSet {
        if isSelected != newValue{
            animCircleLayer(isSelected: newValue); animStrokeLayer(isSelected: newValue)
        }
    } }
    
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
        animCircleLayer(isSelected: isSelected)
    }
    
    private func animCircleLayer(isSelected: Bool){
        let sign: CGFloat = isSelected ? 1 : 0
        let path = CGPath(ellipseIn: self.bounds.insetBy(dx: selectedInset * sign, dy: selectedInset * sign).centerSquare, transform: nil)
            
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = circleLayer.path
        anim.toValue = path
        anim.duration = 0.25
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.delegate = self
        self.circleLayer.add(anim, forKey: "path")
        circleLayer.path = path
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

    }
    
    //MARK: - Setup Stroke Layer
    private func setupStrokeLayer(){
        
        self.layer.addSublayer(strokeLayer)
        strokeLayer.fillColor = nil
        strokeLayer.strokeColor = strokeColor.cgColor
        strokeLayer.lineWidth = 0
        animStrokeLayer(isSelected: isSelected)
        
    }
    
    private func animStrokeLayer(isSelected: Bool){
        
        let anim = CABasicAnimation(keyPath: "lineWidth")
        anim.fromValue = isSelected ? 0 : 3
        anim.toValue = isSelected ? 3 : 0
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.duration = 0.15
        anim.delegate = self
        strokeLayer.lineWidth = isSelected ? 3 : 0
        self.strokeLayer.add(anim, forKey: "lineWidth")
        
        
    }
    
    //
    //MARK: - Other
    //
    private func updateBounds(){
        var circleRect = self.bounds.centerSquare
        let strokeRect = self.bounds.insetBy(dx: 2, dy: 2).centerSquare
        
        
        if isSelected{
            circleRect = circleRect.insetBy(dx: selectedInset, dy: selectedInset)
        }
        
        circleLayer.path = CGPath(ellipseIn: circleRect, transform: nil)
        
        strokeLayer.path = CGPath(ellipseIn: strokeRect, transform: nil)
    }
    
}

private extension CGRect {
    var centerSquare: CGRect {
        let minEdge = min(width, height)
        return CGRect(x: self.midX - minEdge / 2, y: self.midY - minEdge / 2, width: minEdge, height: minEdge)
    }
}
