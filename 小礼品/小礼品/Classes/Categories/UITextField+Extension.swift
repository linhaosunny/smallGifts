//
//  UITextField+Extension.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/23.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(_ isCustom :Bool) {
        self.init()
        
        if isCustom {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(sender:)))
            tap.numberOfTapsRequired = 1
            
            addGestureRecognizer(tap)
        }
    }
    
    //MARK: 内部处理方法
    @objc func handleTapAction(sender:UITapGestureRecognizer) {
        becomeFirstResponder()
        
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyAction))
        let pasteItem = UIMenuItem(title: "粘贴", action: #selector(pasteAction))
        let cutItem = UIMenuItem(title: "剪切", action: #selector(cutAction))
        
        let menuControl = UIMenuController.shared
        
        menuControl.menuItems = [copyItem,pasteItem,cutItem]
        menuControl.setTargetRect(self.frame, in: self.superview!)
        menuControl.setMenuVisible(true, animated: true)
        
    }
    
    @objc func copyAction() {
       UIPasteboard.general.string = self.text
    }
    
    @objc func pasteAction() {
        self.text = UIPasteboard.general.string
    }
    
    @objc func cutAction() {
        UIPasteboard.general.string = self.text
        self.text = ""
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyAction) {
            return true
        }
        
        if action == #selector(pasteAction) {
            return true
        }
        
        if action == #selector(cutAction) {
            return true
        }

        
        return false
    }
    

}
