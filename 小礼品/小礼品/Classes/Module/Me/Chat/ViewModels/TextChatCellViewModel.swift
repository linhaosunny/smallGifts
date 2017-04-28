//
//  TextChatCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

fileprivate let maxMessageWidth:CGFloat = ScreenWidth * 0.58

class TextChatCellViewModel: BaseChatCellViewModel {
    private var msg:TextMessage?
    
    //: 富文本字体
    var msgAttributedText:NSAttributedString?
    
    //: 消息背景图片
    var msgBackViewImage:UIImage?
    
    //: 消息选中背景图片
    var msgBackViewSelImage:UIImage?
    
    
    var viewFrame:ViewFrame?

    init(withTextMessage msg:TextMessage){
        self.msg = msg
        super.init(withMsgModel: msg as MessageModel)
        
        msgAttributedText = msg.attrText
        //: 消息来源
        if msg.source == .myself {
            msgBackViewImage = UIImage(named: "")
            msgBackViewImage = UIImage(named: "")
        }
        else{
            msgBackViewImage = UIImage(named: "")
            msgBackViewImage = UIImage(named: "")
        }
        //: 消息高度
        let label = UILabel()
        label.attributedText = msg.attrText
        
        //: 设置Label大小
        viewFrame?.contentSize = label.sizeThatFits(CGSize(width: maxMessageWidth, height: CGFloat(MAXFLOAT)))
        viewFrame?.height = (viewFrame?.contentSize.height)!
    }
    
}
