//
//  OauthViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/17.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SVProgressHUD

class OauthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 遵守协议，监听webView开始加载，以给用户提示
        webView.delegate = self
        //MARK: - 设置nav
        setupNavBar()
        //MARK: - 加载webView
       loadLoginPage()
    }
}

//MARK: -  设置UI界面相关
extension OauthViewController{
    private func setupNavBar(){
        //1、设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OauthViewController.closeItemClick))
        //2、设置右侧的item
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OauthViewController.fillItemClick))
        //3、设置标题
        navigationItem.title = "登录页面"
    }
    //MARK: - 加载oauth授权页面
    private func loadLoginPage(){//client_id    redirect_uri
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(APP_KEY)&redirect_uri=\(REDIRECT_URL)"
       
        print(urlStr)
        
        guard let url = NSURL(string: urlStr) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
    

    }
}
//MARK: - 事件监听
extension OauthViewController{
    @objc private func closeItemClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //填充
    @objc private func fillItemClick(){
        //1.js代码，因为要改的是webview的输入框
        let jscode = "document.getElementById('userId').value='903803342@qq.com';document.getElementById('passwd').value='caonimaweibo';"
        
        
        
        //"document.getElementById('id').value='903803342@qq.com'";"document.getElementById('passwd').value='caonimaweibo'";
        //2.执行
        webView.stringByEvaluatingJavaScriptFromString(jscode)
        
    }
}


//MARK: - webView的delegate方法
extension OauthViewController:UIWebViewDelegate{
    //开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD .show()
    }
    //加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
         SVProgressHUD.dismiss()
    }
    //加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    //webview准备加载一个网页，都会调用这个方法.然后再调用开始加载页面
    //return true继续加载该页面，return false：不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
    //1、获取加载网页的NSURL
        guard var url = request.URL else{
            return true
        }
    //2、获取url的字符串
        let urlStr = url.absoluteString
        
    //3、判断该字符串中是否包含code
        guard urlStr.containsString("code=") else{
            return true
        }
    //4、截取code
        let codeStr = urlStr.componentsSeparatedByString("code=").last!
      
        
    //5、请求token
        loadAccessToken(codeStr)
        
        return false
    }

}

//MARK: - 请求数据
extension OauthViewController{
    //MARK: - 请求accessToken
   private func loadAccessToken(code : String) -> Void {

        NetworkTools.shareInstance.loadAccessToken(code) { (result, error) in
            /*
                 Optional(["access_token": 2.00gp3LpCszJ68B690a431cc3VfiIjD, "remind_in": 157679999, "uid": 2588568180, "expires_in": 157679999])
             */
            //1、检验错误
            if error != nil{
                print(error)
                return
            }
            //2、拿到结果
            //因为result是可选类型。所有得判断result是否有值
            guard let accountDict = result else{
                print("没有获取到授权后的信息")
                return
            }
            //3、将字典转化成模型对象
            let userAccount = UserAccount(dict: accountDict)
            
            //4、请求用户信息(闭包内调用该对象的方法，需要self)
            self.loadUserInfo(userAccount)
        }
    }
    
    
}


//MARK: - 请求用户信息
extension OauthViewController{

    func loadUserInfo(account : UserAccount) -> Void {
        //1、获取accessToken,别直接传，因为accessToken是可选类型，需要判断有没有
        guard  let accessToken = account.access_token else{
            return
        }
        
        //2、后去uid
        guard let uid = account.uid else{
            return
        }
        
        NetworkTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) in
                if error != nil{
                    return
                }
            //拿到用户信息
            guard let userInfoDict = result else{
                return
            }
            //保存用户头像和用户名，用于登陆界面的展示
            //保存到model一份
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_largeImage = userInfoDict["avatar_large"] as? String
            
            //将account对象持久化（一般sqlit存储）
            
            /*这两句代码已经写成计算属性了
            //获取沙盒路径
            //var accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            //要保存的对象要遵守NSCoding对象,并实现两个协议方法
            //accountPath = (accountPath as NSString).stringByAppendingPathComponent("accout.plist")
             */
            //归档,保存用户信息
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewMdoel.shareInstance.accountPath)
           
            
            //将account对象设置到单例对象中 
            UserAccountViewMdoel.shareInstance.account = account
            //5、推出当前控制器，并显示欢迎界面
//            dismissViewControllerAnimated(false, completion: { 
//                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
//            })
       self.dismissViewControllerAnimated(false, completion: {
        () -> Void in
        UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
       })
         
        }
    }
}























