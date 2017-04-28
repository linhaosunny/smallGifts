//
//  TextMessage.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class TextMessage: MessageModel {
    //: 文字信息
    var text:String?{
        didSet{
            attrText = text?.ToMsgString()
        }
    }
    //: 格式化的富文本
    var attrText:NSAttributedString?
}
