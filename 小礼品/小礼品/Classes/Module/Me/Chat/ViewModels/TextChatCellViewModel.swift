//
//  TextChatCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class TextChatCellViewModel: BaseChatCellViewModel {
    private var msg:TextMessage?
    
    var msgAttributedText:NSAttributedString?
    
    var viewFrame:ViewFrame?

    init(withTextMessage msg:TextMessage){
        self.msg = msg
        super.init(withMsgModel: msg as MessageModel)
        
        
    }
    
}
