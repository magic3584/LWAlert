//
//  LWAlert.swift
//  LWAlert
//
//  Created by wang on 14/12/2017.
//  Copyright © 2017 wang. All rights reserved.
//

import Foundation
import UIKit

public enum LWAlertStyle {
    case hud
    case alert
    case datePicker
    case timePicker
    case systemDatePicker
    case everyThirtyIn24Hours//0:00 0:30 1:00 1:30
    case customPicker
}

public typealias LWDateInfo = (date: String?, time: String?)

class LWDateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    class func is12HoursFormat() -> Bool {
        let dateString : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        
        if(dateString.contains("a")){
            // 12 h format
            return true
        }else{
            // 24 h format
            return false
        }
    }
    
}

open class LWAlertButton: UIView {
    var button: UIButton!
    var handler: ((LWAlertButton) -> ())?
    weak var alert:LWAlert!
    
    public init(title: String?, handler:((LWAlertButton) -> ())? = nil) {
        super.init(frame: .zero)
        
        self.handler = handler
        
        button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.rgbColor(r: 241, g: 241, b: 241)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(LWAlertButton.buttonAction), for: .touchUpInside)
        
        addSubview(button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("LWAlertButton deinit")
    }
    
    fileprivate func updateFrame(frame: CGRect) {
        self.frame = frame
        button.frame = self.bounds
    }
    
    @objc private func buttonAction() {
        handler?(self)
        alert.dismiss()
    }
}

