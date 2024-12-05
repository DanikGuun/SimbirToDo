import UIKit
import RealmSwift

class TaskEditTableView: UITableView, UITableViewDataSource, TaskEditerProtocol{

    //Cells
    private var infoCells: Dictionary<InfoType, (any TaskEditCellProtocol)?> = [:]
    private var isPickerExpanded: Bool = false
    private var currentDatePickerType: DatePickerType? = nil //текущий тип выбора даты, к нему подвязан выбор id ячейки с выбором
    
    //Service
    var initialInfo: TaskInfo? //для задания начальных значений для ячеек
    var isInitialLayout = true //для того, чтобы задать значения ячейкам при первом ините
    var taskDelegate: (any TaskEditerDelegate)?
    var currentDate: DateInterval? { //минимальное время для пикера. Чтобы конец не был раньше начала
        guard let dateCell = infoCells[.dateInterval] as? DateCell else { return nil }
        return dateCell.getInfo()
    }
    
    //
    //MARK: Lifecycle
    //
    convenience init(){
        self.init(frame: .zero, style: .grouped)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isInitialLayout, let initialInfo{
            self.setInfo(initialInfo)
            isInitialLayout = false
        }
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
        self.keyboardDismissMode = .onDrag
        self.estimatedRowHeight = 40
        self.delaysContentTouches = false
        
        self.register(NameCell.self, forCellReuseIdentifier: CellID.name.rawValue)
        self.register(DateCell.self, forCellReuseIdentifier: CellID.date.rawValue)
        self.register(DescriptionCell.self, forCellReuseIdentifier: CellID.description.rawValue)
        self.register(TimePickerCell.self, forCellReuseIdentifier: CellID.timePicker.rawValue)
        self.register(DatePickerCell.self, forCellReuseIdentifier: CellID.datePicker.rawValue)
    }
    
    //
    //MARK: - Data source
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0, 2: return 1
        case 1: return isPickerExpanded ? 2 : 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row){
            
        //Имя
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.name.rawValue, for: indexPath) as! NameCell
            infoCells[.name, default: nil] = cell
            return cell
            
        //Дата
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.date.rawValue, for: indexPath) as! DateCell
            infoCells[.dateInterval, default: nil] = cell
            cell.delegate = self
            return cell
        
        //Описание, если свернут/нет выбор даты
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.description.rawValue, for: indexPath) as! DescriptionCell
            infoCells[.description, default: nil] = cell
            return cell
        
        //Выбор даты
        case (1, 1):
            guard let id = currentDatePickerType?.cellID else { fallthrough }
            guard let currentDate = currentDate else { fallthrough }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? any DateComponentsPickerProtocol
            else { fallthrough }
            
            switch currentDatePickerType {
            case .endTime:
                cell.minimumDate = currentDate.start
                cell.setDate(currentDate.end)
            case .startTime, .date:
                cell.setDate(currentDate.start)
            default:
                break
            }
            cell.delegate = self
            
            
            
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
            let endDate = Calendar.current.dateComponents([.hour, .minute], from: currentInterval.end)
            if let newDate = Calendar.current.date(from: dateComponents), let newEndDate = Calendar.current.date(from: endDate){
                if newDate > newEndDate{
                    endComps.hour = dateComponents.hour
                    endComps.minute = dateComponents.minute
                }
            }

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
    
    //
    //MARK: - Task Editer Protocol
    //
    
    func setInfo(_ info: TaskInfo) {
        
        let nameCell = infoCells[.name] as? NameCell
        let description = infoCells[.description] as? DescriptionCell
        let dateInterval = infoCells[.dateInterval] as? DateCell
        
        nameCell?.setInfo(info.name)
        description?.setInfo(info.taskDescription)
        dateInterval?.setInfo(info.dateInterval)
        
    }
    
    func getInfo() -> TaskInfo? {
        
        guard let nameCell = infoCells[.name] as? NameCell,
        let descriptionCell = infoCells[.description] as? DescriptionCell,
        let dateIntervalCell = infoCells[.dateInterval] as? DateCell
        else { return nil }
        
        let name = nameCell.getInfo()
        let description = descriptionCell.getInfo()
        let dateInterval = dateIntervalCell.getInfo()
        
        return TaskInfo(name: name, description: description, dateInterval: dateInterval)
        
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
        self.insertRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
        self.endUpdates()
        
    }
    
    func dateCell(hidePickerOfType type: DatePickerType) {
        isPickerExpanded = false
        self.currentDatePickerType = nil
        
        self.beginUpdates()
        self.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
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


