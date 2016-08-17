//
//  BaseViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016 LHB. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    lazy var visitorView : VistorView  =  VistorView.vistorView()
    
    var isLogin : Bool = false
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuUpNavItems()
    }
}



extension BaseViewController{
    ///设置访客试图
    private func setupVisitorView(){
        view = visitorView
        
        visitorView.loginBtn .addTarget(self, action: #selector(BaseViewController.loginBtnClick), forControlEvents: .TouchUpInside)
     
      visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        
    
    }
    ///设置导航栏左右的Item
   private func setuUpNavItems() -> Void {
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title:"注册" ,style:.Plain,target:self,action:#selector(BaseViewController.registerBtnClick))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title:"登录" ,style:.Plain,target:self,action:#selector(BaseViewController.loginBtnClick))
    }
    
}

//MARK: - 事件监听
extension BaseViewController{
   
    @objc private func registerBtnClick() -> Void {
      print("registerBtnClick")
    }
    
    @objc private func loginBtnClick() -> Void {
        print("loginBtnClick")
    }
}
















