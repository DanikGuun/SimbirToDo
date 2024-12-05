
protocol DateCellDelegate {
    func dateCell(showPickerOfType type: DatePickerType)
    func dateCell(hidePickerOfType type: DatePickerType)
}

extension DateCellDelegate{
    func dateCell(showPickerOfType type: DatePickerType){}
    func dateCell(hidePickerOfType type: DatePickerType){}
}

enum DatePickerType{
    case date
    case startTime
    case endTime
    
    var cellIdForCurrentType: String{
        switch self {
        case .date: return CellID.datePicker.rawValue
        case .startTime: return CellID.timePicker.rawValue
        case .endTime: return CellID.timePicker.rawValue
        }
    }
}
