//
//  UIBarButtonItem-Extension.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /* 第一种做法
    convenience init(lhb_imageName : String) {
            ///快速创建一个UIBarButtonItem
         self.init()
            let btn = UIButton()
            btn.setImage(UIImage(named: lhb_imageName), forState: .Normal)
            btn.setImage(UIImage(named:lhb_imageName + "_highlighted"), forState: .Highlighted)
            btn.sizeToFit()
            customView = btn
        }
     */
        
        //第二种做法
    convenience init(lhb_imageName : String) {
       
        let btn = UIButton()
        btn.setImage(UIImage(named: lhb_imageName), forState: .Normal)
        btn.setImage(UIImage(named:lhb_imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        ///快速创建一个UIBarButtonItem
        self.init(customView:btn)
      }
    
}
