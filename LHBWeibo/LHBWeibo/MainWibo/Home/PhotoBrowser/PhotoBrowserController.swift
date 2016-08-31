//
//  PhotoBrowserController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/30.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    //MARK: - 自定义属性
    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    //MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserCollectionLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "关 闭", cornerRadiusSize: 5.0)
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "保  存", cornerRadiusSize: 5.0)
    
    //MARK: - 自定义构造函数
    init(indexPath : NSIndexPath,picUrls : [NSURL]){
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        //别用bouns
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - 设置UI界面
        setupUI()
        //MARK: - 滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
}




extension PhotoBrowserController{
    
    private func setupUI(){
        //1、添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //2、设置frame
        collectionView.frame = view.bounds
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSizeMake(90, 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
   
        //3、设置collectionView的属性 
        collectionView.registerClass(PhotoBrowseViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //4、监听关闭、保存按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), forControlEvents: .TouchUpInside)
    }
}

//MARK: -  事件监听
extension PhotoBrowserController{
    //MARK: - 关闭按钮点击
    @objc private func closeBtnClick(){
        print("关闭按钮被点击")
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - 保存按钮点击
    @objc private func saveBtnClick(){
        //获取当前正在显示的image
        // 当前显示cell
        let cell = collectionView.visibleCells().first as! PhotoBrowseViewCell
        guard let image = cell.imageView.image else{return}
        //保存
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
     //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image :UIImage,didFinishSavingWithError : NSError?,contextInfo : AnyObject){
        var showInfo = ""
        if didFinishSavingWithError != nil{
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfoWithStatus(showInfo)
    }
}

extension PhotoBrowserController : UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1、创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCell, forIndexPath: indexPath) as! PhotoBrowseViewCell
        //2、给cell设置数据
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        return cell
        
    }
    

    
}

class PhotoBrowserCollectionLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
         super.prepareLayout()
        //设置itemsize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumLineSpacing = 0
        //设置属性
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
      
    }
}



extension PhotoBrowserController : PhotoBrowserViewCellDelegate{

    func imageViewClick() {
        closeBtnClick()
    }
}



//MARK: - 遵守协议，实现消失动画
extension PhotoBrowserController : AnimatorDismisDelegate{
   
    func disIndexPath() -> NSIndexPath {
        //获取当前正在显示的indexpath
        let cell = collectionView.visibleCells().first!
        
        return collectionView.indexPathForCell(cell)!
    }
    
    //实现代理方法
    func disImageView() -> UIImageView {
        //1、创建UIImagView对象
        let imageView = UIImageView()
        //2、设置imageview的frame
        let cell = collectionView.visibleCells().first! as! PhotoBrowseViewCell
        
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        //3、设置imageview的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }

}


























