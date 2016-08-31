//
//  PicCollectionView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/19.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    //MARK: - 定义属性 (一般可变数组直接创建出来就行了)
    var picURLs : [NSURL] = [NSURL]() {
        didSet{
            self.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //不建议自己设置为自己为代理，而是cell要展示数据，让cell成为UICollectionView的代理，这里为了封装，就让自己成为自己的代理。storyBoard中脱线设置自己为代理是不行的，只能用代码
        dataSource = self
        delegate = self
    }

}
//MARK: - UICollectionView 代理方法
extension PicCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //在stroyboard中注册cell了
        //1、获取cell
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCellID", forIndexPath: indexPath) as! picViewCollectionCell
        
        //2、 给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //当这张图片被点击时，告诉控制器，并传递一些必要参数
        let userInfo = [ShowPhototBrowserIndexKey:indexPath,ShowPhototBrowserURLsKey :picURLs]
        //发出通知 object 把自己发出去，好设置phtotbrwserAnimator的代理
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhototBrowserNoti, object: self, userInfo: userInfo)
    }
}


/*
  自定义一个类，swift和OC都支持在一个类里面创建多个类。这里是自定义cell。如果比较复杂，可以新建一个文件，继承自UICollectionViewCell，这事比较常用的做法。而这里这样自定义类也行。因为这个cell比较简单，里面就一个图片，所以就用这个自定义的cell去管理storyboard中的UICollectionView中自带的cell，给这个cell添加一个imageView就行了
 */
class picViewCollectionCell : UICollectionViewCell{
    
    //MARK: - 定义模型属性
    var picURL : NSURL?{
        didSet{
            guard let picURL = picURL else{
                return
            }
            iconImageView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    //MARK: - 控件的属性
    @IBOutlet weak var iconImageView: UIImageView!
    
}


//给PhotoBrowseAnimator 提供图片的开发位置、结束位置等
extension PicCollectionView : AnimatorPresetnecDelegate{
    func startRect(indexPath: NSIndexPath) -> CGRect {
        //1、必须先获取到cell
        let cell = self.cellForItemAtIndexPath(indexPath)!
        //2、获取到cell的frame，不是相对于cell父控件collectinView的frame,而是相对于这个控制器视图的frame，所以得做frame转化
        let startFrame = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        //1、获取个位置的image对象
        let picUrl = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        //2、计算结束后的frame
        let x : CGFloat = 0
        var y : CGFloat = 0
        let w = UIScreen.mainScreen().bounds.width
        let height : CGFloat = w / CGFloat(image.size.width) * CGFloat(image.size.height)
        if height > UIScreen.mainScreen().bounds.height {//  大图
            y = 0.0
        }else{//小图
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        

        return CGRectMake(x, y, w, height)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        
        //1、创建UIImageView对象
        let imageView = UIImageView()
        
        //2、获得该位置的image对象
        let picUrl = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        // 3、设置图片、属性
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

