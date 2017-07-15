//
//  EmojiFaceCell.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class EmojiFaceCell: BaseEmojiCell {
    
//: 属性
    fileprivate let imageViewWidth:CGFloat = 31.0
    
    var viewModel:EmojiFaceCellViewModel? {
        didSet{
            super.baseviewModel = viewModel
            
            imageView.isHidden = viewModel!.isImageViewHidden
            label.isHidden = viewModel!.isLabelHidden
            
            if let image = viewModel?.image {
                imageView.image = image
            }
            
            if let text = viewModel?.lableText {
                label.text = text
            }
        }
    }
//: 懒加载
    lazy var imageView:UIImageView = { () -> UIImageView in
        let view = UIImageView()
        
        return view
    }()
    
    lazy var label:UILabel = {
        let label = UILabel()
        label.font = fontSize28
        label.textAlignment = .center
        return label
    }()
//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEmojiFaceCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//: 私有方法
    private func setupEmojiFaceCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        setupEmojiFaceCellSubView()
    }
    
    private func setupEmojiFaceCellSubView() {
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(imageViewWidth)
        }
        
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        
    }
}
