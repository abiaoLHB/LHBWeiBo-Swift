//
//  HomeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
//https://api.weibo.com/2/statuses/home_timeline .json?access_token=2.00gp3LpCszJ68B690a431cc3VfiIjD
class HomeViewController: BaseViewController {
  
    //MARK: - 懒加载属性
    private lazy var titleBtn : CustomTitleBtn = CustomTitleBtn()
    //微博数据源数组
    //封装了视图模型后，就不要存储下面这种模型了
    //private lazy var statusesModelArray:[StatusModel] = [StatusModel]()
    private lazy var statusesViewModelArray:[StatusViewModel] = [StatusViewModel]()
    
    
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
        
        //3、获取微博数据
        loasStatues()
    }
   
}

//MARK: - 设置界面
extension HomeViewController{
    private func setupNavBar(){
    //设置左侧
    navigationItem.leftBarButtonItem = UIBarButtonItem(lhb_imageName: "navigationbar_friendattention")
    //设置右侧
    navigationItem.rightBarButtonItem = UIBarButtonItem(lhb_imageName: "navigationbar_pop")
    //设置中间的titleView
    titleBtn.setTitle(UserAccountViewMdoel.shareInstance.account?.screen_name, forState: .Normal)
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

//MARK: - 请求数据
extension HomeViewController{
    private func loasStatues(){
        NetworkTools.shareInstance.loadStatues { (result, error) in
            //校验
            if error != nil{
                print(error)
                return
            }
            //获取可选类型中的数据
            guard let resultArray = result else{
                return
            }
            //拿到数据，遍历微博对应的字典数组
            for statusDict in resultArray{
                //转模型
                let status = StatusModel(dict: statusDict)
                //self.statusesModelArray.append(status)
                let viewModel = StatusViewModel(status: status)
                self.statusesViewModelArray.append(viewModel)
            }
        //刷新表格
            self.tableView.reloadData()
            
        }
    }
}
//MARK: - tableView数据源方法
extension HomeViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusesViewModelArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCellID")!
        
        let statusViewModel = statusesViewModelArray[indexPath.row]
        
        cell.textLabel?.text = statusViewModel.sourceText
        
        
        return cell
    }
}














