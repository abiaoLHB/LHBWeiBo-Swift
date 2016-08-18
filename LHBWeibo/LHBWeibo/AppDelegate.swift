//
//  AppDelegate.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//
/*
 该项目支持iOS9.0及其以上版本
 因为用了iOS9.0的新特性之一：storyBoardRefactor
 
 静态库分两种：.a 和 .framework 
 .framework又有两种：静态和动态
 swift用的是.framework的动态库
 */

//Othe授权
//App Key：1321090536
//App Secret：cdcbf3092f56d5dfe836162905879c54
//回调地址：http://luohongbiaooauth.com
//https://api.weibo.com/oauth2/authorize?client_id=1321090536&redirect_uri=http://luohongbiaooauth.com




import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var defaultVC : UIViewController?{
            let isLogin = UserAccountViewMdoel.shareInstance.isLogin
            return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
        
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        //纯代码方案
        //window = UIWindow(frame:UIScreen.mainScreen().bounds)
        //window?.backgroundColor = UIColor.whiteColor()
        //window?.rootViewController = MainViewController()
        //window?.makeKeyAndVisible()
        
        
        //不从MainStoryboard加载，因为当程序打开时，也要显示的是欢迎界面.所以自己创建window
        //所以在上面写一个计算属性
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

