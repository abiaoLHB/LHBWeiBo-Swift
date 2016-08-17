//
//  LHBPresentationController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/17.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class LHBPresentationController: UIPresentationController {
    //MARK: - 对外提供属性
    lazy var presentFrame : CGRect = CGRectZero
    
    //MARK: - 懒加载属性
    private lazy var coverView : UIView = UIView()
    
    //containerView就是容器的view，控制器的view后面的view。model就是把要model的view放在一个容器里面
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //被弹出的view,设置他的尺寸
        presentedView()?.frame = presentFrame
        //添加蒙板
        setupCoverView()
    }

}

extension LHBPresentationController{
   private func setupCoverView(){
    //1、添加蒙板
    containerView?.insertSubview(coverView, atIndex: 0)
    //2、设置萌版的属性
    containerView?.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
    coverView.frame = containerView?.bounds ?? CGRectZero
    //3、添加手势，监听点击
    let tapGes = UITapGestureRecognizer(target: self, action: #selector(LHBPresentationController.coverViewTapClick))
    coverView.addGestureRecognizer(tapGes)
    
    }
}


//MARK: - 点击事件
extension LHBPresentationController{
    @objc private func coverViewTapClick (){
    presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}




