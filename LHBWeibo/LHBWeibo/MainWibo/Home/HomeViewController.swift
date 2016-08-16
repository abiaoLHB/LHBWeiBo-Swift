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
        titleBtn.selected = !titleBtn.selected
        // 弹出控制器
        let popoverVC = PopoverViewController()
        //设置控制器的model样式，防止model出来的控制器下面的东西被移除window
        popoverVC.modalPresentationStyle = .Custom
        //弹出
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
}

