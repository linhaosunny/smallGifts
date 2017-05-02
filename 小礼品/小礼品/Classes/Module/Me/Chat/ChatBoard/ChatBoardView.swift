//
//  ChatBoardView.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import QorumLogs

let textMsgIdentifier = "TextChatCell"
let imageMsgIdentifier = "ImageChatCell"
let expressionMsgIdentifier = "ExpressionChatCell"
let voiceMsgIdentifier = "VoiceChatCell"
let videoMsgIdentifier = "VideoChatCell"
let positionMsgIdentifier = "PositionChatCell"
let defaultIdentifier  = "BaseChatCell"

class ChatBoardView: UITableView {

//: 属性
    weak var boardDelegate:ChatBoardViewDelegate?
    
    var dataModel:ChatBoardDataModel = ChatBoardDataModel()
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
        //: 样式设置
        setupChatBoardStyle()
        
        //: 注册Cell
        registerChatCells()
        
        //: 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(chatBoardDidTap))
        
        addGestureRecognizer(tap)
    }
    
    private func setupChatBoardStyle() {
        
        backgroundColor = SystemGlobalBackgroundColor
        separatorStyle = .none
        allowsSelection = false
        
        delegate = self
        dataSource = self
    }
    
    private func registerChatCells() {
        
        register(TextChatCell.self, forCellReuseIdentifier: textMsgIdentifier)
        register(ImageChatCell.self, forCellReuseIdentifier: imageMsgIdentifier)
        register(ExpressionChatCell.self, forCellReuseIdentifier: expressionMsgIdentifier)
        register(VoiceChatCell.self, forCellReuseIdentifier:voiceMsgIdentifier)
        register(VideoChatCell.self, forCellReuseIdentifier: videoMsgIdentifier)
        register(PositionChatCell.self, forCellReuseIdentifier: positionMsgIdentifier)
        register(BaseChatCell.self, forCellReuseIdentifier: defaultIdentifier)
        
    }
//MARK: 内部处理
    @objc private func chatBoardDidTap() {
        boardDelegate?.chatboardViewDidTap()
    }
//MARK: 开放接口
    func addMsgModel(MessageModel model:MessageModel) {
        //: 添加消息模型
        dataModel.msgModels.add(model)
        let height = dataModel.viewHeight(msg: model)
        dataModel.heights.add(height)
        //: 更新数据
        reloadData()
        
        //: 界面调整
        let indexPath = IndexPath(row: dataModel.msgModels.count - 1, section: 0)
        
        scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func updateViewModel(cellModel model:BaseChatCellViewModel){
     
    }
    
    func deleteMsgModel(MessageModel model:MessageModel,withAnimation animation:Bool) {
        
        
        dataModel.indexForMsgModel(model) { (index, result) in
            
            //: 如果数据匹配删除
            if result {
                //: 更新界面
                self.deleteRows(at: [IndexPath(row: index, section: 0)], with: animation ? .automatic: .none)
                
                //: 移除数据源
                self.dataModel.msgModels.remove(model)
            }
        }
        
    }
    
    func scrollChatBoard(keyboardY offsetY:CGFloat,chatBarHeight height:CGFloat, _ animation:Bool) {
        if ScreenHeight > offsetY {
            setContentOffset(CGPoint(x: 0, y:contentSize.height - (ScreenHeight - offsetY) + height), animated: animation)
        }
        else {
            setContentOffset(CGPoint(x: 0, y:contentSize.height - ScreenHeight + height), animated: animation)
        }
    }
}

//MARK: 代理方法 -> UITableViewDelegate
extension ChatBoardView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.msgModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return dataModel.heights[indexPath.row] as! CGFloat
    }
    
    //: 设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = dataModel.msgModels[indexPath.row] as! MessageModel
        
        switch msg.type {
        //: 文字消息
        case .text:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textMsgIdentifier) as! TextChatCell
            //: 如果ID一致无需更新
            
            cell.viewModel = TextChatCellViewModel(withTextMessage: msg as! TextMessage)
            
            return cell
        //: 图片消息
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageMsgIdentifier) as! ImageChatCell
            
            
            cell.viewModel = ImageChatCellViewModel(withImageMessage: msg as! ImageMessage )
            
            return cell
        //: 语音消息
        case .voice:
            let cell = tableView.dequeueReusableCell(withIdentifier: voiceMsgIdentifier) as! VoiceChatCell
            cell.viewModel = VoiceChatCellViewModel(withVoiceMessage: msg as! VoiceMessage)
            
            return cell
        //: 表情
        case .Expression:
            let cell = tableView.dequeueReusableCell(withIdentifier: expressionMsgIdentifier) as! ExpressionChatCell
            cell.viewModel = ExpressionChatCellViewModel(withExpressionMessage: msg as! ExpressionMessage)
            
            return cell
        //: 视频
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: videoMsgIdentifier) as! VideoChatCell
            cell.viewModel = VideoChatCellViewModel(withVideoMessage: msg as! VideoMessage)
            
            return cell
        //: 地理位置
        case .postion:
            let cell = tableView.dequeueReusableCell(withIdentifier: positionMsgIdentifier) as! PositionChatCell
            cell.viewModel = PositionChatCellViewModel(withPositionMessage: msg as! PositionMessage)
            
            return cell
        //: 默认
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: defaultIdentifier, for: indexPath) as? BaseChatCell
             cell!.baseViewModel = BaseChatCellViewModel(withMsgModel: msg)
            
             return cell!
        }
        
    }
    
    
}

//: 控制器代理方法
extension ChatBoardView:ChatViewControllerDelegate {
    
    func chatViewControllerDidLoadSubViews(withChatBoard view: ChatBoardView) {
        QL2("视图加载完毕")
        
    }
}

//MARK: 协议
protocol ChatBoardViewDelegate:NSObjectProtocol {
    func chatboardViewDidTap()
}

