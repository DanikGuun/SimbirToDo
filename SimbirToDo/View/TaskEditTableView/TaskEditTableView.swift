import UIKit
import RealmSwift

class TaskEditTableView: UITableView, UITableViewDataSource{

    //Cells
    private var infoCells: Dictionary<InfoType, (any TaskEditCellProtocol)?> = [:]
    private var isPickerExpanded: Bool = false
    private var currentDatePickerType: DatePickerType? = nil //текущий тип выбора даты, к нему подвязан выбор id ячейки с выбором
    
    let realm = try! Realm()
    var task: ToDoTask{
        let objects = realm.objects(ToDoTask.self)
        return objects.first!
    }
    
    //
    //MARK: Lifecycle
    //
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
        self.register(NameCell.self, forCellReuseIdentifier: CellID.name.rawValue)
        self.register(DateCell.self, forCellReuseIdentifier: CellID.date.rawValue)
        self.register(DescriptionCell.self, forCellReuseIdentifier: CellID.description.rawValue)
        self.register(TimePickerCell.self, forCellReuseIdentifier: CellID.timePicker.rawValue)
        self.register(DatePickerCell.self, forCellReuseIdentifier: CellID.datePicker.rawValue)
        self.register(ApplyCell.self, forCellReuseIdentifier: CellID.applyButotn.rawValue)
    }
    
    //
    //MARK: - Data source
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return isPickerExpanded ? 4 : 3
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row){
            
        //Имя
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.name.rawValue, for: indexPath) as! NameCell
            cell.setInfo(task.title)
            infoCells[.name, default: nil] = cell as? any TaskEditCellProtocol
            return cell
            
        //Дата
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.date.rawValue, for: indexPath) as! DateCell
            cell.delegate = self
            infoCells[.dateInterval, default: nil] = cell as any TaskEditCellProtocol
            cell.setInfo(DateInterval(start: Date(timeIntervalSince1970: task.dateStart), end: Date(timeIntervalSince1970: task.dateEnd)))
            return cell
        
        //Описание, если свернут/нет выбор даты
        case (0, 2) where isPickerExpanded == false, (0, 3) where isPickerExpanded == true:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.description.rawValue, for: indexPath)
            infoCells[.description, default: nil] = cell as? any TaskEditCellProtocol
            return cell
        
        //Выбор даты
        case (0, 2) where isPickerExpanded == true:
            guard let id = currentDatePickerType?.cellIdForCurrentType else { fallthrough }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? any DateComponentsPickerProtocol
            else { fallthrough }
            
            cell.delegate = self
            
            return cell
            
        //кнопка
        case (1, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.applyButotn.rawValue, for: indexPath) as? ApplyCell
            else { fallthrough }
            return cell
        default:
            return UITableViewCell()
            
        }
    }
    
    //
    //MARK: - Service
    //
    
    private func setDateFromPickerCell(_ dateComponents: DateComponents){
        guard let dateCell = infoCells[.dateInterval] as? DateCell else { return }
        
        let currentInterval = dateCell.getInfo()
        var startComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: currentInterval.start)
        var endComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: currentInterval.end)
        
        switch currentDatePickerType {
            
        case .date:
            startComps.year = dateComponents.year
            startComps.month = dateComponents.month
            startComps.day = dateComponents.day
            endComps.year = dateComponents.year
            endComps.month = dateComponents.month
            endComps.day = dateComponents.day
        case .startTime:
            startComps.hour = dateComponents.hour
            startComps.minute = dateComponents.minute
        case .endTime:
            endComps.hour = dateComponents.hour
            endComps.minute = dateComponents.minute
        case nil:
            return
        }
        
        guard let newStartDate = Calendar.current.date(from: startComps) else { return }
        guard let newEndDate = Calendar.current.date(from: endComps) else { return }
        
        let newInterval = DateInterval(start: newStartDate, end: newEndDate)
        dateCell.setInfo(newInterval)
        
    }
}

//
//MARK: - DateCell Delegate
//
extension TaskEditTableView: DateCellDelegate{
    
    func dateCell(showPickerOfType type: DatePickerType) {
        isPickerExpanded = true
        self.currentDatePickerType = type
        
        self.beginUpdates()
        self.insertRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
        self.endUpdates()
        
    }
    
    func dateCell(hidePickerOfType type: DatePickerType) {
        isPickerExpanded = false
        self.currentDatePickerType = nil
        
        self.beginUpdates()
        self.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
        self.endUpdates()
        
    }
    
}

//
//MARK: - DateComponents Picker Delegate
//
extension TaskEditTableView: DateComponentsPickerDelegate{
    
    func dateComponentsPicker(_ picker: DateComponentsPickerProtocol, didSelect dateComponents: DateComponents) {
        self.setDateFromPickerCell(dateComponents)
    }
    
}

//
//MARK: - Enums
//

//Reuse id ячеек
enum CellID: String{
    case name = "name"
    case date = "date"
    case datePicker = "datePicker"
    case timePicker = "timePicker"
    case description = "description"
    case applyButotn = "applyButton"
}

//тип информации ячейки
private enum InfoType{
    case name
    case dateInterval
    case description
}


