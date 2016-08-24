//
//  MainViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    //MARK: - 懒加载属性
    //private  lazy var composeBtn : UIButton = UIButton.creatUIButton("tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
   private lazy var composeBtn : UIButton = UIButton(imageName:"tabbar_compose_icon_add",bgImageName:"tabbar_compose_button")

    override func viewDidLoad() {
        super.viewDidLoad()
       setupComposeBtn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
}




//MARK: - 设置UI界面
extension MainViewController{
    /**
     设置发布按钮
     */
    private func setupComposeBtn(){
        //1、将composeBtn添加到tabbar上
        tabBar.addSubview(composeBtn)
        //2、设置属性
        /*  已经封装
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        composeBtn.sizeToFit()
        */
        
        //3、设置位置
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        //4、监听按钮点击
        // Selector两种写法: 1>Selector("composeBtnClick") 2> "composeBtnClick"
        composeBtn.addTarget(self, action:"composeBtnClick", forControlEvents: .TouchUpInside)
    }
    
    /**
     设置tabar中的items.可以通过storeboard设置高亮图片，并禁止最中间的item点击
     */
    /*
    private func setupTabbarItems(){
        //1、遍历所有的item
        for i in 0..<tabBar.items!.count{
            //2、获取item
            let item = tabBar.items![i]
            //3、如果下标值为2，则该item不可以交互
            if i == 2 {
                item.enabled = false
                continue
            }
            //4、设置其他item的选中时候的图片
            item.selectedImage = UIImage(named: imageNames[i]+"_highlighted")
            
        }
    }
     */
}




//MARK: - 事件监听
extension MainViewController{
    // 事件监听本质发送消息.但是发送消息是OC的特性
    // 将方法包装成@SEL --> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
    // 如果swift中将一个函数声明称private,那么该函数不会被添加到方法列表中
    // 如果在private前面加上@objc,那么该方法依然会被添加到方法列表中
  @objc private func composeBtnClick(){
    let composeVC = ComposeViewController()
    let composeNav = UINavigationController(rootViewController: composeVC)
    presentViewController(composeNav, animated: true, completion: nil)
    
    }
}
































