
import UIKit
import SnapKit

class DateCell: TaskEditCell, TaskEditCellProtocol {
    
    typealias InfoType = DateInterval
    
    //UI
    private var dayButton: Button!
    private var startTimeButton: Button!
    private var endTimeButton: Button!
    
    //Service
    var delegate: DateCellDelegate?
    private var lastPickerType: DatePickerType?
    private var buttons: [UIButton] = [] //все кнопки, надо для выключения, если выбирается другая кнопка
    private var currentInterval: InfoType = DateInterval()
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        super.setupUI()
        setupDayButton()
        setupEndTimeButton()
        setupStartTimeButton()
        
        setInfo(DateInterval(start: Date(), duration: 3600))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //
    //MARK: Day Button
    //
    private func setupDayButton() {
        dayButton = Button()
        self.contentView.addSubview(dayButton)
        
        dayButton.snp.makeConstraints { maker in
            maker.top.bottom.leading.equalToSuperview().inset(5)
            maker.height.equalTo(UIScreen.main.bounds.height/28)
        }
        
        dayButton.apply(.gray(selectedColor: .systemBlue))
        dayButton.isSelectionPrimaryAction = true
        dayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        dayButton.action = { [weak self] button in
            self?.dayButtonPressed(button: button)
        }
        
        buttons.append(dayButton)
    }
    
    func dayButtonPressed(button: UIButton) {
        datePickerSelected(from: button, dateType: .date)
    }
    
    //
    //MARK: EndTime Button
    //
    private func setupEndTimeButton() {
        endTimeButton = Button()
        self.contentView.addSubview(endTimeButton)
        
        endTimeButton.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(dayButton)
            maker.trailing.equalToSuperview().inset(5)
        }
        
        endTimeButton.apply(.gray(selectedColor: .systemBlue))
        endTimeButton.isSelectionPrimaryAction = true
        endTimeButton.setTitle("00:00", for: .normal)
        endTimeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        endTimeButton.action = { [weak self] button in
            self?.endTimeButtonPressed(button: button)
        }
        
        buttons.append(endTimeButton)
    }
    
    func endTimeButtonPressed(button: UIButton) {
        datePickerSelected(from: button, dateType: .endTime)
    }
    
    //
    //MARK: StartTime Button
    //
    private func setupStartTimeButton() {
        startTimeButton = Button()
        self.contentView.addSubview(startTimeButton)
        
        startTimeButton.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(dayButton)
            maker.trailing.equalTo(endTimeButton.snp.leading).offset(-5)
        }
        
        startTimeButton.apply(.gray(selectedColor: .systemBlue))
        startTimeButton.isSelectionPrimaryAction = true
        startTimeButton.setTitle("00:00", for: .normal)
        startTimeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        startTimeButton.action = { [weak self] button in
            self?.startTimeButtonPressed(button: button)
        }
        
        buttons.append(startTimeButton)
    }
    
    func startTimeButtonPressed(button: UIButton) {
        datePickerSelected(from: button, dateType: .startTime)
    }
    
    //
    //MARK: - Service
    //
    private func datePickerSelected(from button: UIButton, dateType: DatePickerType){
        if button.isSelected {
            buttons.forEach { $0.isSelected = $0 == button } //выключаем остальные
            if let lastPickerType { delegate?.dateCell(hidePickerOfType: lastPickerType) }
            delegate?.dateCell(showPickerOfType: dateType)
            lastPickerType = dateType
        }
        else {
            lastPickerType = nil
            delegate?.dateCell(hidePickerOfType: dateType)
        }
    }
    
    @objc private func keyboardWillShow(){
        buttons.forEach { $0.isSelected = false }
    
        if let lastPickerType{
            delegate?.dateCell(hidePickerOfType: lastPickerType)
            self.lastPickerType = nil
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //
    //MARK: - EditCell Protocol
    //
    func setInfo(_ info: DateInterval) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let date = formatter.string(from: info.start)
        dayButton.setTitle(date, for: .normal)
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        //округляем до 5 минут путем вычитания остатка от 300 секунд
        let roundedStart = info.start.addingTimeInterval(-info.start.timeIntervalSince1970.truncatingRemainder(dividingBy: 300))
        let startTime = formatter.string(from: roundedStart)
        
        let roundedEnd = info.end.addingTimeInterval(-info.end.timeIntervalSince1970.truncatingRemainder(dividingBy: 300))
        let endTime = formatter.string(from: roundedEnd)
        
        startTimeButton.setTitle(startTime, for: .normal)
        endTimeButton.setTitle(endTime, for: .normal)
        
        currentInterval = DateInterval(start: roundedStart, end: roundedEnd)
    }
    
    func getInfo() -> DateInterval {
        return currentInterval
    }

}
