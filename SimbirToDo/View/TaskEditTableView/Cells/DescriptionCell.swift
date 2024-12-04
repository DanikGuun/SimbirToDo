
import UIKit
import SnapKit

class DescriptionCell: TaskEditCell{
    typealias InfoType = String
    
    var textView: PlaceholderTextView!
    
    override func setupUI() {
        super.setupUI()
        textView = PlaceholderTextView()
        self.contentView.addSubview(textView)
        
        textView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(4)
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.height.equalTo(UIScreen.main.bounds.height/4)
        }
        
        textView.placeholder = "Заметки..."
    }
    
    //MARK: - EditCell Protocol
    func setInfo(_ info: String) {
        textView.text = info
    }
    
    func getInfo() -> String {
        return textView.text!
    }
    
    
    
}
