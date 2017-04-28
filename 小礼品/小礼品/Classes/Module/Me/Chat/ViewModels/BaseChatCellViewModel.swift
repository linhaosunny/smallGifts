//
//  BaseChatCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

public enum layoutLocation : Int {
    
    case left
    
    case right
    
}

class BaseChatCellViewModel: NSObject {
    private var msg:MessageModel?
    
    var timeLabelText:String?
    var avatarImage:UIImage?
    var avatarUrl:URL?
    var avatarLocation:layoutLocation?
    var showNameLabel:Bool = true
    
    init(withMsgModel msg:MessageModel) {
        self.msg = msg
        
        if let text = msg.date?.ToStringInfo() {
            timeLabelText = String(format: "  %@  ", text)
        }
        
        //: 从本地获取
        if let name = msg.fromUsr?.avatarLoc,
           let image = UIImage(named: FileManager.userAvatarPath(avatarName: name)) {
            avatarImage = image
        }
        //: 获取网络图片
        else {
            
            if let url = msg.fromUsr?.avatarUrl {
                avatarUrl = URL(string: url)
            }
        }
        
        //: 更新布局位置
        if msg.source == .myself {
            avatarLocation = layoutLocation(rawValue: layoutLocation.right.rawValue)
        }
        else {
            avatarLocation = layoutLocation(rawValue: layoutLocation.left.rawValue)
        }

        
    }
}
