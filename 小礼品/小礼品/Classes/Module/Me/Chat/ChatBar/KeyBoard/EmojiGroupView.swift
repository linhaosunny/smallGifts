//
//  EmojiGroupView.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/12.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  表情组视图

import UIKit


fileprivate let emojiWidth:CGFloat = 36

class EmojiGroupView: UIView {

//: 属性
    fileprivate let baseCellIndetifier = "BaseEmojiCell"
    fileprivate let emojiFaceIndetifier = "EmojiFaceCell"
    fileprivate let emojiImageIndetifier = "EmojiImageCell"
    fileprivate let emojiImageTextIndetifier = "EmojiImageTextCell"
    
    weak var delegate:EmojiGroupViewDelegate?
    
    var groupIndex:Int = 0 {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var viewModel:EmojiGroupViewModel? {
        didSet{
            
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.scrollDirection = .horizontal
            layout.itemSize = viewModel!.layoutItemSize!
            layout.minimumLineSpacing = viewModel!.layoutItemMinimumLineSpacing
            layout.minimumInteritemSpacing = viewModel!.layoutItemMinimumInteritemSpacing
            layout.sectionInset = viewModel!.layoutSectionInsert!
        
        }
    }
    var data:NSMutableArray? {
        didSet{

            let displayData = NSMutableArray()
            
            let width = ScreenWidth
            let height = chatKeyboardHeight - 58
            
            for i in 0..<data!.count {
                let group = data?[i] as! ChatEmojiGroup
                
                if group.count > 0 {
                    group.row = Int((width - margin*2) / (emojiWidth + margin*0.4))
                    group.col = Int(height / (emojiWidth + margin*0.4))
                    group.pageItems = group.row * group.col
                    
                    if let count = group.emojis?.count {
                        group.pages =  count / group.pageItems
                        
                        if count % group.pageItems != 0 {
                            group.pages += 1
                        }
                    }
                    displayData.add(group)
                }
               
                if i == 0 {
                    delegate?.emojiGroupViewGroupChanged(withGroupIndex: i, withGroupPages: group.pages)
                }
                
            }
            
            //: 设置布局
            viewModel = EmojiGroupViewModel(withItemSize: CGSize(width: emojiWidth, height: emojiWidth),withSectionInsert:UIEdgeInsets(top: 0, left: margin*0.8, bottom: 0, right: 0), withMinimumLineSpacing: margin, withMinimumInteritemSpacing: margin*0.4)
            viewModel?.displayData = displayData
            collectionView.reloadData()
        }
    }
    
    
//: 懒加载
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 32, height: 32)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        
        view.dataSource = self
        view.delegate = self
        
        view.scrollsToTop = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEmojiGroupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

//: 私有方法
    private func setupEmojiGroupView() {
        addSubview(collectionView)
        
        //: 注册cell
        registerEmojiCell()
        
        setupEmojiGroupViewSubView()
    }
    
    private func setupEmojiGroupViewSubView() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    
    //: 注册cell
    private func registerEmojiCell() {
        collectionView.register(BaseEmojiCell.self, forCellWithReuseIdentifier: baseCellIndetifier)
        collectionView.register(EmojiFaceCell.self , forCellWithReuseIdentifier: emojiFaceIndetifier)
        collectionView.register(EmojiImageCell.self , forCellWithReuseIdentifier: emojiImageIndetifier)
        collectionView.register(EmojiImageTextCell.self , forCellWithReuseIdentifier: emojiImageTextIndetifier)
    }
//: 开放接口
    func emojiGroupViewDidScrollTo(Pages page:Int) {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: page), at: .left, animated: true)
    }
}

//MARK: 代理方法 - > 
extension EmojiGroupView:UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         let emojis = viewModel?.displayData?[groupIndex] as! ChatEmojiGroup
        return emojis.pages
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emojis = viewModel?.displayData?[groupIndex] as! ChatEmojiGroup
        
        return emojis.pageItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = viewModel?.displayData?[groupIndex] as! ChatEmojiGroup
        
        let item = indexPath.section * group.pageItems + indexPath.row - indexPath.section
        
        let cell:BaseEmojiCell?
        switch group.type! {
        case .Face , .Emoji:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiFaceIndetifier, for: indexPath) as! EmojiFaceCell
            
            if item < group.emojis!.count{
                
                //: 显示删除
                if indexPath.row == group.pageItems - 1 {
                    let emoji = Emoji()
                    emoji.type = .Delete
                    (cell as! EmojiFaceCell).viewModel = EmojiFaceCellViewModel(withEmoji: emoji)
                }
                //: 显示表情
                else {
                    let emoji = group.emojis?[item] as! Emoji
                    (cell as! EmojiFaceCell).viewModel = EmojiFaceCellViewModel(withEmoji: emoji)
                }
                
            }
            else{
                
                if indexPath.row == indexPath.section + group.emojis!.count % group.pageItems {
                    let emoji = Emoji()
                    emoji.type = .Delete
                    (cell as! EmojiFaceCell).viewModel = EmojiFaceCellViewModel(withEmoji: emoji)
                }else{
                    let emoji = Emoji()
                    emoji.type = .Other
                   (cell as! EmojiFaceCell).viewModel = EmojiFaceCellViewModel(withEmoji: emoji)
                }
            }
            
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellIndetifier, for: indexPath) as? BaseEmojiCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let group = viewModel?.displayData?[groupIndex] as! ChatEmojiGroup
         let item = indexPath.section * group.pageItems + indexPath.row - indexPath.section
         var text:String?
         var isDelete:Bool = false
        
        if item < group.emojis!.count {
             if indexPath.row != group.pageItems - 1 {
                let emoji = group.emojis?[item] as! Emoji
                text = emoji.name
                isDelete = false
             }
         else{
                text = ""
                isDelete = true
            }
        }
        else {
            if indexPath.row == indexPath.section + group.emojis!.count % group.pageItems {
                text = ""
                isDelete = true
            }
        }
        
         delegate?.emojiGroupViewDidSelectedEmoji(withItem: item, withEmojiName: text, isDelete: isDelete)
    }
    
}

//MARK: 
extension EmojiGroupView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let group  = viewModel?.displayData?[groupIndex] as! ChatEmojiGroup
        let page = (scrollView.contentOffset.x / scrollView.bounds.width + 0.5).truncatingRemainder(dividingBy: CGFloat(group.pages))
        //: 设置页码
        delegate?.emojiGroupViewDidScrollToPage(withPage: Int(page))
    }
}

protocol EmojiGroupViewDelegate:NSObjectProtocol {
    func emojiGroupViewGroupChanged(withGroupIndex index:Int,withGroupPages pages:Int)
    func emojiGroupViewDidSelectedEmoji(withItem item:Int,withEmojiName text:String?,isDelete delete:Bool)
    func emojiGroupViewDidScrollToPage(withPage page:Int)
}
