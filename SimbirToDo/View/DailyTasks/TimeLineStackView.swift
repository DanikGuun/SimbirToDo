
import UIKit

class TimeLineStackView: UIStackView {
    
    let contentLayout = UILayoutGuide()

    //SupplementaryView
    var color: UIColor = .graySeparator { didSet { updateSuplimentaryViewsAppearance() } }
    var font = UIFont.systemFont(ofSize: 10, weight: .medium) { didSet { updateSuplimentaryViewsAppearance() } }
    
    var lineWidth: CGFloat = 2 { didSet { updateSuplimentaryViewsAppearance() } }
    var leftInset: CGFloat = 10 { didSet { updateSuplimentaryViewsAppearance() } }
    var rightInset: CGFloat = 0 { didSet { updateSuplimentaryViewsAppearance() } }
    var textToLineSpacing: CGFloat = 10 { didSet { updateSuplimentaryViewsAppearance() } }
    
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
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        self.axis = .vertical
        self.distribution = .fillEqually
        
        addLayoutGuide(contentLayout)
        setupSuplimentaryViews()
    }
    
    //
    //MARK: SuplimentaryViews
    //
    
    private func setupSuplimentaryViews(){

        var hours = Array(0..<24)
        hours.append(0)
        
        for hour in hours{
            let timeView = SupplementaryView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            timeView.text = "\(hour):00"
            timeView.backgroundColor = .clear
            self.addArrangedSubview(timeView)
        }
        
        contentLayout.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalTo(self)
        }
        updateSuplimentaryViewsAppearance()
    }
    
    private func updateSuplimentaryViewsAppearance(){
        
        var lastSubview = SupplementaryView()
        self.subviews.forEach {
            if let subview = $0 as? SupplementaryView {
                subview.color = self.color
                subview.leftInset = self.leftInset
                subview.rightInset = self.rightInset
                subview.textToLineSpacing = self.textToLineSpacing
                subview.font = self.font
                
                lastSubview = subview
            }
        }
        
        //обновляем layoutGuide
        contentLayout.snp.remakeConstraints { maker in
            maker.top.equalTo(self).offset(lastSubview.yOffset)
            maker.leading.equalTo(self).offset(lastSubview.xOffset)
            maker.trailing.equalTo(self).inset(lastSubview.rightInset)
            maker.bottom.equalTo(lastSubview.snp.top).offset(lastSubview.yOffset)
        }
        
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        self.subviews.forEach { $0.setNeedsDisplay() }
    }
}

private class SupplementaryView: UIView {
    
    var color: UIColor = .graySeparator { didSet { self.setNeedsDisplay() } }
    
    var lineWidth: CGFloat = 2 { didSet { self.setNeedsDisplay() } }
    var leftInset: CGFloat = 10 { didSet { self.setNeedsDisplay() } }
    var rightInset: CGFloat = 0 { didSet { self.setNeedsDisplay() } }
    var textToLineSpacing: CGFloat = 10 { didSet { self.setNeedsDisplay() } }
    
    var text: String? = "00:00" { didSet { self.setNeedsDisplay() } }
    var font = UIFont.systemFont(ofSize: 10, weight: .medium) { didSet { self.setNeedsDisplay() } }
    
    //отступ от верха до середины линии
    var yOffset: CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        return "00:00".size(withAttributes: attrs).height / 2
    }
    //отступ от лева до начала линии
    var xOffset: CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        return "00:00".size(withAttributes: attrs).width + leftInset + textToLineSpacing
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        color.set()
        
        //Text
        let text = self.text ?? ""
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let textSize = "00:00".size(withAttributes: attributes)
        let textRect = CGRect(x: leftInset, y: 0, width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: attributes)
        
        
        //Line
        let lineStart = CGPoint(x: textRect.maxX + textToLineSpacing, y: textRect.midY )
        let lineEnd = CGPoint(x: rect.width - rightInset, y: textRect.midY)
        
        let linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        linePath.move(to: lineStart)
        linePath.addLine(to: lineEnd)
        linePath.stroke()
        
        let leftRoundPath = UIBezierPath(arcCenter: lineStart, radius: lineWidth/2, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: true)
        leftRoundPath.fill()
        
        let rightRoundPath = UIBezierPath(arcCenter: lineEnd, radius: lineWidth/2, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: false)
        rightRoundPath.fill()
    }
}
