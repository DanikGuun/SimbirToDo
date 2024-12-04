
import UIKit

class TimePickerCell: TaskEditCell, DateComponentsPickerProtocol {
    
    var delegate: (any DateComponentsPickerDelegate)?
    private var timePicker: UIDatePicker!
    
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
        timePicker = UIDatePicker()
        self.contentView.addSubview(timePicker)
        
        timePicker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        timePicker.datePickerMode = .time
        if #available(iOS 14.0, *){
            timePicker.preferredDatePickerStyle = .wheels
        }
    }
    
}
