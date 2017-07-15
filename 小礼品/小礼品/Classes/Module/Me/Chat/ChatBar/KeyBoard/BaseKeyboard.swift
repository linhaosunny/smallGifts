//
//  BaseKeyboard.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/6.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit

let chatKeyboardHeight:CGFloat = 220.0

class BaseKeyboard: UIView {
//MARK: 属性
    var isShow:Bool = false
    
//MARK: 外部接口
    func show(withAnimation animation:Bool) {
        show(inView: UIApplication.shared.keyWindow!, withAnimation: animation) {
            
        }
    }
    //: 键盘显示
    func show(inView view:UIView,withAnimation animation:Bool,finshed: @escaping ()->()) {
        
        if isShow {
            return
        }
        
        isShow = true
        //: 添加到父视图
        view.addSubview(self)
        
        self.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(chatKeyboardHeight)
            make.bottom.equalToSuperview().offset(chatKeyboardHeight)
        }
        //: 重新布局父视图
        view.layoutIfNeeded()
        
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.snp.updateConstraints({ (make) in
                    make.bottom.equalToSuperview()
                })
                //: 重新布局父视图
                view.layoutIfNeeded()
                
                
            }, completion: { (_) in
                finshed()
            })
        }
        else {
            self.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview()
            })
            //: 重新布局父视图
            view.layoutIfNeeded()
            
            finshed()
        }
    }
    
    //: 键盘消息
    func dissmiss(withAnimation animation:Bool,finshed:@escaping () -> ()) {
        if !isShow {
            if !animation {
                self.removeFromSuperview()
            }
            return
        }
        
        isShow = false
        
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.snp.updateConstraints({ (make) in
                    make.bottom.equalToSuperview().offset(chatKeyboardHeight)
                })
                self.superview?.layoutIfNeeded()
                
                
            }, completion: { (_) in
                //: 移除布局
                self.snp.removeConstraints()
                self.removeFromSuperview()
                finshed()
            })
        }
        else{
            //: 移除
            //: 移除布局
            self.snp.removeConstraints()
            self.removeFromSuperview()
            finshed()
        }
        
    }
}
