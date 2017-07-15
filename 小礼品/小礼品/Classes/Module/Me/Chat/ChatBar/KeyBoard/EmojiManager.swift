//
//  EmojiManager.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情管理工具类

import UIKit


class EmojiManager: NSObject {

//MARK: 单例
    static let shared = EmojiManager()
    
    //: 设置完成的闭包
    var finshed:((_ array:NSMutableArray)->())?
    
    //: 用户ID
    var userid:String?
    
//MARK: 构造方法
    override init() {
        super.init()
    }
    
//: 外部接口
    func emojisGroup(byUserID id:String,complete:@escaping (_ array:NSMutableArray)->()) {
        userid = id
        finshed = complete
        
        //: 异步去获取
        DispatchQueue(label: "emojisGroup").async { 
            let emojiGroup = NSMutableArray()
            
            //: 添加默认系统表情
            emojiGroup.add(ChatExpression.shared.defaultEmoji)
            //: 添加默认系统Face
            emojiGroup.add(ChatExpression.shared.defaultFace)
            
            //: 添加用户收藏的表情包
            if let usrEmojis = ChatExpression.shared.usrEmoji {
                for i in 0..<usrEmojis.count {
                    emojiGroup.add(usrEmojis[i])
                }
            }
            
            //: 系统设置
            
            //: 执行用户的操作
            DispatchQueue.main.async(execute: { 
                complete(emojiGroup)
            })
        }
    }
}
