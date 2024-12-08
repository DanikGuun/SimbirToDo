
import UIKit

class TaskInfoView: UIView{
    
    var leftLineWidth: CGFloat = 4 { didSet { self.setNeedsDisplay() } }
    var cornerRadius: CGFloat = 5 { didSet { self.setNeedsDisplay() } }
    
    override var tintColor: UIColor? { didSet { self.setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //Clip
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        clipPath.addClip()
        
        //Back
        self.tintColor?.withAlphaComponent(0.3).set()
        
        let backRectanglePath = UIBezierPath(rect: rect)
        backRectanglePath.fill()
        
        //Line
        self.tintColor?.set()
        
        let leftLineRect = CGRect(x: 0, y: 0, width: leftLineWidth, height: self.bounds.height)
        let leftLinePath = UIBezierPath(rect: leftLineRect)
        leftLinePath.fill()
        
    }
    
}
