//
//  HomeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

//https://api.weibo.com/2/statuses/home_timeline .json?access_token=2.00gp3LpCszJ68B690a431cc3VfiIjD
class HomeViewController: BaseViewController {
  
    //MARK: - 懒加载属性
    private lazy var titleBtn : CustomTitleBtn = CustomTitleBtn()
    //创建图片浏览动画类对象，以设置代理
    private lazy var phototBroserAnmitor : PhotoBrowseAnimator = PhotoBrowseAnimator()
    //微博数据源数组
    //封装了视图模型后，就不要存储下面这种模型了
    //private lazy var statusesModelArray:[StatusModel] = [StatusModel]()
    private lazy var statusesViewModelArray:[StatusViewModel] = [StatusViewModel]()
    //提示新微博label
    private lazy var tipLabel : UILabel = UILabel()
    
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
        loasStatues(true)
        
        //4、tableView 根据约束来计算高度，需要设置下面两个属性，estimatedRowHeight是估算高度
        
        //第一种方案
        //根据子控件约束来自动计算父控件高度
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 200
        
        //4、第二种方案
        //设置估算高度（删掉距离最底部的约束）
        tableView.estimatedRowHeight = 200
        
        //系统刷新
        //refreshControl = UIRefreshControl()
        //let demoView = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 40))
        //demoView.backgroundColor = UIColor.yellowColor()
        //refreshControl?.addSubview(demoView)
        
        //5、刷新、加载
        setupHeaderView()
        setupFooterView()
        setupTipLabel()
        setupNotifications()
    }
   
}

//MARK: - 设置UI界面
extension HomeViewController{
    //MARK: - 设置导航栏
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
    
    //MARK: - 设置下拉刷新
    private func setupHeaderView(){
        //1、创建headerView
        let headerView = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.newData))
        //2、设置headerView属性
        headerView.setTitle("下拉刷新", forState: .Idle)
        headerView.setTitle("释放刷新", forState: .Pulling)
        headerView.setTitle("加载中", forState: .Refreshing)
        //3、设置header
        tableView.mj_header = headerView
        //4、开始刷新
        headerView.beginRefreshing()

    }
    
    //MARK: - 设置上拉加载
    private func setupFooterView(){
        //创建footview
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: "moreData")
        
    }
    
    //MARK: - 设置新微博条数提示
    private func setupTipLabel(){
        //1、将tipLabel添加到父控件中
        tipLabel.backgroundColor = UIColor.orangeColor()
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = .Center
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.hidden = true
        //2、frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 32)
    }
    
    //MARK: - 注册通知
    private func setupNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser(_:)), name: ShowPhototBrowserNoti, object: nil)
    }
    
}

//MARK: - 事件监听属性
extension HomeViewController{
    //MARK: - 导航栏用户名点击，转场动画
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
    
    //MARK: - cell图片点击浏览
    @objc private func showPhotoBrowser(noti : NSNotification){
        //0、取出数据
        let indexPath = noti.userInfo![ShowPhototBrowserIndexKey] as! NSIndexPath
        let picURLs = noti.userInfo![ShowPhototBrowserURLsKey] as! [NSURL]
        let object = noti.object as! PicCollectionView//该object就是PicCollectionView对象
        
        //model出控制器
        let browserVc = PhotoBrowserController(indexPath: indexPath, picUrls: picURLs)
        
        //1、为了保证model后面的视图能看到，需要改变model是弹出样式
        browserVc.modalPresentationStyle = .Custom
        //2、设置转场代理
        browserVc.transitioningDelegate = phototBroserAnmitor//必须在本类里遵守协议
        //3、设置动画的代理
        phototBroserAnmitor.presentedDelegate = object
        phototBroserAnmitor.dismissDelegate = browserVc
        //除给indexPath
        phototBroserAnmitor.indexPath = indexPath
        
        presentViewController(browserVc, animated: true, completion: nil)
    }
}

//MARK: - 请求数据
extension HomeViewController{
    //MARK: - 加载最新的数据
    @objc private func newData(){
        loasStatues(true)
    }
    
    @objc private func moreData(){
        loasStatues(false)
        print("moredata")
    }
    
    //MARK: - 记载数据
    private func loasStatues(isNewData : Bool){
        // 获取since_id
        var since_id = 0
        var max_id = 0
        
        if isNewData{
            since_id = self.statusesViewModelArray.first?.status?.mid ?? 0
        }else{
            max_id = self.statusesViewModelArray.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
       NetworkTools.shareInstance.loadStatues(since_id, max_id: max_id) { (result, error) in
        //1、校验
        if error != nil{
            print(error)
            return
        }
        //2、获取可选类型中的数据
        guard let resultArray = result else{
            return
        }
        //3、拿到数据，遍历微博对应的字典数组
        var tempViewModel = [StatusViewModel]()
        for statusDict in resultArray{
            //转模型
            let status = StatusModel(dict: statusDict)
            //self.statusesModelArray.append(status)
            let viewModel = StatusViewModel(status: status)
            tempViewModel.append(viewModel)
        }
        //将数据放入到成员变量的数组中
        if isNewData{
            self.statusesViewModelArray = tempViewModel + self.statusesViewModelArray
        }else{
            self.statusesViewModelArray += tempViewModel
        }
        
        
        //4、缓存图片
        //self.cacheImages(self.statusesViewModelArray)
        //刷新后缓存最新数据就可以了
        self.cacheImages(tempViewModel)
        
        //5、刷新表格
        //self.tableView.reloadData()
        
        

        }
    }
    
    //缓存图片
    private func cacheImages(viewModelsArr : [StatusViewModel]){
        //0、创建group(组)
        let group = dispatch_group_create()
        
        //1、换图图片
        // 这里要下载完所有图片才刷新表格，因为当只有一张图片时，新浪没有返回图片的宽高，只能下载下来获取宽高，然后在刷新表格，显示出来
        //把一个异步操作放在组里，等执行完组里所有的操作，在往下执行。也就是执行完下载后，刷新表格
        for viewModels in viewModelsArr {
            for picURL in viewModels.picUrls {
                //进入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                     
                    //离开组
                    dispatch_group_leave(group)
                })
            }
        }
        // 2、刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            // 停止刷新、加载
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //显示提示的label
            self.showTipLabel(viewModelsArr.count)
            
        }
    }
    
    //MARK: - 显示提示的label
    private func showTipLabel(count : Int){
        //设置tiplabe属性
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "没有新微博" : "\(count) 条新微博"
        //设置动画
        UIView.animateWithDuration(1.0, animations: { 
             self.tipLabel.frame.origin.y = 44
            }) { (_) in
             UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 0
                }, completion: { (_) in
                    self.tipLabel.hidden = true
             })
        }
    }
}
//MARK: - tableView数据源方法
extension HomeViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusesViewModelArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> HomeTableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCellID") as! HomeTableViewCell
      
        cell.viewModel = statusesViewModelArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         //1、获取模型对象
        let viewModel = statusesViewModelArray[indexPath.row]
        return viewModel.cellHeight
        
    }
}














