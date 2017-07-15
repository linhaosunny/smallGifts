//
//  ChatExpression.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情集

import UIKit
import LSXPropertyTool

class ChatExpression: NSObject {
//MARK: 属性
    
    //: 默认表情 Face
    var defaultFace:ChatEmojiGroup = { () -> ChatEmojiGroup in
        let emojiGroup = ChatEmojiGroup()
        emojiGroup.type = .Face
        emojiGroup.iconPath = "EmotionsEmojiHL"
        
        let path = Bundle.main.path(forResource: "FaceEmoji.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        var array:Array<Any>?
        do {
            array = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Array<Any>
        }
        catch{
            
        }
        
        emojiGroup.emojis = ExchangeToModel.model(withClassName: "Emoji", withArray: array)
        
        for i in 0..<emojiGroup.emojis!.count {
            let emoji = emojiGroup.emojis![i] as! Emoji
            emoji.type = .Face
        }
        
        return emojiGroup
    }()

    //: 默认系统Emoji
    var defaultEmoji:ChatEmojiGroup = { () -> ChatEmojiGroup in
        let emojiGroup = ChatEmojiGroup()
        emojiGroup.type = .Emoji
        emojiGroup.iconPath = "EmotionsEmojiHL"
        
        let path = Bundle.main.path(forResource: "SystemEmoji.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        var array:Array<Any>?
        do {
            array = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Array<Any>
        }
        catch{
            
        }
        
        emojiGroup.emojis = ExchangeToModel.model(withClassName: "Emoji", withArray: array)
        
        for i in 0..<emojiGroup.emojis!.count {
            let emoji = emojiGroup.emojis![i] as! Emoji
            emoji.type = .Emoji
        }
        
        return emojiGroup
    }()
    //: 用户表情组
    var usrEmoji:Array<ChatEmojiGroup>?
    //: 用户偏好组
    var usrPreferEmoji:ChatEmojiGroup?
    
//MARK: 单例
    static let shared = ChatExpression()
    
//MARK: 构造方法
    override init() {
        super.init()
    }
//MARK: 外部接口
    //: 添加表情组
    func addExpression(emoji:ChatEmojiGroup) -> Bool {
        return true
    }
    
    //: 删除表情组 
    func deleteExpression(id:String) -> Bool {
        return true
    }
    
    //: 表情包是否在使用
    func isExpressionInUseing(id:String) -> Bool{
        return true
    }
    
    func downloadExpression(emoji:ChatEmojiGroup,progress:(_ progress:CGFloat)->()
                                                ,success:(_ emoji:ChatEmojiGroup) ->()
                                                ,failure:(_ emoji:ChatEmojiGroup,_ error:Error)->()) {
        
        
    }
    
    //: 列出表情包
    func listExpression() -> Array<ChatEmojiGroup>?{
      
        return nil
    }

}
