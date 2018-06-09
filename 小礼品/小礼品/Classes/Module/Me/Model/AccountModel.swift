//
//  AccountModel.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/25.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import LSXPropertyTool
import QorumLogs

class AccountModel: NSObject,NSCoding {
    
    var id: Int = 0
    //: 用户id
    var uid: String?
    //: 昵称
    var nickname:String?
    //: 头像
    var avatar:String?
    //: 心情寄语
    var say:String?
    //: 性别
    var sex: Int = 0
    //: 账户单例
    static func shareAccount() -> AccountModel? {
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: AccountModel.filePath) as? AccountModel
            
            return userAccount
        }
        else {
            return userAccount
        }
    }
    
    //: 构造方法
    override init() {
        super.init()
    }
    
    
    //: 判断用户是否登陆
    class func isLogin() -> Bool {
        return AccountModel.shareAccount() != nil
    }
    
    //: 注销登录
    class func logout() {
        
        //: 取消第三方登录授权
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeQQ)
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeSinaWeibo)
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
        
        // 清除内存中的账户数据和归档中的数据
        AccountModel.userAccount = nil
        do {
            try FileManager.default.removeItem(atPath: AccountModel.filePath)
        } catch {
            QL4("退出异常")
        }
    }
    
    func saveAccountInfo() {
        AccountModel.userAccount = self
        
        saveAccount()
    }
    
    fileprivate func saveAccount() {
        //: 归档
        NSKeyedArchiver.archiveRootObject(self, toFile: AccountModel.filePath)
    }
    
    // 持久保存到内存中
    fileprivate static var userAccount: AccountModel?
    
    //: 归档账号的路径
    static let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/Account.plist"

    //: 实现归解档的NSCoding代理方法
    func encode(with aCoder: NSCoder){
        aCoder.encode(uid, forKey: "uid_key")
        aCoder.encode(nickname, forKey: "nickname_key")
        aCoder.encode(avatar, forKey: "avatar_key")
        aCoder.encode(say, forKey: "say_key")
        aCoder.encode(sex, forKey: "sex_key")
    }
    
    required  init?(coder aDecoder: NSCoder) {
       uid = aDecoder.decodeObject(forKey: "uid_key") as? String
       nickname = aDecoder.decodeObject(forKey: "nickname_key") as? String
       avatar = aDecoder.decodeObject(forKey: "avatar_key") as? String
       say = aDecoder.decodeObject(forKey: "say_key")  as? String
       sex = aDecoder.decodeInteger(forKey: "sex_key") as Int
    }
    
    //: 账户模型转对外数据模型
    func toUserModel() -> UserModel{
        assert(AccountModel.isLogin(), "用户登陆后才可以获取用户信息！")
        
        let user = UserModel()
        
        user.uid = uid
        user.avatarUrl = avatar
        user.nickname = nickname
        
        return user
    }
}

