
import UIKit

class DatePickerCell: TaskEditCell, DateComponentsPickerProtocol{
    
    var delegate: (any DateComponentsPickerDelegate)?
    private var datePicker: UIDatePicker!
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        super.setupUI()
        setupDatePicker()
    }
    
    //
    //MARK: DatePicker
    //
    private func setupDatePicker(){
        datePicker = UIDatePicker()
        self.contentView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
    }
}
