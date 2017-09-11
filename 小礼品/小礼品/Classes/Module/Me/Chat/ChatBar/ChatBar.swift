//
//  ChatBar.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/29.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import QorumLogs

let chatBarTextViewHeight:CGFloat      = 36.0
let chatBarTextViewMaxHeight:CGFloat   = 112.0

let chatBarTintColor = UIColor(red: 254.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.8)

class ChatBar: UIView {
    
//MARK: 属性
    weak var delegate:ChatBarDelegate?
    
    var isResignResponder:Bool?
    var viewModel:ChatBarViewModel? {
        didSet{

            //: 本地缓存
            viewModelData = viewModel!
            
            voiceButton.setImage(viewModel?.voiceButtonImage, for: .normal)
            voiceButton.setImage(viewModel?.voiceButtonHightLightedImage, for: .highlighted)
            
            moreButton.setImage(viewModel?.moreButtonImage, for: .normal)
            moreButton.setImage(viewModel?.moreButtonHightLightedImage, for: .highlighted)
            
            emojiButton.setImage(viewModel?.emojiButtonImage, for: .normal)
            emojiButton.setImage(viewModel?.emojiButtonHightLightedImage, for: .highlighted)
            
        }
    }
    
    private var viewModelData:ChatBarViewModel =  ChatBarViewModel()
//MARK: 懒加载
    //: 表情管理工具
    lazy var emojiManager:EmojiManager = EmojiManager.shared
    //: 表情键盘
    lazy var emojiKeyboard:EmojiKeyboard = { () -> EmojiKeyboard in
       let keyboard = EmojiKeyboard.shared
        keyboard.delegate = self
        return keyboard
    }()
    
    //: 更多键盘
    lazy var moreKeyboard:MoreKeyboard = { () -> MoreKeyboard in
        let keyboard = MoreKeyboard.shared
        
        return keyboard
    }()
    //: 按钮
    lazy var voiceButton:UIButton = { () -> UIButton in
       let button = UIButton()
        button.tag = ChatBarButtonType.voice.rawValue
        button.addTarget(self, action: #selector(voiceButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var moreButton:UIButton = { () -> UIButton in
       let button = UIButton()
        button.tag = ChatBarButtonType.more.rawValue
        button.addTarget(self, action: #selector(moreButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var emojiButton:UIButton = { () -> UIButton in
       let button = UIButton()
        button.tag = ChatBarButtonType.emoji.rawValue
        button.addTarget(self, action: #selector(emojiButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var textView:ChatBarTextView = { () -> ChatBarTextView in
        let text = ChatBarTextView()
        
        text.font = fontSize15
        text.returnKeyType = .send
        text.layer.masksToBounds = true
        text.layer.borderWidth = margin*0.1
        text.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        text.layer.cornerRadius = margin*0.5
        text.scrollsToTop = true
        text.delegate = self
        
        return text
    }()
    
    lazy var recordButton:RecordButton = {
        let button = RecordButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = margin*0.1
        button.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        button.layer.cornerRadius = margin*0.5
        button.delegate = self
        
        return button
    }()
//MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChatBar()
        
        setupChatBarSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resignFirstResponder() -> Bool {
        chatBarResignFirstResponder()
        
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        chatBarResignFirstResponder()
        
        return super.becomeFirstResponder()
    }
//MARK: 私有方法
    private func chatBarbecomeFirstResponder() {
        textView.becomeFirstResponder()
    }
    
    private func chatBarResignFirstResponder() {
          textView.resignFirstResponder()
          keyboardDissmiss()
          isResignResponder = true
    }
    
    private func setupChatBar() {
        backgroundColor = chatBarTintColor
        
        addSubview(voiceButton)
        addSubview(moreButton)
        addSubview(emojiButton)
        addSubview(recordButton)
        addSubview(textView)
        
        //: 初始化表情管理工具
        emojiManager.emojisGroup(byUserID: AccountModel.shareAccount()!.uid!) { [unowned self](array) in
            self.emojiKeyboard.emojiView.data = array
            self.emojiKeyboard.groupControl.group = array
        }
    }
    
    private func setupChatBarSubView() {
        
        
        voiceButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-margin*0.5)
            make.left.equalToSuperview()
            make.width.equalTo(margin*4)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin*0.7)
            make.bottom.equalToSuperview().offset(-margin*0.7)
            make.left.equalTo(voiceButton.snp.right).offset(margin*0.5)
            make.right.equalTo(emojiButton.snp.left).offset(-margin*0.5)
            make.height.equalTo(chatBarTextViewHeight)
        }
        
        
        moreButton.snp.makeConstraints { (make) in
            make.top.width.equalTo(voiceButton)
            make.right.equalToSuperview().offset(-margin*0.1)
        }
        
        emojiButton.snp.makeConstraints { (make) in
            make.top.width.equalTo(voiceButton)
            make.right.equalTo(moreButton.snp.left)
        }
        
        recordButton.snp.makeConstraints { (make) in
            make.center.size.equalTo(textView)
     
        }
    }
    
//MARK: 内部响应处理
    private func resetImageExcept(type:ChatBarButtonType) {
        if type != .voice {
            voiceButton.setImage(viewModelData.voiceButtonImage, for: .normal)
            voiceButton.setImage(viewModelData.voiceButtonHightLightedImage, for: .highlighted)
        }
        
        if type != .emoji {
            emojiButton.setImage(viewModelData.emojiButtonImage, for: .normal)
            emojiButton.setImage(viewModelData.emojiButtonHightLightedImage, for: .highlighted)
        }
        
        if type != .more {
            moreButton.setImage(viewModelData.moreButtonImage, for: .normal)
            moreButton.setImage(viewModelData.moreButtonHightLightedImage, for: .highlighted)
        }
        
    }
    
