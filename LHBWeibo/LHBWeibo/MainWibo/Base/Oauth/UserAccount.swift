//
//  UserAccount.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/18.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding{
    //MARK: - 属性
    
    ///用户授权的唯一票据
    var access_token : String?
    
    ///access_token的生命周期，单位是秒数。
    var expires_in : NSTimeInterval = 0.0{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    ///授权用户的UID
    var uid : String?
    
    ///额外属性，把expires_in秒转成date
    var expires_date : NSDate?
    
    ///昵称
    var screen_name : String?
    
    ///用户的头像地址
    var avatar_largeImage : String?
    
    
    
    
    
    
    override init() {
    //重写了下面的，在重写这个就不回被覆盖了
    }
    //MARK: - 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        
    }
    //dict有一个要废弃的参数remind_in，没给它设置对应的属性，所以的防治保存
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print("forUndefinedKey:\(key)")
    }
    
    
    //MARK: - 重写description属性.打印该对象时就不是打印类名和内存地址了，而是属性列表
    override var description : String{
        return dictionaryWithValuesForKeys(["access_token","expires_in","uid","expires_date","screen_name","avatar_largeImage"]).description
    }
    
    
    
    /////MARK: - 归档&解当
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token,forKey: "access_token")
        aCoder.encodeObject(uid,forKey: "uid")
        aCoder.encodeObject(expires_date,forKey: "expires_date")
        aCoder.encodeObject(avatar_largeImage,forKey: "avatar_largeImage")
        aCoder.encodeObject(screen_name,forKey: "screen_name")
    }
    
    ///解当
  required  init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_largeImage = aDecoder.decodeObjectForKey("avatar_largeImage") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        
    }
    
}

















