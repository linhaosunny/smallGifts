//
//  TextChatCell.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class TextChatCell: BaseChatCell {

    var viewModel: TextChatCellViewModel? {
        didSet{
            super.baseViewModel = viewModel
            
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
   
}
