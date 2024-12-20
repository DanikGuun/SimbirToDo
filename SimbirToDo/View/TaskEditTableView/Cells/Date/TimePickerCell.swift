
import UIKit

class TimePickerCell: TaskEditCell, DateComponentsPickerProtocol{
    
    var delegate: (any DateComponentsPickerDelegate)?
    var minimumDate: Date = Date(timeIntervalSince1970: 0) { didSet { timePicker.minimumDate = minimumDate } }
    private var timePicker = UIDatePicker()
    
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        super.setupUI()
        setupTimePicker()
    }
    
    //
    //MARK: Time Picker
    //
    private func setupTimePicker() {
        self.contentView.addSubview(timePicker)
        
        timePicker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        
        timePicker.datePickerMode = .time
        if #available(iOS 14.0, *){
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.minimumDate = minimumDate
        timePicker.minuteInterval = 5
        timePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker){
        let comps = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        delegate?.dateComponentsPicker(self, didSelect: comps)
    }
    
    func setDate(_ date: Date) {
        self.timePicker.date = date
    }
    
}