    //: 交换按钮图片
    private func changeButtonImage(button:UIButton,type:ChatBarButtonType) {
        
        var normalImage =  button.image(for: .normal)
        var hightLightImage = button.image(for: .highlighted)
        
        if type == .voice {
            normalImage = viewModelData.voiceButtonImage
            hightLightImage = viewModelData.voiceButtonHightLightedImage
        }
        else if type == .emoji {
            normalImage = viewModelData.emojiButtonImage
            hightLightImage = viewModelData.emojiButtonHightLightedImage
        }
        else if type == .more {
            normalImage = viewModelData.moreButtonImage
            hightLightImage = viewModelData.moreButtonHightLightedImage
        }
        else {
            normalImage = viewModelData.switchButtonImage
            hightLightImage = viewModelData.switchButtonHightLightImage
            
            resetImageExcept(type: ChatBarButtonType(rawValue: button.tag)!)
        }
        
        
        button.setImage(normalImage, for: .normal)
        button.setImage(hightLightImage, for: .highlighted)

    }
    
    @objc private func voiceButtonClick(button:UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            //: 取消第一响应
            chatBarResignFirstResponder()
            changeButtonImage(button: button,type: .text)
            textView.isHidden = true
            recordButton.isHidden = false
        }
        else{
            changeButtonImage(button: button,type: .voice)
            textView.isHidden = false
            recordButton.isHidden = true
            keyboardDissmiss()
        }
        
        
    }
    
    @objc private func moreButtonClick(button:UIButton) {
        button.isSelected = !button.isSelected
        chatBarResignFirstResponder()
        
        if button.isSelected {
            //: 取消第一响应
            changeButtonImage(button: button,type: .text)
            
            //: 显示键盘
            keyboardShow(userKeyboard: moreKeyboard, isShow: true)
        }
        else{
            changeButtonImage(button: button,type: .more)
            
        }
    }
    
    @objc private func emojiButtonClick(button:UIButton) {
        
         button.isSelected = !button.isSelected
        chatBarResignFirstResponder()
        
        if button.isSelected {
            //: 取消第一响应
            changeButtonImage(button: button,type: .text)
            
            //: 显示键盘
            keyboardShow(userKeyboard: emojiKeyboard, isShow: true)
        }
        else{
            changeButtonImage(button: button,type: .emoji)
        }
    }
    
    //: 显示键盘
    private func keyboardShow(userKeyboard keyboard:BaseKeyboard,isShow show:Bool) {
        if let view = self.superview {
            if show {
                keyboard.show(inView: view, withAnimation: true){ [unowned self] in
                    self.keyboardShowOpreation(view: view, keyboard: keyboard, show: show)
                }
            }
            else {
                keyboard.dissmiss(withAnimation: true){
                   self.keyboardShowOpreation(view: view, keyboard: keyboard, show: show)
                }
            }
            
        }
    }
    
    private func keyboardShowOpreation(view:UIView,keyboard:BaseKeyboard,show:Bool) {
        let offsetY = show ? keyboard.frame.origin.y : ScreenHeight
        self.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(offsetY - ScreenHeight)
        }
        
        view.layoutIfNeeded()
        
        delegate?.chatBarDidSelectUserKeyboard(keyboardY: offsetY, chatBarHeight: self.bounds.height)
    }
    
    private func keyboardDissmiss() {
        keyboardShow(userKeyboard: emojiKeyboard, isShow: false)
        keyboardShow(userKeyboard: moreKeyboard, isShow: false)
        changeButtonImage(button: emojiButton,type: .emoji)
        changeButtonImage(button: moreButton,type: .more)
    }
