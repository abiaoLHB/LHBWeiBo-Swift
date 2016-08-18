//
//  UserAccountTools.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/18.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
//继承子NSObject有kvc方法
//不继承也没关系，就是没有kvc相关的方法
//class UserAccountTools: NSObject {}

class UserAccountViewMdoel {
    //MARK: - 将类设计成单例
    static let shareInstance : UserAccountViewMdoel = UserAccountViewMdoel()
    
    //MARK: - account类型
    var account : UserAccount?
    
    //MARK: - 计算属性
    var accountPath : String{
        //1、
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        //要保存的对象要遵守NSCoding对象,并实现两个协议方法
        return  (accountPath as NSString).stringByAppendingPathComponent("accout.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        // 读取到是否有过气日期
        guard let expiresDate = account?.expires_date else{
            return false
        }
        // 没过期
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
        
    }
    

    //重写init方法，目的是一创建UserAccountTools就会读区account帐号信息
    init(){
        //2、读取信息(做成属性，防止出了方法销毁)
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
    
    
  /* 该函数也写成了计算属性
    func isLogin() -> Bool {
        if account == nil {
            return false
        }
        // 读取到是否有过气日期
        guard let expiresDate = account?.expires_date else{
            return false
        }
        
        // 没过期
         return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
        
    }
     */
}
