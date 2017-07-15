//
//  MoreKeyboard.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/11.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  更多选择键盘

import UIKit

class MoreKeyboard: BaseKeyboard {

//: 单例
    static let shared = MoreKeyboard()

//: 懒加载

//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMoreKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//: 私有方法
    private func setupMoreKeyboard() {
        backgroundColor = SystemGlobalBackgroundColor
    }

}
