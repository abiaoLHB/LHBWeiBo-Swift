//
//  纯代码方案.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class _____: NSObject {

}


//extension NSObject{
//    
//    
//    //        addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
//    //         addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
//    //         addChildViewController("DiscoverViewController", title: "发现", imageName: "tabbar_discover")
//    //         addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
//    
//    //从json文件读取控制器
//    //1、获取json文件的路径
//    guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else{
//    print("没有获取到对应文件的路径")
//    return
//    }
//    
//    //2、读取json文件中的内容
//    guard let jsonData = NSData(contentsOfFile: jsonPath) else {
//    print("没有获取到json文件中的数据")
//    return
//    }
//    
//    //3、data转成数组 [[String : AnyObject]] 表示数组里面放的字典
//    guard let anyobject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else{
//    return
//    }
//    
//    guard let dicArr = anyobject as? [[String : AnyObject]] else{
//    return
//    }
//    
//    //4、遍历字典。获取对应的信息
//    for dict in dicArr {
//    //4.1获取控制器的对应的字符串
//    guard let vcName = dict["vcName"] as? String else{
//    continue
//    }
//    //4.1获取控制器显示的title
//    guard let title = dict["title"] as? String else{
//    continue
//    }
//    //4.3获取控制器显示的图标名称
//    guard let imageName = dict["imageName"] as? String else{
//    continue
//    }
//    
//    addChildViewController(vcName, title: title, imageName: imageName)
//    
//    }
//    
//    
//    
//}
//private func addChildViewController(childVCName : String,title : String,imageName : String){
//    
//    //0、获取命名空间(转成字符串类型的可选类型)
//    guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else{
//        print("拿不到命名空间")
//        return
//    }
//    print(nameSpace)
//    //1、根据字符串获取到对应的class
//    
//    guard let childVCClass = NSClassFromString(nameSpace + "." + childVCName) else{
//        print("没有获取到对应的class")
//        return
//    }
//    
//    //2、将对应的anyObject转成控制器的类型
//    guard let childVCType = childVCClass as? UIViewController.Type else{
//        return
//    }
//    
//    //3、创建对应的控制器对象
//    let childVC = childVCType.init()
//    
//    //4、设置属性
//    childVC.title = title
//    childVC.tabBarItem.title = title
//    childVC.tabBarItem.image = UIImage(named:imageName)
//    childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
//    
//    //5、包装导航控制器
//    let childNav = UINavigationController(rootViewController:childVC)
//    
//    //6、添加控制器
//    addChildViewController(childNav)
//    
//}
