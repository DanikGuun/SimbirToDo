
import UIKit
import SnapKit

class DateCell: TaskEditCell, TaskEditCellProtocol {
    typealias InfoType = DateInterval
    
    //UI
    private var dayButton: UIButton!
    private var startTimeButton: UIButton!
    private var endTimeButton: UIButton!
    
    //Service
    var delegate: DateCellDelegate?
    private var lastPickerType: DatePickerType?
    private var buttons: [UIButton] = [] //все кнопки, надо для выключения, если выбирается другая кнопка
    private var currentInterval: DateInterval = DateInterval()
    
    //
    //MARK: - UI
    //
    override func setupUI() {
        super.setupUI()
        setupDayButton()
        setupEndTimeButton()
        setupStartTimeButton()
    }
    
    //
    //MARK: Day Button
    //
    private func setupDayButton() {
        dayButton = UIButton()
        self.contentView.addSubview(dayButton)
        
        dayButton.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(6)
            maker.leading.equalToSuperview().inset(12)
            maker.height.equalTo(UIScreen.main.bounds.height/28)
        }
        
        dayButton.apply(.gray(selectedColor: .blueAction))
        dayButton.setTitle("01.01.1970", for: .normal)
        dayButton.addTarget(self, action: #selector(dayButtonPressed), for: .touchUpInside)
        dayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        buttons.append(dayButton)
    }
    
    @objc func dayButtonPressed(button: UIButton) {
        dateSelected(from: button, dateType: .date)
    }
    
    //
    //MARK: EndTime Button
    //
    private func setupEndTimeButton() {
        endTimeButton = UIButton()
        self.contentView.addSubview(endTimeButton)
        
        endTimeButton.snp.makeConstraints { maker in
            maker.top.height.equalTo(dayButton)
            maker.trailing.equalToSuperview().inset(12)
        }
        
        endTimeButton.apply(.gray(selectedColor: .blueAction))
        endTimeButton.setTitle("00:00", for: .normal)
        endTimeButton.addTarget(self, action: #selector(endTimeButtonPressed), for: .touchUpInside)
        endTimeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        buttons.append(endTimeButton)
    }
    
    @objc func endTimeButtonPressed(button: UIButton) {
        dateSelected(from: button, dateType: .endTime)
    }
    
    //
    //MARK: StartTime Button
    //
    private func setupStartTimeButton() {
        startTimeButton = UIButton()
        self.contentView.addSubview(startTimeButton)
        
        startTimeButton.snp.makeConstraints { maker in
            maker.top.height.equalTo(dayButton)
            maker.trailing.equalTo(endTimeButton.snp.leading).offset(-12)
        }
        
        startTimeButton.apply(.gray(selectedColor: .blueAction))
        startTimeButton.setTitle("00:00", for: .normal)
        startTimeButton.addTarget(self, action: #selector(startTimeButtonPressed), for: .touchUpInside)
        startTimeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        buttons.append(startTimeButton)
    }
    
    @objc func startTimeButtonPressed(button: UIButton) {
        dateSelected(from: button, dateType: .startTime)
    }
    
    //
    //MARK: - Service
    //
    private func dateSelected(from button: UIButton, dateType: DatePickerType){
        button.isSelected.toggle()
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
    
    //
    //MARK: - EditCell Protocol
    //
    func setInfo(_ info: DateInterval) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: info.start)
        
        formatter.dateFormat = ""
        formatter.timeStyle = .short
        let startTime = formatter.string(from: info.start)
        let endTime = formatter.string(from: info.end)
        
        dayButton.setTitle(date, for: .normal)
        startTimeButton.setTitle(startTime, for: .normal)
        endTimeButton.setTitle(endTime, for: .normal)
        
        currentInterval = info
    }
    
    func getInfo() -> DateInterval {
        return currentInterval
    }
    
}
