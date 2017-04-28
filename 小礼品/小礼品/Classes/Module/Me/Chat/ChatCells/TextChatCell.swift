//
//  TextChatCell.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit

class TextChatCell: BaseChatCell {

    var viewModel: TextChatCellViewModel? {
        didSet{
            super.baseViewModel = viewModel
            
            //: 设置内容
            msgLabel.attributedText = viewModel!.msgAttributedText
            //: 设置背景图片
            backView.image = viewModel!.msgBackViewImage
            backView.highlightedImage = viewModel!.msgBackViewSelImage
            
            //: 内容压缩阻力优先级
            msgLabel.setContentCompressionResistancePriority(500, for: .horizontal)
            backView.setContentCompressionResistancePriority(100, for: .vertical)
            
            //: 界面布局
            layoutTextChatCell()
        }
    }
    
//MARK: 懒加载
    lazy var msgLabel: UILabel = { () -> UILabel in
        let label = UILabel()
        label.font = fontSize16
        label.numberOfLines = 0
        return label
    }()
    
//MARK: 构造方法
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTextChatCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: 私有方法
    private func setupTextChatCell() {
        addSubview(msgLabel)
    }
    
    private func layoutTextChatCell() {
        if self.viewModel!.viewLocation == .right {
            msgLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(backView).offset(-margin*2.0)
               
            })
            
            backView.snp.updateConstraints({ (make) in
                make.left.equalTo(msgLabel).offset(-margin*2.0)
                make.bottom.equalTo(msgLabel).offset(margin*2.0)
            })
        }
        else  {
            msgLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(backView).offset(margin*2.0)
            })
            
            backView.snp.updateConstraints({ (make) in
                make.right.equalTo(msgLabel).offset(margin*2.0)
                make.bottom.equalTo(msgLabel).offset(margin*2.0)
            })
        }
        
        msgLabel.snp.updateConstraints { (make) in
            make.size.equalTo(viewModel!.viewFrame!.contentSize)
            make.top.equalTo(backView).offset(margin*1.4)
        }
    }
   
}
