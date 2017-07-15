//
//  BaseEmojiCell.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情基本cell

import UIKit

class BaseEmojiCell: UICollectionViewCell {

//: 属性
    var baseviewModel:BaseEmojiCellViewModel? {
        didSet{
            
        }
    }
    
//: 懒加载
    lazy var iconView:UIImageView = { () -> UIImageView in
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5.0
        return view
    }()

//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBaseEmojiCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//: 私有方法
    private func setupBaseEmojiCell() {
        contentView.addSubview(iconView)
        
        setupBaseEmojiCellSubView()
    }
    
    private func setupBaseEmojiCellSubView() {
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
}