//MARK: 外部接口
    

}

//MARK: 代理方法
extension ChatBar:RecordButtonDelegate {
//MARK: 录音相关
    func recordButtonTouchedBegin() {
        delegate?.chatBarStartRecording()
    }
    
    func recordButtonTouchedMoved(_ isMovingIn: Bool) {
        delegate?.chatBarWillCancelRecording(cancel: isMovingIn)
    }
    
    func recordButtonTouchedEnd() {
        delegate?.chatBarFinshedRecording()
    }
    
    func recordButtonTouchedCancel() {
        delegate?.chatBarDidCancelRecording()
    }
}

//MARK: 代理方法
extension ChatBar:UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isResignResponder = false
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //MARK: 发送
        if text == "\n" {
            sendText(text: self.textView.message)
            return false
        }
        else {
            
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        reloadText(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.updateText()
        
        reloadText(true)
    }
    
    func sendText(text:String) {
        
        if NSString(string: text).length > 0 {
            delegate?.chatBarSendText(text: text)
        }
        
        textView.clearText()
        textView.attributedText = textView.message.toMsgString()
        reloadText(true)
    }
    
    func reloadText(_ animation:Bool) {
        let height = textView.attributedText.sizeToFitsAttribute(CGSize(width: textView.bounds.width - margin, height: CGFloat(MAXFLOAT))).height

        var textViewNewHeight:CGFloat = 0
        
        if height > chatBarTextViewMaxHeight {
            textViewNewHeight = chatBarTextViewMaxHeight
        }
        else if height > chatBarTextViewHeight/2 {
            textViewNewHeight = chatBarTextViewHeight/2 + height
        }
        else {
            textViewNewHeight = chatBarTextViewHeight
        }
        
        if height > textViewNewHeight {
            textView.isScrollEnabled = true
        }
        else {
            textView.isScrollEnabled = false
        }
        
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.textView.snp.updateConstraints({ (make) in
                    make.height.equalTo(textViewNewHeight)
                })
                
                if let view = self.superview {
                    view.layoutIfNeeded()
                    
                }
            }) { (_) in
                if height > textViewNewHeight {
                   
                    self.textView.setContentOffset( CGPoint(x: 0, y: height - textViewNewHeight), animated: true)
                }
            }
        }
        else {
            self.textView.snp.updateConstraints({ (make) in
                make.height.equalTo(textViewNewHeight)
            })
            
            if let view = self.superview {
                view.layoutIfNeeded()
            }
            
            if height > textViewNewHeight {
                
                self.textView.setContentOffset( CGPoint(x: 0, y: height - textViewNewHeight), animated: true)
            }
        }
    }
}

//MARK: 协议
protocol ChatBarDelegate:NSObjectProtocol {
    func chatBarSendText(text:String)
    func chatBarStartRecording()
    func chatBarWillCancelRecording(cancel:Bool)
    func chatBarFinshedRecording()
    func chatBarDidCancelRecording()
    
    func chatBarDidSelectUserKeyboard(keyboardY offsetY:CGFloat,chatBarHeight height:CGFloat)
}

//MARK: 表情键盘代理协议
extension ChatBar:EmojiKeyboardDelegate {
    func emojiKeyboardDidSelectdEmoji(withEmojiName text: String?, isDelete delete: Bool) {
        
        if let message = textView.message {
            if delete {
                
                if message.lengthOfBytes(using: .utf8) > 1{
                    
                    //: 判断是否系统表情
                    if message.isLastStringSystemEmoji() {
                        let endIndex = message.endIndex
                        let index  = message.index(endIndex, offsetBy: -4)
                        textView.message = message.substring(to: index)
                        reloadText(true)
                    }
                    else {
                        let index  = message.index(message.endIndex, offsetBy: -1)
                        textView.message = message.substring(to: index)
                        reloadText(true)
                    }
                }
            }
            else {
                if let msg = text {
                    
                    textView.message = message.appending(msg)
                    reloadText(true)
                }
            }
        }else{
            if !delete {
                textView.message = text
                reloadText(true)
            }
        }

        textView.attributedText = textView.message.toMsgString()
    }
    
    //: 发送表情
    func emojiKeyboardDidClickSendButton() {
        sendText(text: textView.message)
    }
}
