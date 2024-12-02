
import UIKit

//Здесь не подписываемся под проткол, это просто чтобы каждый раз не писать иниты и сетап
//Подпись под протокол происходит в реализуемых ячейках
class TaskEditCell: UITableViewCell {
    
    convenience init(){
        self.init(style: .default, reuseIdentifier: nil)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI(){
        
    }
}
