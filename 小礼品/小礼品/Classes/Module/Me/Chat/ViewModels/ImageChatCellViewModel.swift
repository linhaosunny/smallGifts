//
//  ImageChatCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class ImageChatCellViewModel: BaseChatCellViewModel {
    private var msg:ImageMessage?
    var imageSize:CGSize = .zero
    
    init(withImageMessage msg:ImageMessage){
        self.msg = msg
        super.init(withMsgModel: msg as MessageModel)
        
    }
}
