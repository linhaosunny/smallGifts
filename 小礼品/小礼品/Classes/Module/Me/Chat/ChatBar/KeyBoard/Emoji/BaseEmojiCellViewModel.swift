//
//  BaseEmojiCellViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/5/14.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class BaseEmojiCellViewModel: NSObject {
    
    var emoji:Emoji?
    
    var hightLightImage:UIImage?
    
    var isShowHightLightImage:Bool?
    
    init(withEmoji emoji:Emoji) {
        self.emoji = emoji
    }
}
