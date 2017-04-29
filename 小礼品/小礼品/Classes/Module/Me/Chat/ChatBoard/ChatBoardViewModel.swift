//
//  ChatBoardViewModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit

class ChatBoardViewModel: NSObject {
    //: 转换后的视图模型数据
    var cellViewModels:NSMutableArray = NSMutableArray()
    
    //: 查找数据模型
    func indexForCellModel(_ model:BaseChatCellViewModel,finshed:@escaping (_ index:Int,_ isFind:Bool) ->()){
        
        var hasObject:Bool = false
        var index = 0
        
        for i in 0..<cellViewModels.count {
            let cellModel = cellViewModels[i] as! BaseChatCellViewModel
            if model.isEqualModel(cellModel) {
                hasObject = true
                index = i
            }
        }

        finshed(index,hasObject)

    }
    
    //: 通过ID查找模块
    func indexForCellModel(withID id:String,finshed:@escaping (_ index:Int,_ isFind:Bool) ->()){
        
        var hasObject:Bool = false
        var index = 0
        
        for i in 0..<cellViewModels.count {
            let cellModel = cellViewModels[i] as! BaseChatCellViewModel
            if cellModel.id == id {
                hasObject = true
                index = i
            }
        }
        
        finshed(index,hasObject)
        
    }
    
    //: 更新数据模型
    func updateViewModel(modelID id:String,cellHeight height:CGFloat,findshed:@escaping(_ index:Int,_ isNeedUpdate:Bool) ->()) {
        
        //: 查找视图模型
        
        indexForCellModel(withID:id) { (index, isFind) in
            if isFind {
                let cellModel = self.cellViewModels[index] as! BaseChatCellViewModel
                //: 视图模型是否更新
                if height != cellModel.viewFrame.height {
                    
                    findshed(index, true)
                }
                //: 找到模型并不需要更新视图模型
                else {
                    findshed(index, false)
                }
            }
            //: 没有找到
            else{
                findshed(0, false)
            }
        }
    }
}
