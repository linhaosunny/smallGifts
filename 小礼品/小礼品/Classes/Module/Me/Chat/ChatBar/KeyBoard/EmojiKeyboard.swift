//
//  EmojiKeyboard.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/6.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情键盘

import UIKit
import SnapKit
import QorumLogs

fileprivate let pageTintColor = UIColor(white: 0.5, alpha: 0.3)

class EmojiKeyboard: BaseKeyboard {
//MARK: 单例
    static let shared = EmojiKeyboard()
//MARK: 属性
    weak var delegate:EmojiKeyboardDelegate?
//MARK: 懒加载
    //: 表情显示页面
    lazy var emojiView:EmojiGroupView = { () -> EmojiGroupView in
       let view = EmojiGroupView()
        view.delegate = self
        return view
    }()
    
    //: 页控制器
    lazy var pageControl:UIPageControl = { () -> UIPageControl in
        let control = UIPageControl()
        control.pageIndicatorTintColor = pageTintColor
        control.currentPageIndicatorTintColor = UIColor.gray
    
        control.numberOfPages = 0
        
        control.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return control
    }()
    
    //: 组控制器
    lazy var groupControl:EmojiCroupControl = { () -> EmojiCroupControl in
        let control = EmojiCroupControl()
        control.delegate = self
        return control
    }()
//MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupEmojiKeyboardSubView()
    }
//MARK: 私有方法
    private func setupEmojiKeyboard() {
        backgroundColor = SystemGlobalBackgroundColor
        addSubview(pageControl)
        addSubview(groupControl)
        addSubview(emojiView)

    }
    
    private func setupEmojiKeyboardSubView() {
        emojiView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        
        pageControl.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(groupControl.snp.top)
            make.height.equalTo(margin*2.0)
        }
        
        groupControl.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(margin*3.8)
        }
    }
//MARK: 内部响应
    @objc private func pageControlChanged() {
        
    }
}

//MARK: 代理方法 -> EmojiGroupViewDelegate
extension EmojiKeyboard:EmojiGroupViewDelegate {
    func emojiGroupViewGroupChanged(withGroupIndex index: Int, withGroupPages pages: Int) {
        pageControl.numberOfPages = pages
    }
    
    //: 发送表情
    func emojiGroupViewDidSelectedEmoji(withItem item: Int, withEmojiName text: String?, isDelete delete: Bool) {
        QL1(text)
        delegate?.emojiKeyboardDidSelectdEmoji(withEmojiName: text, isDelete: delete)
    }
    
    func emojiGroupViewDidScrollToPage(withPage page: Int) {
        pageControl.currentPage = page
    }
}

//MARK: 代理方法 -> EmojiGroupControlDelegate
extension EmojiKeyboard:EmojiGroupControlDelegate {
    func emojiGroupControlDidSelectGroupItem(GroupItem item: Int) {
        emojiView.groupIndex = item
        pageControl.currentPage = 0
        emojiView.emojiGroupViewDidScrollTo(Pages: pageControl.currentPage)
    }
    
    func emojiGroupControlDidClickSendButton() {
        delegate?.emojiKeyboardDidClickSendButton()
    }
}
protocol EmojiKeyboardDelegate:NSObjectProtocol {
    func emojiKeyboardDidSelectdEmoji(withEmojiName text:String?,isDelete delete:Bool)
    func emojiKeyboardDidClickSendButton()
}
