import UIKit

class TaskEditTableView: UITableView{
    
    //MARK: Lifecycle
    convenience init(){
        self.init(frame: .zero, style: .grouped)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        self.dataSource = self
        self.allowsSelection = false
    }
    
}

//MARK: - Data source
extension TaskEditTableView: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 3
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section{
        case 0:
            guard let createdCell = TaskEditCellFabric.create(for: indexPath) else { fallthrough }
            cell = createdCell
        default: cell = UITableViewCell()
        }
        return cell
    }
    
}
