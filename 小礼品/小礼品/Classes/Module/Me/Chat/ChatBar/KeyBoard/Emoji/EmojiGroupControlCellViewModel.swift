//
//  EmojiGroupControlCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/6/4.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class EmojiGroupControlModel: NSObject {
    var image:UIImage?
}

class EmojiGroupControlCellViewModel: NSObject {
    var backViewImage:UIImage?
    var backViewHide:Bool
    var lineColor:UIColor?
    var imageViewImage:UIImage?
    
    init(withModel model:EmojiGroupControlModel) {

        backViewImage = #imageLiteral(resourceName: "EmoticonFocus.png")
        imageViewImage = model.image
        lineColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        backViewHide = true
    }
}
