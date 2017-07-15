//
//  EmojiGroupViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class EmojiGroupViewModel: NSObject {
    
    var displayData:NSMutableArray?
    
    var layoutItemSize:CGSize?
    
    var layoutSectionInsert:UIEdgeInsets?
    
    var layoutItemMinimumLineSpacing:CGFloat = 0
    
    var layoutItemMinimumInteritemSpacing:CGFloat = 0
    
    
    init(withItemSize size:CGSize,withSectionInsert insert:UIEdgeInsets,withMinimumLineSpacing lineSpace:CGFloat,withMinimumInteritemSpacing interitemSpacing:CGFloat) {
        layoutItemSize = size
        layoutItemMinimumLineSpacing = lineSpace
        layoutItemMinimumInteritemSpacing = interitemSpacing
        layoutSectionInsert = insert
    }
    
}
