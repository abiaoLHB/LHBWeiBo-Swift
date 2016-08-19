//
//  UserModel.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/19.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    //MARK: - 属性
    var screen_name : String?        ///用户昵称
    var profile_image_url : String?  ///用户头像
    var verified_type : Int = -1     ///用户认证等级，－1未认证
   
    var mbrank : Int = 0///会员等级 1-6
 
    //也封装到statusViewModel模型里
    //MARK: -  对用户数据处理
    //var verifiedImage : UIImage?
    //var vipImage : UIImage?
    
    
    
    init(dict:[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {

    }
    
    //MARK: - 重写description属性.打印该对象时就不是打印类名和内存地址了，而是属性列表
    override var description : String{
        return dictionaryWithValuesForKeys(["profile_image_url","mbrank","verified_type","screen_name"]).description
    }
    
}
