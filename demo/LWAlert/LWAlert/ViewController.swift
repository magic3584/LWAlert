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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