//MARK: 登陆相关
extension AccountModel {
    /**
     第三方登录
     
     - parameter type:     类型 qq weibo wechat
     - parameter openid:   uid
     - parameter token:    token
     - parameter nickname: 昵称
     - parameter avatar:   头像
     - parameter sex:      性别 0:女 1:男
     - parameter finished: 完成回调
     */
    class func thirdAccountLogin(_ type: String, openid: String, token: String
        , nickname: String, avatar: String, sex: Int
        , finished: @escaping (_ success: Bool, _ tip: String) -> ()) {
        
        let parameters: [String : AnyObject] = [
            "type" : type as AnyObject,
            "identifier" : openid as AnyObject,
            "token" : token as AnyObject,
            "nickname" : nickname as AnyObject,
            "avatar" : avatar as AnyObject,
            "sex" : sex as AnyObject
        ]
        
    
        
        NetworkTools.shared.get(LOGIN, parameters: parameters) { (isSucess, result, error) in
            
            guard let result = result else {
                finished(false, "您的网络不给力哦")
                return
            }
            
            if result["status"] == "success" {
                
                //: 字典转模型
                let account = ExchangeToModel.model(withClassName: "AccountModel", withDictionary: result["result"].dictionaryObject!) as! AccountModel
                //: 存储用户信息
                account.saveAccountInfo()
                
                finished(true,"登陆成功")
            }
            else {
                finished(false,result["message"].stringValue)
            }
        }
        
    }
    
    
    /// 测试
    class func testUpload() {

//        let url0 = "http://www.gzwise.top/etest/exam/paper/enterExamByApp.do?clientType=APP&custId=133460&signStr=36fefeebe63bda7a6e36045d1e7767daf98cc99491d7a467fb285f0d8f9b67a940d3d376ca771a1d8554acfc6b774445bbca88c6e3423525c1debfe556ef0e3e37283ec707e5066a7f18e6384d103903c66ddf7574eba0&equipment=ANDROID*2013022*864312021337666"
//        let dic0 = self.jsonStrToDictionary("{\"state\":\"3\",\"instant\":\"true\",\"entity\":{\"orgId\":\"6073\",\"bizType\":\"KS\",\"ksProPaperId\":\"5308\",\"ksPaperId\":\"36420\",\"bizId\":\"57\",\"bizId2\":\"71\",\"anContent\":{\"ANSWER_5266_563036\":\"1741078\",\"ANSWER_5266_563024\":\"1741030\",\"ANSWER_5265_566127\":\"1748244\",\"ANSWER_5265_566253\":\"1748724\",\"ANSWER_5269_563441\":\"贪图靠近\",\"ANSWER_5267_563407\":\"fillIn\",\"answer_5267_563407_1958\":\"75\",\"ANSWER_5267_563336\":\"fillIn\",\"answer_5267_563336_1834\":\"123\"}}}")
        
        let custom : NSDictionary = [
            "clientType" : "APP",
            "custId" : "133460",
            "signStr" : "36fefeebe63bda7a6e36045d1e7767daf98cc99491d7a467fb285f0d8f9b67a940d3d376ca771a1d8554acfc6b774445bbca88c6e3423525c1debfe556ef0e3e37283ec707e5066a7f18e6384d103903c66ddf7574eba0",
            "equipment" : "ANDROID*2013022*864312021337666",
        ]
        
        let url = "http://www.gzwise.top/etest/exam/paper/enterExamByApp.do"
        if let str = self.dictionaryToJsonStr(custom) {
           let  json = str.prefix(str.lengthOfBytes(using: .utf8) - 1) + "," + "\"state\":\"3\",\"instant\":\"true\",\"entity\":{\"orgId\":\"6073\",\"bizType\":\"KS\",\"ksProPaperId\":\"5308\",\"ksPaperId\":\"36420\",\"bizId\":\"57\",\"bizId2\":\"71\",\"anContent\":{\"ANSWER_5266_563036\":\"1741078\",\"ANSWER_5266_563024\":\"1741030\",\"ANSWER_5265_566127\":\"1748244\",\"ANSWER_5265_566253\":\"1748724\",\"ANSWER_5269_563441\":\"贪图靠近\",\"ANSWER_5267_563407\":\"fillIn\",\"answer_5267_563407_1958\":\"75\",\"ANSWER_5267_563336\":\"fillIn\",\"answer_5267_563336_1834\":\"123\"}}}"
            QL2(json)
            let dic = self.jsonStrToDictionary(json)
            
            NetworkTools.shared.post(url, parameters: dic as? [String : Any]) { (success, data, error) in
                QL2(data)
            }
        }
        
    }

    class func jsonStrToDictionary(_ str:String) -> NSDictionary? {
       let data = str.data(using: .utf8)
        do {
            let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            return dic as? NSDictionary
        }catch {
        
        }
        
        return nil
    }
    
    class func dictionaryToJsonStr(_ dic:NSDictionary) ->String? {
        do {
            
            let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
    
            if let str = String(data: data, encoding: String.Encoding.utf8) {
                var jsonStr = ""
                jsonStr = NSString(string: str).replacingOccurrences(of: " ", with: "")
                jsonStr = NSString(string: str).replacingOccurrences(of: "\n", with: "")
            
                return jsonStr
            }
            
            return nil
        }catch {
            
        }
        
        return nil
    }
}
