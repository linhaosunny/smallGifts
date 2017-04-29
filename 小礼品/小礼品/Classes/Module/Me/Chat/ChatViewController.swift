//
//  ChatViewController.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

//MARK: 懒加载
    var delegate:ChatViewControllerDelegate?
    //: 聊天板
    lazy var chatBoard:ChatBoardView = ChatBoardView(frame: CGRect.zero, style: .plain)
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChatView()
      
        var i = 0
        for _ in 0...5 {
            i += 1
            let msg = TextMessage()
             msg.text = "呵呵哒,来聊天,呵呵哒,来聊天,呵呵哒,来聊天,呵呵哒,来聊天,呵呵哒,来聊天,摸摸哒,傻逼最傲娇😄"
             msg.owner = .user
             msg.source = .myself
            
            addMessage(withMessageModel: msg)
            
            let msg0 = TextMessage()
            msg0.text = "做什么呀?摸摸哒,傻逼最傲娇😄"
            msg0.owner = .user
            msg0.source = .friends
            msg0.date = Date()
            let usr = UserModel()
            usr.avatarLoc = "me_avatar_boy"
            usr.nickname = "天不怕，地不怕"
            usr.uid = "6666666"
            msg0.fromUsr = usr
            
            addMessage(withMessageModel: msg0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupChatViewSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        delegate?.chatViewControllerDidLoadSubViews(withChatBoard: chatBoard)
    }
//MARK: 私有方法
    private func setupChatView() {
        title = "客服"
        delegate = chatBoard
        view.addSubview(chatBoard)
    }
    
    private func setupChatViewSubView() {
        chatBoard.snp.makeConstraints { (make) in
           make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
//MARK: 开放接口
    //: 添加消息
    func addMessage(withMessageModel msg:MessageModel) {
        
        guard let model = BaseChatCellViewModel.create(withMsgModel: msg) else {
            return
        }
        chatBoard.addViewModel(cellModel: model)
    }
}

//: 控制器的代理方法
protocol ChatViewControllerDelegate:NSObjectProtocol {
    func chatViewControllerDidLoadSubViews(withChatBoard view:ChatBoardView)
}
