//
//  AppDelegate.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/14.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import QorumLogs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       //: 配置打印
       setupPrintLog()
       //: 配置控制器
       setupRootViewController()
       //: 配置主题样式
       setupGlobalStyle()
       //: 配置系统通知
       setupGlobalNotice()
       //: 配置ShareSDK
       setupShareSDK()
       //: 配置SMSSDK
       setupSMSSDK()
        
        //:测试代码
        AccountModel.testUpload()
        return true
    }
    


}

//MARK: 程序更新
extension AppDelegate {
    //: 使用打印工具
    fileprivate func setupPrintLog() {
        //: 使用调试打印工具
        QorumLogs.enabled = true
        QorumLogs.minimumLogLevelShown = 1
    }
    //: 配置主界面流程
    fileprivate func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = SystemGlobalBackgroundColor
        
        window?.rootViewController = defaultRootViewController()
        
        window?.makeKeyAndVisible()
    }
    
    //: 设置主题样式
    fileprivate func setupGlobalStyle() {
        UITabBar.appearance().tintColor = SystemTabBarTintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        ProgressHUD.setupProgressHUD()
  
    }
    //: 注册系统通知
    fileprivate func setupGlobalNotice() {
        //: 注册系统通知
        NotificationCenter.default.addObserver(self, selector: #selector(changeDefaultRootViewController(notification:)), name: NSNotification.Name(rawValue: SystemChangeRootViewControllerNotification), object: nil)

    }
    
    //: 配置ShareSDK
    fileprivate func setupSMSSDK() {
        SMSSDK.registerApp(SMSSDK_APP_KEY, withSecret: SMSSDK_APP_SECRET)
    }
    
    //: 配置ShareSDK
    fileprivate func setupShareSDK() {
            ShareSDK.registerApp(SHARESDK_APP_KEY, activePlatforms: [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeQQ.rawValue,
                SSDKPlatformType.typeWechat.rawValue], onImport: { (platform : SSDKPlatformType) in
                    switch platform {
                    case SSDKPlatformType.typeWechat:
                        ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    case SSDKPlatformType.typeQQ:
                        ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    case SSDKPlatformType.typeSinaWeibo:
                        ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    default:
                        break
                    }
              //: 
            }){ (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
                
                switch platform {
                case SSDKPlatformType.typeWechat:
                    //: 微信
                    appInfo?.ssdkSetupWeChat(byAppId: WX_APP_ID, appSecret: WX_APP_SECRET)
                    
                case SSDKPlatformType.typeQQ:
                    //: QQ
                    appInfo?.ssdkSetupQQ(byAppId: QQ_APP_ID,
                                         appKey : QQ_APP_KEY,
                                         authType : SSDKAuthTypeBoth)
                    //: Sina微博
                case SSDKPlatformType.typeSinaWeibo:
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: WB_APP_KEY,
                                                appSecret: WB_APP_SECRET,
                                                redirectUri: WB_REDIRECT_URL,
                                                authType: SSDKAuthTypeBoth)
                default:
                    break
                }
                
            }
    }

//MARK: 登陆业务逻辑
    //: 新特性
    func isNewFeatureVersion() -> Bool {
        
        let newVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            as! String
        
        
        //: 旧版本到新版本为升序
        guard let sanboxVersion = UserDefaults.standard.object(forKey: "APPVersion") as? String , sanboxVersion.compare(newVersion) != .orderedAscending else {
            //: 跟新版本
            UserDefaults.standard.set(newVersion, forKey: "APPVersion")
            return true
        }
        
        
        return false
    }
    
    func defaultRootViewController() -> UIViewController {
        
        return MainViewController()
        //: 没有登陆跳转到系统主界面
//        guard LSXUserAccountModel.isLogin() else {
//            return MainViewController()
//        }
//
//        //: 判断是否新版本
//        if isNewFeatureVersion() {
//            return LSXNewFeatureViewController()
//        }
//        
//        //: 跳转到欢迎主界面
//        return LSXWelcomeViewController()
    }
    
    func changeDefaultRootViewController(notification:Notification) {
        
        QL2(notification.userInfo?[ToControllerKey])
        
        
        guard let controllerName = notification.userInfo?[ToControllerKey] as? String else {
            QL4("跳转根控制器失败，传入的控制器名称为空")
            return
        }
        
        guard let controller = UIViewController.controller(withName: controllerName) else {
            QL4("创建控制器失败")
            return
        }
        
        window?.rootViewController = controller
    }
}

extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
     
    }
}
