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
        self.register(DatePickerCell.self, forCellReuseIdentifier: CellID.datePicker.rawValue)
        self.register(TimePickerCell.self, forCellReuseIdentifier: CellID.timePicker.rawValue)
        self.register(ColorPickerCell.self, forCellReuseIdentifier: CellID.colorPicker.rawValue)
        self.register(DescriptionCell.self, forCellReuseIdentifier: CellID.description.rawValue)
    }
    
    //
    //MARK: - Data source
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0, 2, 3: return 1
        case 1: return isPickerExpanded ? 2 : 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row){
            
        //Имя
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.name.rawValue, for: indexPath) as! NameCell
            infoCells[.name] = cell
            return cell
            
        //Дата
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.date.rawValue, for: indexPath) as! DateCell
            infoCells[.dateInterval] = cell
            cell.delegate = self
            return cell
        
        //Выбор даты
        case (1, 1):
            guard let id = currentDatePickerType?.cellID else { fallthrough }
            guard let currentDate = currentDate else { fallthrough }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? any DateComponentsPickerProtocol
            else { fallthrough }
            cell.delegate = self
            
            switch currentDatePickerType {
                
            case .endTime:
                cell.minimumDate = currentDate.start
                cell.setDate(currentDate.end)
                
            case .startTime, .date:
                cell.minimumDate = Date(timeIntervalSince1970: 0)
                cell.setDate(currentDate.start)
                
            default:
                break
            }
            return cell
            
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.colorPicker.rawValue, for: indexPath) as! ColorPickerCell
            infoCells[.color] = cell
            return cell
            
        //Описание
        case (3, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.description.rawValue, for: indexPath) as! DescriptionCell
            infoCells[.description] = cell
            return cell
        
        default:
            return UITableViewCell()
            
        }
    }
    
    //
    //MARK: - Service
    //
    
    //Обновляем ячйку с датой, при поступлении информации с пикера
    private func setDateFromPickerCell(_ dateComponents: DateComponents){
        let calendar = Calendar.current
        guard let dateCell = infoCells[.dateInterval] as? DateCell else { return }
        
        let currentInterval = dateCell.getInfo()
        var startComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentInterval.start)
        var endComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentInterval.end)
        
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
            
            //если новая дата больше, чем конечная, то выраваниваем
            let currentEndDateComps = calendar.dateComponents([.hour, .minute], from: currentInterval.end)
            if let currentEndDate = calendar.date(from: currentEndDateComps), let newEndDate = calendar.date(from: dateComponents){
                
                if newEndDate > currentEndDate{
                    //чтобы не было даты например 23:06 - 00:06
                    if dateComponents.hour ?? 0 >= 23, dateComponents.minute ?? 0 > 0 {
                        endComps.hour? = 23
                        endComps.minute? = 59
                    }
                    else{
                        endComps.hour = (dateComponents.hour ?? 0) + 1
                        endComps.minute = dateComponents.minute
                    }
                }
                
            }

        case .endTime:
            endComps.hour = dateComponents.hour
            endComps.minute = dateComponents.minute
        case nil:
            return
        }
        
        guard let newStartDate = calendar.date(from: startComps) else { return }
        guard let newEndDate = calendar.date(from: endComps) else { return }
        
        let newInterval = DateInterval(start: newStartDate, end: newEndDate)
        dateCell.setInfo(newInterval)
        
    }
    
    //
    //MARK: - Task Editer Protocol
    //
    
    func setInfo(_ info: TaskInfo) {
        
        let nameCell = infoCells[.name] as? NameCell
        let dateIntervalCell = infoCells[.dateInterval] as? DateCell
        let colorCell = infoCells[.color] as? ColorPickerCell
        let descriptionCell = infoCells[.description] as? DescriptionCell
        
        nameCell?.setInfo(info.name)
        descriptionCell?.setInfo(info.taskDescription)
        colorCell?.setInfo(info.color)
        dateIntervalCell?.setInfo(info.dateInterval)
        
    }
    
    func getInfo() -> TaskInfo? {
        
        guard let nameCell = infoCells[.name] as? NameCell,
              let colorCell = infoCells[.color] as? ColorPickerCell,
              let dateIntervalCell = infoCells[.dateInterval] as? DateCell,
                let descriptionCell = infoCells[.description] as? DescriptionCell
        else { return nil }
        
        let name = nameCell.getInfo()
        let dateInterval = dateIntervalCell.getInfo()
        let color = colorCell.getInfo()
        let description = descriptionCell.getInfo()
        
        return TaskInfo(name: name, taskDescription: description, dateInterval: dateInterval, color: color)
        
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
        
        self.endEditing(true)
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
    case colorPicker = "colorPicker"
    case description = "description"
}

//тип информации ячейки
private enum InfoType{
    case name
    case dateInterval
    case color
    case description
}


