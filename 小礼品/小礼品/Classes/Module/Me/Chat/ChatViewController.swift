//
//  ChatViewController.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit
import QorumLogs

fileprivate let chatBarHeight:CGFloat = 50.0

class ChatViewController: UIViewController {

    
//MARK: 懒加载
    var delegate:ChatViewControllerDelegate?
    
    //: 工具条
    var chatBar:ChatBar = { () -> ChatBar in
        let bar = ChatBar()
        bar.viewModel = ChatBarViewModel()
        return bar
    }()
    //: 聊天板
    lazy var chatBoard:ChatBoardView = ChatBoardView(frame: CGRect.zero, style: .plain)
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChatView()
      
        setupChatViewSubView()
        
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        delegate?.chatViewControllerDidLoadSubViews(withChatBoard: chatBoard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupChatViewWhenViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setupChatViewWhenViewWillDisappear()
    }
//MARK: 私有方法
    private func setupChatViewWhenViewWillAppear() {
        //: 键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
    
    }
    
    private func setupChatViewWhenViewWillDisappear() {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    private func setupChatView() {
        title = "客服"
        delegate = chatBoard
        chatBoard.boardDelegate = self
        chatBar.delegate = self
        view.addSubview(chatBoard)
        view.addSubview(chatBar)
        
    }
    
    private func setupChatViewSubView() {
        chatBoard.snp.makeConstraints { (make) in
           make.left.right.top.equalToSuperview()
           make.bottom.equalTo(chatBar.snp.top)
        }
        
        chatBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(chatBarHeight)
        }
    }
//MARK: 内部处理
    @objc private func keyboardWillAppear(notification:Notification) {
        
    }
    
    @objc private func keyboardDidAppear(notification:Notification) {
        
    }
    
    @objc private func keyboardWillDisappear(notification:Notification) {

    }
    
    @objc private func keyboardFrameWillChange(notification:Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] else {
            return
        }
        
        let frame = value as! CGRect
    
        QL2("\(frame.origin.y),\(frame.size.height),\(chatBoard.contentSize.height)")
        
        chatBar.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(frame.origin.y - ScreenHeight)
        }
        
        view.layoutIfNeeded()
        
        chatBoard.scrollChatBoard(keyboardY: frame.origin.y, chatBarHeight: chatBar.bounds.height, false)
        
     
          //: 通过transform方式,由后台进入前台,transform 变成ident 导致bar出问题，不建议使用
//        UIView.animate(withDuration: 0.5) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: frame.origin.y - ScreenHeight)
//        }
        
    }
//MARK: 开放接口
    //: 添加消息
    func addMessage(withMessageModel msg:MessageModel) {
        
        chatBoard.addMsgModel(MessageModel: msg)
        
    }
}

//: 代理方法
extension ChatViewController:ChatBoardViewDelegate {
    
    func chatboardViewDidTap() {
       _ = chatBar.resignFirstResponder()
    }
}

extension ChatViewController:ChatBarDelegate {
    func chatBarSendText(text: String) {
        addMessage(withMessageModel: TextMessage.userMessage(text: text))
    }
}

//: 控制器的代理方法
protocol ChatViewControllerDelegate:NSObjectProtocol {
    func chatViewControllerDidLoadSubViews(withChatBoard view:ChatBoardView)
}


