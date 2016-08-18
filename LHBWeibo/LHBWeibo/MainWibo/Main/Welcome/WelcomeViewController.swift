//
//  WelcomeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/18.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var iconViewToBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //0、设置头像
        let profileUrlStr = UserAccountViewMdoel.shareInstance.account?.avatar_largeImage
        // ?? : 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        // 如果??前面的可选类型为nil,那么直接使用??后面的值
        let url = NSURL(string: profileUrlStr ?? "")
        iconImageView.sd_setImageWithURL(url, placeholderImage:UIImage(named:  "avatar_default_big"))
        
        //1、改变约束的值
        iconViewToBottomConstraint.constant = UIScreen.mainScreen().bounds.height - 200
        //2、执行动画 Damping：阻力系数，阻力系数越大，弹动效果越不明显，取之0-1
        //initialSpringVelocity 初始化速度
        //swift的枚举值，如果不想穿，可以写一个[],穿多个值可以写在中括号里
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
            // 动画结束后，切回住控制器
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    //instantiateInitialViewController就是箭头所指向的控制器
            }
    }
    

}






























