
import UIKit

class DatePickerCell: TaskEditCell, DateComponentsPickerProtocol{
    
    var delegate: (any DateComponentsPickerDelegate)?
    var minimumDate: Date = Date(timeIntervalSince1970: 0)
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
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker){
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        delegate?.dateComponentsPicker(self, didSelect: comps)
    }
    
    func setDate(_ date: Date) {
        self.datePicker.date = date
    }
}
