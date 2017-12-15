# LWAlert

![图片](https://github.com/magic3584/LWAlert/raw/master/screenshot.gif)

# Features
* hud
* alert

# Requirements
* Xcode 9.0+
* Swift 4.0+

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
        
        if sender.tag == 0 {
            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .hud)
        } else {
            alert = LWAlert.init(title: "this is title", message: "this is message this is message this is message this is message this is message this is message this is message this is message ", style: .alert)
            
            alert.addButton(LWAlertButton.init(title: "Cancel", handler: nil))
            alert.addButton(LWAlertButton.init(title: "Confirm", handler: { ( button ) in
                print("confirm")
                
                //Don't use alert or it will cause a retain cycle
                //print(alert.buttons.count)
            }))
        }
        
        alert .show()
    }

```

# License
LWAlert is provided under the MIT license. See LICENSE file for details.
