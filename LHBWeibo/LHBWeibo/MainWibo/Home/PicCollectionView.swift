//
//  PicCollectionView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/19.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

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
        //发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhototBrowserNoti, object: nil, userInfo: userInfo)
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




