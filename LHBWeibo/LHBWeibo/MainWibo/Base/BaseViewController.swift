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
//未封装的写法
//    var isLogin : Bool = false
//    已封装的写法
    var isLogin = UserAccountViewMdoel.shareInstance.isLogin
    
    
    override func loadView() {
//      已封装到UserAccountTools中
//        //1、获取沙盒路径
//        var accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
//        accountPath = (accountPath as NSString).stringByAppendingPathComponent("accout.plist")
//        //2、读取信息
//        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
//        //第一种写法
//        //if account != nil {
//        //}
//        //第二种写法：可选绑定
//        if let account = account {//有值进入
//            //取出日期有木有过期
//          if let expiresDate = account.expires_date{
//            //OrderedAscending 升序，后面的大。OrderedDescending降序，前面的大
//            isLogin = (expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending)
//            }
//        }
        
        //
        
        // 判断要加载哪一个view
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
    //登录
    @objc private func loginBtnClick() -> Void {
        let oauthVC = OauthViewController()
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        presentViewController(oauthNav, animated: true, completion: nil)
        
    }
}
















