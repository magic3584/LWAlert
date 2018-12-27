# LWAlert

![图片](https://github.com/magic3584/LWAlert/raw/master/screenshot.gif)

# Features
* hud
* alert
* picker
* custom components with specified row

# Requirements
* Xcode 9.0+

* Swift 4.2+

  > Swift 4.0 use tag 0.1.1 but with a retain cycle problem.

# Installation
## CocoaPods

1. Add ``pod 'LWAlert' `` to your Podfile.

2. Run ``pod install`` or ``pod update``.

## Manually
1. Download or clone this repository.

2. Drag the ``LWAlert`` folder into your project.

# Usage
``` swift
@IBAction func buttonAction(_ sender: UIButton) {
        
        var alert: LWAlert
        
        if sender.tag == 0 {//hud
//            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .hud)
            LWAlert.showHUD(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message")
            return
            
        } else if sender.tag == 1{
            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .alert)
            
            alert.addButton(LWAlertButton.init(title: "Cancel", handler: nil))
            alert.addButton(LWAlertButton.init(title: "Confirm", handler: { ( button ) in
                print("confirm")
                
                //Don't worry about retain cycle
                //print(alert.buttons.count)
            }))
        } else if sender.tag == 2 {//datePicker
            alert = LWAlert.init(style: .datePicker)
            alert.dateInfoBlock = { info in
                print(info.date)
            }
        } else if sender.tag == 3 {//timePicker
            alert = LWAlert.init(style: .timePicker)
            alert.dateInfoBlock = { info in
                print(info.time)
            }
        }else if sender.tag == 4 {//systemDatePicker
            alert = LWAlert.init(style: .systemDatePicker)
            alert.dateInfoBlock = { info in
                print(info.date)
            }
        }else if sender.tag == 5{//everyThirtyIn24Hours
            alert = LWAlert.init(style: .everyThirtyIn24Hours)
            alert.dateInfoBlock = { info in
                print(info.time)
            }
        }else if sender.tag == 6{//custom Picker with 1 component
            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"]])
            alert.customPickerBlock = { str in
                print(str)
            }
        }else{////custom Picker with 2 components
//            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"], ["O", "T", "F"]], defaultStrings: ["NotExsit", "T"])
            alert = LWAlert.init(customData: [["One", "Two", "Three", "Four", "Five"], ["O", "T", "F"]])
            alert.customPickerBlock = { str in
                print(str)
            }
        }
        
        alert.show()
    }
```



# License
LWAlert is provided under the MIT license. See LICENSE file for details.

