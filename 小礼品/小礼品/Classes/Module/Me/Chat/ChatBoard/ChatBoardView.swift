//
//  ChatBoardView.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

let textMsgIdentifier = "TextChatCell"
let imageMsgIdentifier = "ImageChatCell"
let emoMsgIdentifier = "ExpressionChatCell"
let voiceMsgIdentifier = "VoiceChatCell"
let videoMsgIdentifier = "VideoChatCell"
let defaultIdentifier  = "UITableViewCell"

class ChatBoardView: UITableView {

//: 构造方法
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        setupChatBoardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//: 私有方法
    private func setupChatBoardView() {
        //: 注册Cell
        registerChatCells()
    }
    
    private func registerChatCells() {
        register(TextChatCell.self, forCellReuseIdentifier: textMsgIdentifier)
    }
}
