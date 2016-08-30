//
//  UIButton-Extension.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016年 LHB. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 给UIButton扩展，相当于OC的扩展
extension UIButton{
    
    //swift中类方法是以class开头的方法，类似于OC中＋号开头的方法
   /*
        class  func creatUIButton(imageName: String,bgImageName: String) -> UIButton {
            //创建btn
            let btn = UIButton()
            //设置button属性
            btn.setImage(UIImage(named: imageName), forState: .Normal)
            btn.setImage(UIImage(named: imageName+"_highlighted"), forState: .Highlighted)
            
            btn.setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
            btn.setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), forState: .Highlighted)
            
            btn.sizeToFit()
            
            return btn
        }
     */
    
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init (imageName : String,bgImageName:String){
        self.init()
        setImage(UIImage(named:imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
      
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), forState: .Highlighted)
        sizeToFit()

    }
    
    
    
    convenience init(bgColor : UIColor,fontSize : CGFloat,title : String,cornerRadiusSize : CGFloat){
        self.init()
        
        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        if cornerRadiusSize > 0.0  {
            layer.cornerRadius = cornerRadiusSize
            clipsToBounds = true
        }
    }
    
    
}

