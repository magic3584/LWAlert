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
}

open class LWAlertButton: UIView {
    var button: UIButton!
    var handler: ((LWAlertButton) -> ())?
    
    public init(title: String?, handler:((LWAlertButton) -> ())? = nil) {
        super.init(frame: .zero)
        
        self.handler = handler
        
        button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.init(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(LWAlertButton.buttonAction), for: .touchUpInside)
        
        addSubview(button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func updateFrame(frame: CGRect) {
        self.frame = frame
        button.frame = self.bounds
    }
    
    @objc private func buttonAction() {
        if handler != nil {
            handler!(self)
        }
    }
}

open class LWAlert: UIView {
    
    var bgView: UIView!
    var realView: UIView!
    var style: LWAlertStyle!
    
    var buttons = [LWAlertButton]()
    
    //space between labels
    let space:CGFloat = 10
    //label margin
    let margin: CGFloat = 6
    
    var showDuration: TimeInterval = 2.0
    
    public init(title: String?, message: String?, style: LWAlertStyle) {
        super.init(frame: UIScreen.main.bounds)
        
        self.style = style
        
        bgView = UIView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.init(white: 0.3, alpha: 1)
        addSubview(bgView)
        
        realView = UIView.init(frame: CGRect(x: 0, y: 0, width: bgView.bounds.size.width * 0.8, height: 200))
        realView.backgroundColor = UIColor.white
        realView.layer.cornerRadius = 10.0
        realView.layer.backgroundColor = UIColor.white.cgColor
        realView.clipsToBounds = true
        
        var height: CGFloat = space
        
        if title != nil {
            let label = UILabel()
            label.text = title!
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addButton(_ button: LWAlertButton) {
        buttons.append(button)
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        switch style{
        case .hud:
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.backgroundColor = UIColor.init(white: 0.3, alpha: 1)
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + self.showDuration, execute: {
                    self.removeFromSuperview()

                })
            })
        case .alert:
            guard buttons.count > 0 else { return }
            
            let buttonHeight: CGFloat = 37.5
            let buttonWidth = realView.frame.size.width / CGFloat(buttons.count)
            
            let buttonView = UIView.init(frame: CGRect(x: 0, y: realView.frame.size.height, width: realView.frame.size.width, height: buttonHeight))
            
            for (index, button) in buttons.enumerated() {
                button.updateFrame(frame: CGRect(x: buttonWidth * CGFloat(index), y: 0, width: buttonWidth, height: buttonHeight))
                buttonView.addSubview(button)
            }
            
            realView.addSubview(buttonView)
        
            realView.frame.size.height += buttonHeight
            realView.center = center
            
        default:
            break
        }
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
}
