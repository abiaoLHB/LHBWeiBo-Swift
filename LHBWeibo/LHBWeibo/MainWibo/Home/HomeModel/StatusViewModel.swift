//
//  StatusViewModel.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/19.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

//视图模型：对某一个模型进行封装,这里是对statusModel进行封装

class StatusViewModel: NSObject {
    
    //MARK: - 定义属性 
    var status : StatusModel?
    
    //属性处理属性，像source属性，新浪返回source不能直接展示"source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>"，所以得用另一属性属性处理，上面做属性监听
    var sourceText : String?
    var creatAtText : String?
    
    //用户模型里的两个属性
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    //额外属性：目的是简化一些获取值的长度
    var profileURL : NSURL? ///处理头像
    var cellHeight : CGFloat = 0        //cell高度
    var picUrls : [NSURL] = [NSURL]() //处理微博配图，初始化数组
    
    
    // 自定义构造函数，要想创建statusViewModel，必须传进来一个要封装的model，否则没意义
    init(status : StatusModel) {
        //把传进来的model给属性赋值
        self.status = status
        
        //对微博来源进行处理
        //nil值校验  where相当于&&。。。。这里就不能用guard了
//        guard let source = source  where source != "" else{
//            return
//        }
        
        //1、处理来源
        if let source = status.source where source != ""  {
            //从哪里截取
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            //截取多长
            let lengh = (source as NSString).rangeOfString("</").location - startIndex
            //截取
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: lengh))
   
        }
        
        //2、处理时间
        if let creatAt = status.created_at {
            creatAtText = NSDate.createDateString(creatAt)
        }
        
        //3、处理认证 如果??前面的值为空，就取-1
        let verifiedType = status.user?.verified_type ?? -1
            switch verifiedType {
                case 0://个人认证
                    verifiedImage = UIImage(named: "avatar_vip")
                case 2,3,5://企业认证
                    verifiedImage = UIImage(named: "avatar_enterprise_vip")
                case 220://微博达人
                    verifiedImage = UIImage(named: "avatar_grassroot")
                default:
                    verifiedImage = nil
            }
        // 4、处理会员等级
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //5 、处理头像url
        let profiledUrlStr = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profiledUrlStr)
        
        //6、处理配图数据 
        //获取配图数组
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        
        if let picURLDicts = picURLDicts {
             //遍历配图字典数组
            for picURLDict in picURLDicts {
                guard  let picURLStr = picURLDict["thumbnail_pic"] else{
                    continue
                }
                print("picURLStr:\(picURLStr)")
                picUrls.append(NSURL(string: picURLStr)!)
            }
        }
        
    }

}






