open class LWAlert: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var bgView: UIView!
    var realView: UIView!
    var style: LWAlertStyle!
    
    var buttons = [LWAlertButton]()
    
    var pickerBgView: UIView?
    var pickerView: UIPickerView?
    var picker: UIDatePicker?
    
    var customData: [[String]]?
    //space between labels
    let space:CGFloat = 20
    //label margin
    let margin: CGFloat = 6
    
    var showDuration: TimeInterval = 2.0

    static let startDate = LWDateFormatter.dateFormatter.date(from: "2000-01-01")!
    static let endDate = LWDateFormatter.dateFormatter.date(from: "2100-01-01")!
    static var timeDataSource: [[String]] {
        var array = [[String]]()
        array.append(["上午", "下午"])
            
        var hours = [String]()
        for hour in 1...12 {
            hours.append(String(format:"%d", hour))
        }
        array.append(hours)
        
        var minutes = [String]()
        for minute in 0...59 {
            minutes.append(String(format:"%02d", minute))
        }
        array.append(minutes)
        
        return array
    }
    
    public var dateInfo: LWDateInfo?
    public var dateInfoBlock: ((LWDateInfo) ->())?
    
    ///When using systemDatePicker
    public var minDate: Date? {
        didSet {
            if self.style == .systemDatePicker {
                picker?.minimumDate = minDate
                if Date() < minDate! {
                    dateInfo = minDate!.systemDateInfo()
                }
            }
        }
    }
    ///When using systemDatePicker
    public var maxDate: Date? {
        didSet {
            if self.style == .systemDatePicker {
                picker?.maximumDate = maxDate
                if Date() > maxDate! {
                    dateInfo = maxDate!.systemDateInfo()
                }
            }
        }
    }
    
    ///joined by "-"
    public var customPickerString: String?
    public var customPickerBlock: ((String) ->())?
    
    let lineColor = UIColor.rgbColor(r: 204, g: 204, b: 204)
    let bgColor = UIColor.rgbColor(r: 10, g: 2, b: 4, a: 0.4)
    
    let viewWidth = UIScreen.main.bounds.width
    let viewHeight = UIScreen.main.bounds.height
    let buttonHeight: CGFloat = 50
    let pickerHeight: CGFloat = 216
    
    deinit {
        print("deinit")
    }
    
    //MARK: - Init
    
    ///Init with style: hud, buttons
    public init(title: String?, message: String?, style: LWAlertStyle) {
        super.init(frame: UIScreen.main.bounds)
        
        self.style = style
        
        bgView = UIView.init(frame: UIScreen.main.bounds)
        addSubview(bgView)
        
        realView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewWidth * 0.8, height: 200))
        realView.backgroundColor = UIColor.white
        realView.layer.cornerRadius = 10.0
        realView.layer.backgroundColor = UIColor.white.cgColor
        realView.clipsToBounds = true
        
        var height: CGFloat = space
        
        if title != nil {
            let label = UILabel()
            label.text = title!
            label.textColor = UIColor.rgbColor(r: 77, g: 77, b: 77)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            let size = label.sizeThatFits(CGSize(width: realView.frame.size.width - margin * 2, height: CGFloat.greatestFiniteMagnitude))
            label.frame = CGRect(x: margin, y: space, width: realView.frame.size.width - margin * 2, height: size.height)
            realView.addSubview(label)
            height += label.frame.size.height
            height += space
        }
        
        if message != nil {
            let label = UILabel()
            label.text = message!
            label.textColor = UIColor.rgbColor(r: 128, g: 128, b: 128)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            
            label.font = UIFont.systemFont(ofSize: 11)
            let size = label.sizeThatFits(CGSize(width: realView.frame.size.width - margin * 2, height: CGFloat.greatestFiniteMagnitude))
            label.frame = CGRect(x: margin, y: height, width: realView.frame.size.width - margin * 2, height: size.height)
            realView.addSubview(label)
            height += label.frame.size.height
            height += space
        }
        
        realView.frame.size.height = height

        addSubview(realView)
        realView.center = center
    }
    
    ///Init with style: picker
    public init(style: LWAlertStyle) {
        super.init(frame: UIScreen.main.bounds)
        
        self.style = style
        
        bgView = UIView.init(frame: UIScreen.main.bounds)
        
        let buttonWidth: CGFloat = 100

        pickerBgView = UIView.init(frame: CGRect(x: 0, y: viewHeight, width: viewWidth, height: buttonHeight + pickerHeight))
        pickerBgView?.backgroundColor = UIColor.white
        
        let buttonView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: buttonHeight))
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.tag = 0
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(LWAlert.pickerButtonAction(button:)), for: .touchUpInside)
        buttonView.addSubview(cancelButton)
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.tag = 1
        confirmButton.frame = CGRect(x: viewWidth - buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.green, for: .normal)
        confirmButton.addTarget(self, action: #selector(LWAlert.pickerButtonAction(button:)), for: .touchUpInside)
        buttonView.addSubview(confirmButton)
        buttonView.addLine(at: .bottom)
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        dateInfo = Date().dateInfo()
        
        switch style {
        case .systemDatePicker, .everyThirtyIn24Hours:
            picker = UIDatePicker.init(frame: CGRect(x: 0, y: buttonHeight, width: viewWidth, height: pickerHeight))
            switch style {
            case .systemDatePicker:
                picker?.datePickerMode = .date
                dateInfo = Date().systemDateInfo()

            case .everyThirtyIn24Hours:
                picker?.datePickerMode = .time
                picker?.minuteInterval = 30
                dateInfo = Date().everyThirtyIn24HoursDateInfo()
                
            default:
                break
            }
            
            picker?.addTarget(self, action: #selector(LWAlert.systemPickerValueChanged), for: .valueChanged)
            pickerBgView?.addSubview(picker!)
            
        case .datePicker, .timePicker:
            
            pickerView = UIPickerView.init(frame: CGRect(x: 0, y: buttonHeight, width: viewWidth, height: pickerHeight))
            pickerView?.dataSource = self
            pickerView?.delegate = self
            
            switch style {
            case .datePicker:
                pickerView?.selectRow(Calendar.current.dateComponents([.day], from: LWAlert.startDate, to: Date()).day!, inComponent: 0, animated: false)
            case .timePicker:
                
                let amOrPm = components.hour! / 12
                
                pickerView?.selectRow(amOrPm, inComponent: 0, animated: false)
                if components.hour! % 12 == 0 {
                    pickerView?.selectRow(11, inComponent: 1, animated: false)
                } else {
                    pickerView?.selectRow((components.hour! % 12 - 1), inComponent: 1, animated: false)
                }
                pickerView?.selectRow(components.minute!, inComponent: 2, animated: false)
                
            default:
                break
            }
            
            pickerBgView?.addSubview(pickerView!)
            
        default:
            break
        }
        
        pickerBgView?.addSubview(buttonView)

        addSubview(bgView)
        addSubview(pickerBgView!)
    }
    
    ///Init with style custom picker, can be set with dafaultStrings
    public init(customData: [[String]], defaultStrings: [String]? = nil) {
        super.init(frame: UIScreen.main.bounds)
        
        self.style = .customPicker
        self.customData = customData
        
        
        bgView = UIView.init(frame: UIScreen.main.bounds)
        
        let buttonWidth: CGFloat = 100
        
        pickerBgView = UIView.init(frame: CGRect(x: 0, y: viewHeight, width: viewWidth, height: buttonHeight + pickerHeight))
        pickerBgView?.backgroundColor = UIColor.white
        
        let buttonView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: buttonHeight))
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.tag = 0
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.lightGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(LWAlert.pickerButtonAction(button:)), for: .touchUpInside)
        buttonView.addSubview(cancelButton)
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.tag = 1
        confirmButton.frame = CGRect(x: viewWidth - buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.green, for: .normal)
        confirmButton.addTarget(self, action: #selector(LWAlert.pickerButtonAction(button:)), for: .touchUpInside)
        buttonView.addSubview(confirmButton)
        buttonView.addLine(at: .bottom)
        
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: buttonHeight, width: viewWidth, height: pickerHeight))
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        pickerView?.selectRow(0, inComponent: 0, animated: false)
        
        var stringArray = [String]()
        for (components,strings) in customData.enumerated() {
            var row = 0
            
            if defaultStrings != nil {
                assert(defaultStrings!.count == customData.count, "DefaultStrings's count must equal to customData's count")
                if let defaultIndex = strings.index(of: defaultStrings![components]) {
                   row = defaultIndex
                }
            }
            pickerView?.selectRow(row, inComponent: components, animated: false)
            stringArray.append(strings[row])
        }
        customPickerString = stringArray.joined(separator: "-")
        
        pickerBgView?.addSubview(pickerView!)
        pickerBgView?.addSubview(buttonView)
        
        addSubview(bgView)
        addSubview(pickerBgView!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func showHUD(title: String?, message: String?) {
        let alert = LWAlert.init(title: title, message: message, style: .hud)
        alert.show()
    }
    
    public func addButton(_ button: LWAlertButton) {
        buttons.append(button)
        button.alert = self
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)

        switch style!{
        case .hud:
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.backgroundColor = self.bgColor
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + self.showDuration, execute: {
                    self.removeFromSuperview()

                })
            })
        case .alert:
            guard buttons.count > 0 else { return }
            
            bgView.backgroundColor = self.bgColor

            let buttonHeight: CGFloat = 37.5
            let buttonWidth = realView.frame.size.width / CGFloat(buttons.count)
            
            let buttonView = UIView.init(frame: CGRect(x: 0, y: realView.frame.size.height, width: realView.frame.size.width, height: buttonHeight))
            
            for (index, button) in buttons.enumerated() {
                button.updateFrame(frame: CGRect(x: buttonWidth * CGFloat(index), y: 0, width: buttonWidth, height: buttonHeight))
                buttonView.addSubview(button)
                
                if index == 0 {
                    button.button.setTitleColor(UIColor.rgbColor(r: 71, g: 71, b: 71), for: .normal)
                } else {
                    button.button.setTitleColor(UIColor.rgbColor(r: 237, g: 119, b: 30), for: .normal)
                }
                
                //line between buttons
                if index != 0 {
                    let line = UIView.init(frame: CGRect(x: button.frame.origin.x, y: 0, width: 1, height: buttonHeight))
                    line.backgroundColor = lineColor
                    buttonView.addSubview(line)
                }
            }
            
            //top line
            buttonView.addLine(at: .top)
            
            realView.addSubview(buttonView)
        
            realView.frame.size.height += buttonHeight
            realView.center = center
        
        case .datePicker, .timePicker, .systemDatePicker, .everyThirtyIn24Hours, .customPicker:
            var frame = pickerBgView!.frame
            frame.origin.y = self.viewHeight - self.buttonHeight - self.pickerHeight

            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.backgroundColor = self.bgColor
                self.pickerBgView?.frame = frame
            }, completion: nil)
            
            
            
        default:
            break
        }
    }
    
    @objc func systemPickerValueChanged() {
        if style == .systemDatePicker {
            dateInfo?.date = LWDateFormatter.dateFormatter.string(from: picker!.date)
        } else if style == .everyThirtyIn24Hours {
            dateInfo?.time = LWDateFormatter.timeFormatter.string(from: picker!.date)
        }
    }
    
    //MARK: - UIPickerView
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch style! {
        case .timePicker:
            return LWAlert.timeDataSource.count
            
        case .datePicker:
            return 1
            
        case .customPicker:
            return customData!.count
            
        default:
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        switch style! {
        case .timePicker:
            return LWAlert.timeDataSource[component].count
            
        case .datePicker:
            let components = Calendar.current.dateComponents([.day], from: LWAlert.startDate, to: LWAlert.endDate)
            return components.day!
            
        case .customPicker:
            return customData![component].count
            
        default:
            return 0
        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch style! {
        case .timePicker:
            return LWAlert.timeDataSource[component][row]
            
        case .datePicker:
            let date = LWAlert.startDate.addingTimeInterval(TimeInterval(3600 * 24 * row))
            return date.dateInfo().date
            
        case .customPicker:
            return customData![component][row]
            
        default:
            return nil
        }
        
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch style! {
        case .timePicker:
            var hour = 0
            if pickerView.selectedRow(inComponent: 0) != 0 { hour += 12}
            hour += (pickerView.selectedRow(inComponent: 1) + 1)
            let minute = pickerView.selectedRow(inComponent: 2)
            dateInfo?.time = String(format:"%d:%02d", hour, minute)
            
        case .datePicker:
            let date = LWAlert.startDate.addingTimeInterval(TimeInterval(3600 * 24 * row))
            dateInfo = date.dateInfo()
            
        case .customPicker:
            var stringArray = [String]()
            for index in 0..<customData!.count {
                stringArray.append(customData![index][pickerView.selectedRow(inComponent: index)])
            }
            customPickerString = stringArray.joined(separator: "-")
        default:
            break
        }
        
    }
    

    //MARK: - Private func
    @objc fileprivate func pickerButtonAction(button: UIButton) {
        dismiss()
        if button.tag == 1 {//confirm
            if dateInfoBlock != nil {
                let info = self.dateInfo
                dateInfoBlock!(info!)
            }
            
            if customPickerBlock != nil {
                let string = self.customPickerString
                customPickerBlock!(string!)
            }
        }
    }
    
    
    fileprivate func dismiss() {
        for button in buttons {
            button.handler = nil
        }
        self.removeFromSuperview()
    }
}

