//
//  EmojiCroupControl.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情下组控制器

import UIKit
import SnapKit

class EmojiCroupControl: UIView {
//: 属性
    weak var delegate:EmojiGroupControlDelegate?
    
    var group:NSMutableArray?{
        didSet {
            collectionView.reloadData()
        }
    }
    fileprivate let cellIdentifier = "GroupControlCell"
    
    var selectCell:EmojiGroupControlCell?
//: 懒加载
    //: 新增按钮
    lazy var addButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "Card_AddIcon.png"), for: .normal)
        button.addTarget(self, action: #selector(addButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    //: 发送按钮
    lazy var sendButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        
        button.setTitle(" 发送", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.titleLabel?.font = fontSize15
        button.setBackgroundImage(#imageLiteral(resourceName: "EmotionsSendBtnBlue.png"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "EmotionsSendBtnBlueHL.png"), for: .highlighted)
        
        button.addTarget(self, action: #selector(sendButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView:UICollectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = margin*0.1
        layout.itemSize = CGSize(width: 32.0, height: 32.0)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.scrollsToTop = false
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEmojiGroupControl()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupEmojiGroupControlSubViews()
    }

//: 私有方法
    private func setupEmojiGroupControl() {
        backgroundColor = UIColor.white
        addSubview(addButton)
        addSubview(collectionView)
        addSubview(sendButton)
        
        collectionView.register(EmojiGroupControlCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    private func setupEmojiGroupControlSubViews() {
        addButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(addButton.snp.height)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(sendButton.snp.height).multipliedBy(170.0/74.0)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(addButton.snp.right)
            make.right.equalTo(sendButton.snp.left)
        }
    }
//: 内部响应
    @objc private func addButtonClick(button:UIButton) {
        
    }
    
    //: 发送emoji
    @objc private func sendButtonClick(button:UIButton) {
        delegate?.emojiGroupControlDidClickSendButton()
    }
}

//MARK: 代理方法 -> 
extension EmojiCroupControl:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.group?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmojiGroupControlCell
       
        let model = EmojiGroupControlModel()
        model.image = UIImage(named: "EmotionsEmojiHL")
        
        
        cell.viewModel = EmojiGroupControlCellViewModel(withModel: model)
        
        if indexPath.row == 0 {
            cell.isbackViewHide = false
            selectCell = cell
        }

        return cell
    }
    
    //: 选中时
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! EmojiGroupControlCell
        
        if let select = selectCell {
            select.isbackViewHide = true
        }
        
        cell.isbackViewHide = false
        
        selectCell = cell
        
        
        delegate?.emojiGroupControlDidSelectGroupItem(GroupItem: indexPath.row)
    }
}

protocol EmojiGroupControlDelegate:NSObjectProtocol {
    func emojiGroupControlDidSelectGroupItem(GroupItem item:Int)
    func emojiGroupControlDidClickSendButton()
}
