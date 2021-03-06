//
//  NetworkTools.swift
//  封装AFN
//
//  Created by LHB on 16/8/17.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import AFNetworking
/*
 Error Domain=com.alamofire.error.serialization.response Code=-1016 "Request failed: unacceptable content-type: text/html
 
 服务器返回数据时，json序列化有一个不支持的格式， text/html导致解析乱码
 
 */

//定义网络请求的枚举类型
enum LHB_RequsetType {
    case GET
    case POST
}
/*
 swift枚举很强大，可以支持字符串类型
 */
enum temp : String {
    case GET = "GET"
    case POST = "POST"
}
enum temppp : Int {
    case GET = 0
    case POST = 1
}



class NetworkTools: AFHTTPSessionManager {
    //一般会设计成单例
    //let是线程安全的
    //这样就是一个单例
    //static let shareInstance : NetworkTools = NetworkTools()
    
    //也可以通过闭包创建
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()//小括号执行闭包
}

//MARK: - 封装请求方法
extension NetworkTools{
  
    func requset(requsetMethodType : LHB_RequsetType, urlStr: String,parameters : [String : AnyObject],finished : (result : AnyObject?,error : NSError?)->()) -> Void {
            //1、定义成功的闭包
            let successCallBack = { (task :NSURLSessionDataTask, result : AnyObject?) in
                finished(result: result, error: nil)
            }
            //2、定义失败的闭包
            let  failureCallBack =  { (task :NSURLSessionDataTask?, error : NSError) in
                finished(result: nil, error: error)
            }
            
            if requsetMethodType == .GET
            {
                GET(urlStr, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
                
            }else{
              POST(urlStr, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            }
        }
}

//MARK: - 请求AccessToken
extension NetworkTools{
    func loadAccessToken(code : String,finished : (result : [String : AnyObject]?,error : NSError?)->()) -> Void {
        //获取请求地址
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //获取请求参数
        let parameters = ["client_id":APP_KEY,"client_secret":APP_SECRET,"grant_type":"authorization_code","code":code,"redirect_uri":REDIRECT_URL]
        
        //发送请求
        requset(.POST, urlStr: urlString, parameters: parameters) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
        
    }
}

//MARK: - 请求用户信息
extension NetworkTools{
    func loadUserInfo(accessToken : String,uid : String,finish :(result: [String :AnyObject]?,error : NSError?)->()) -> Void {
        
        let url : String = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token" : accessToken,"uid":uid]
        
        requset(.GET, urlStr: url, parameters: parameters) { (result, error) in
          
            finish(result: result as? [String:AnyObject], error: error)
    
        }
    }
}

//MARK: - 请求首页数据
extension NetworkTools{
    
    func loadStatues(since_id : Int,max_id : Int,finish : (result : [[String : AnyObject]]?,error : NSError?)->()) -> Void {
        
        //请求地址
        let statuesUrl = "https://api.weibo.com/2/statuses/home_timeline.json"
        //获取请求参数
        let parameters  = ["access_token":(UserAccountViewMdoel.shareInstance.account?.access_token)!,"since_id" : "\(since_id)","max_id" : "\(max_id)"]
        
        //发送请求
        requset(.GET, urlStr: statuesUrl, parameters: parameters) { (result, error) in
           //获取字典
            guard let resultDic = result as? [String : AnyObject] else{
                finish(result: nil, error: error)
                return
            }
            // 将字典中的数组穿出去
            finish(result:resultDic["statuses"] as? [[String : AnyObject]], error: error)
        }
    }
}

//MARK: - 发送微博
extension NetworkTools{
    func sendStats(statusText : String,isSuccess : (isSuccess : Bool)->()){
         //1、获取请求的url
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //2、获取参数parameter
        let postParameter = ["access_token":(UserAccountViewMdoel.shareInstance.account?.access_token)!,"status":statusText]
        
        //3、发送网络请求
        requset(.POST, urlStr: urlString, parameters: postParameter) { (result, error) in
            if(result != nil){
                isSuccess(isSuccess: true)
            }else{
                isSuccess(isSuccess: false)
            }
        }
        
    }
}

//MARK: - 发送微博并携带参数
extension NetworkTools{
    func sendStats(statusText : String,image : UIImage,isSuccess : (isSuccess : Bool)->()){
        
        //1、获取请求的url
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        //2、获取参数parameter
        let postParameter = ["access_token":(UserAccountViewMdoel.shareInstance.account?.access_token)!,"status":statusText]
        
        //3、发送网络请求
      POST(urlString, parameters: postParameter, constructingBodyWithBlock: { (formData) in
        //将图片转成二进制
        //let imageData = UIImagePNGRepresentation(image)//该方法不能压缩
        if let imageData = UIImageJPEGRepresentation(image, 0.5){
            //name传pic，和借口对应
        formData.appendPartWithFileData(imageData, name: "pic", fileName: "随便写.png", mimeType: "image/png")
        }
        
        }, success: { (_, _) in
                isSuccess(isSuccess: true)
        }) { (_, error) in
            isSuccess(isSuccess: false)
            print(error)
        }
    }
    
}













/*
 
 func requset(requsetMethodType : LHB_RequsetType, urlStr: String,parameters : [String : AnyObject],finished : (result : AnyObject?,error : NSError?)->()) -> Void {
 
 if requsetMethodType == .GET
 {
 GET(urlStr, parameters: parameters, progress: nil, success: { (task :NSURLSessionDataTask, result : AnyObject?) in
 finished(result: result, error: nil)
 
 }) { (task : NSURLSessionDataTask?, error : NSError) in
 finished(result: nil, error: error)
 }
 }else{
 POST(urlStr, parameters: parameters, progress: nil, success: { (task : NSURLSessionTask,result : AnyObject?) in
 finished(result: result, error: nil)
 }) { (task :NSURLSessionDataTask?, error : NSError) in
 finished(result: nil, error: error)
 }
 }
 
 }
 */