extension UIView {
    enum LinePosition {
        case top
        case bottom
    }
    
    func addLine(at position: LinePosition) {
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1))
        line.backgroundColor = UIColor.rgbColor(r: 204, g: 204, b: 204)
        addSubview(line)
        
        switch position {
        case .top:
            break
        case .bottom:
            line.frame.origin.y = self.frame.size.height - 1
        }
    }
}

extension Date {
    func systemDateInfo() -> LWDateInfo {
        return (LWDateFormatter.dateFormatter.string(from: self), "")
    }
    func everyThirtyIn24HoursDateInfo() -> LWDateInfo {
        return ("", LWDateFormatter.timeFormatter.string(from: self))
    }
    func dateInfo() -> LWDateInfo{
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: self)
        
        var weekday: String
        switch components.weekday! {
        case 1: weekday = "星期日"
        case 2: weekday = "星期一"
        case 3: weekday = "星期二"
        case 4: weekday = "星期三"
        case 5: weekday = "星期四"
        case 6: weekday = "星期五"
        case 7: weekday = "星期六"
        default: weekday = ""
        }
        
        let date = String(format:"%d年%d月%d日 %@", components.year!, components.month!, components.day!, weekday)
        let time = String(format:"%d:%02d", components.hour!, components.minute!)
        return (date, time)
    }
}
extension UIColor {
    class func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
