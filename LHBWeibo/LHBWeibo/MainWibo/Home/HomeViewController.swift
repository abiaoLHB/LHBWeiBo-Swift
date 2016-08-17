//
//  HomeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
  
    //MARK: - 懒加载属性
    private lazy var titleBtn : CustomTitleBtn = CustomTitleBtn()
    //注意：在闭包当中如果使用当前对象的属性或者调用方法，也需要加self
    //两个地方需要使用self ：1、如果在一个函数中出现歧义
    //2、在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    private lazy var popoverAnimation : PopoverViewAnimation = PopoverViewAnimation {[weak self](isPresentedCallBack) in
     self?.titleBtn.selected = isPresentedCallBack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1、没有登录时设置的内容
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        //2、设置导航栏的内容
        setupNavBar()
    }
   
}

extension HomeViewController{
    private func setupNavBar(){
    //设置左侧
    navigationItem.leftBarButtonItem = UIBarButtonItem(lhb_imageName: "navigationbar_friendattention")
    //设置右侧
    navigationItem.rightBarButtonItem = UIBarButtonItem(lhb_imageName: "navigationbar_pop")
    //设置中间的titleView
    titleBtn.setTitle("coderWhy", forState: .Normal)
    titleBtn.addTarget(self, action: "titiBtnClick:", forControlEvents: .TouchUpInside)
    navigationItem.titleView = titleBtn
    }
}

//MARK: - 事件监听属性
extension HomeViewController{
    @objc private func titiBtnClick(titleBtn : CustomTitleBtn){
        //这个状态不应有titleBtn.selected来决定，而是有是否要弹出动画来决定按钮图标状态。这时候，popoverAnimation内部发生了什么改变，要穿出来
        //titleBtn.selected = !titleBtn.selected
        
        // 弹出控制器
        let popoverVC = PopoverViewController()
    
        //设置控制器的model样式，防止model出来的控制器下面的东西被移除window
        popoverVC.modalPresentationStyle = .Custom
        //弹出之前要自定义专场动画，设置专场代理
        //popoverVC.transitioningDelegate = self
        //抽出动画代码后，让popoverAnimation对像成为代理
        popoverVC.transitioningDelegate = popoverAnimation
        popoverAnimation.popAnimationFrame =  CGRect(x: 100, y: 55, width: 180, height: 250)

        //弹出
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
}


    
