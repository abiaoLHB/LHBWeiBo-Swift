//
//  VistorView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class VistorView: UIView {

    class func vistorView() -> VistorView{
        return NSBundle.mainBundle().loadNibNamed("VistorView", owner: nil, options: nil).last as! VistorView
    }

    @IBOutlet weak var rotataionView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    func setupVisitorViewInfo(iconName:String,title:String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotataionView.hidden = true
    }
    
    //添加旋转动画
    func addRotationAnimation() -> Void {
        // 创建旋转动画
        //CAKeyframeAnimation(基于frame的动画,有个values属性)
        //CABasicAnimation(基本动画)
        
        //核心动画的问题：当这个view消失时，动画也会消失。view再出来，动画还是没有(可以设置removedOnCompletion =false就可以了)
        
        //1、创建动画 绕着朝向我的z轴转
        let rotatinAni = CABasicAnimation(keyPath : "transform.rotation.z")
        //2、设置动画的属性
        rotatinAni.fromValue = 0
        rotatinAni.toValue = M_PI * 2
        rotatinAni.repeatCount = MAXFLOAT
        rotatinAni.duration = 5.0
        rotatinAni.removedOnCompletion = false
         
        //3、将动画添加到涂层中
        rotataionView.layer.addAnimation(rotatinAni, forKey: nil)
    }
    
   
}

