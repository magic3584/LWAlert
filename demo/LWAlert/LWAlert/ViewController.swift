//
//  ViewController.swift
//  LWAlert
//
//  Created by wang on 14/12/2017.
//  Copyright © 2017 wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        var alert: LWAlert!
        
        if sender.tag == 0 {//hud
//            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .hud)
            LWAlert.showHUD(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message")
            return
            
        } else if sender.tag == 1{
            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .alert)
            
            alert.addButton(LWAlertButton.init(title: "Cancel", handler: nil))
            alert.addButton(LWAlertButton.init(title: "Confirm", handler: { ( button ) in
                print("confirm")
                
                //Don't use alert or it will cause a retain cycle
                //print(alert.buttons.count)
            }))
        } else if sender.tag == 2 {//datePicker
            alert = LWAlert.init(style: .datePicker)
            alert.dateInfoBlock = { info in
                print(info)
            }
        } else if sender.tag == 3 {//timePicker
            alert = LWAlert.init(style: .timePicker)
            alert.dateInfoBlock = { info in
                print(info)
            }
        }else if sender.tag == 4 {//systemDatePicker
            alert = LWAlert.init(style: .systemDatePicker)
            alert.minDate = LWDateFormatter.dateFormatter.date(from: "2016-12-12")
            alert.maxDate = LWDateFormatter.dateFormatter.date(from: "2017-12-12")
            alert.dateInfoBlock = { info in
                print(info)
            }
        }else if sender.tag == 5{//everyThirtyIn24Hours
            alert = LWAlert.init(style: .everyThirtyIn24Hours)
            alert.dateInfoBlock = { info in
                print(info)
            }
        }else if sender.tag == 6{//custom Picker with 1 component
            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"]])
            alert.customPickerBlock = { str in
                print(str)
            }
        }else if sender.tag == 7{////custom Picker with 2 components
//            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"], ["O", "T", "F"]], defaultStrings: ["NotExsit", "T"])
            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"], ["O", "T", "F"]])
            alert.customPickerBlock = { str in
                print(str)
            }
        } else if sender.tag == 8 {//systemDateAndQuarterPicker
            alert = LWAlert.init(style: .systemDateAndQuarterPicker)
            alert.minDate = LWDateFormatter.dateAndThirtyFormatter.date(from: "2016-12-12 08:05")
            alert.maxDate = LWDateFormatter.dateAndThirtyFormatter.date(from: "2017-12-12 14:31")
            alert.dateInfoBlock = { info in
                print(info)
            }
        }
        alert.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

