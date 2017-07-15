//
//  EmojiGroupControlCell.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit

class EmojiGroupControlCell: UICollectionViewCell {

//MARK: 属性
    var viewModel:EmojiGroupControlCellViewModel? {
        didSet{
            backView.image = viewModel?.backViewImage
            imageView.image = viewModel?.imageViewImage
            isbackViewHide = viewModel!.backViewHide
            leftLine.backgroundColor = viewModel?.lineColor
            rightLine.backgroundColor = viewModel?.lineColor
            backView.isHidden = isbackViewHide
        }
    }
    
    var isbackViewHide:Bool = false {
        didSet{
            backView.isHidden = isbackViewHide
        }
    }
//MARK: 懒加载
    var backView:UIImageView = { () -> UIImageView in
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var imageView:UIImageView = { () -> UIImageView in
        let view = UIImageView()
        
        return view
    }()
    
    var leftLine:UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var rightLine:UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
//MARK:  构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEmojiGroupControlCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupEmojiGroupControlCellSubView()
    }
//MARK: 私有方法
    private func setupEmojiGroupControlCell() {
        addSubview(backView)
        addSubview(imageView)
        addSubview(leftLine)
        addSubview(rightLine)
    }
    
    private func setupEmojiGroupControlCellSubView() {
        backView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftLine.snp.right)
            make.right.equalTo(rightLine.snp.left)
        }
        
        leftLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(margin*0.1)
            make.top.equalToSuperview().offset(margin*0.3)
            make.bottom.equalToSuperview().offset(-margin*0.3)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(leftLine.snp.right)
            make.top.bottom.equalTo(leftLine)
            make.right.equalTo(rightLine.snp.left)
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(leftLine)
            make.right.equalToSuperview()
        }
    }
}
