//
//  HomeTableViewCell.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/19.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SDWebImage

private let  edgeMargin : CGFloat = 15.0  //明确指定类型，类型不匹配无法计算
private let itemMargin : CGFloat = 10.0   //配图之间的间距

class HomeTableViewCell: UITableViewCell {
    //MARK: - 约束属性：微博正文要动态计算，但是如果两边都设置好约束的话，在动态计算会算不准。所以先设置好左边约束，随便给一个宽度，在根据屏幕计算正文的宽度
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var picViewWConstraint: NSLayoutConstraint!
    //距离底部的间距可以调整优先级（因为picview高度为0时，上面的控件），；例如把1000调位700，以消除警告
    @IBOutlet weak var picViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contenLabel: UILabel!
    
    @IBOutlet weak var picCollectionView: PicCollectionView!
 
    
    
    //自定义属性
    var viewModel:StatusViewModel? {
        didSet{
            //1、nil值校验
            guard let viewModel = viewModel else{
                return
            }
            //2、设置头像
            iconImageView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //3、设置认证图标
            verifiedImage.image = viewModel.verifiedImage
            //4、处理昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //5、会员图标
            vipImageView.image = viewModel.vipImage
            //6、设置时间的label
            timeLabel.text = viewModel.creatAtText
            //7、来源
            contenLabel.text = viewModel.status?.text
            //8、设置呢称颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blueColor() : UIColor.orangeColor()
            //9、动态计算配图的宽和高
            let picViewSize = calculatePicViewSize(viewModel.picUrls.count)
            picViewWConstraint.constant = picViewSize.width
            picViewHConstraint.constant = picViewSize.height
            //10、将配图数组传递给PicCollectionView
            picCollectionView.picURLs  = viewModel.picUrls
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //1、设置微博正文的宽度
        contentWidthConstraint.constant = UIScreen.mainScreen().bounds.width - 2*edgeMargin
        //取出picCollectionView的layout,并强制转换成流水布局（不用as?了，因为默认时流水布局）
//        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let imageViewW_H = (UIScreen.mainScreen().bounds.width - 2*edgeMargin - 2 * itemMargin)/3
//        
//        layout.itemSize = CGSize(width: imageViewW_H, height: imageViewW_H)
    }
}

//MARK: - 计算方法
extension HomeTableViewCell{
    private func calculatePicViewSize(count : Int) -> CGSize {
        //1、没有配图
        if count == 0 {
            return CGSizeZero
        }
      
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
        //单张图片
        if count == 1 {
            //取出图片
            let urlStr = viewModel?.picUrls.last?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr)
            
            //设置一张图片时的itemzise
            layout.itemSize = CGSize(width: image.size.width*2.0, height: image.size.height*2.0)
            //获取图片宽高
            //sd会压缩2倍
            //return image.size
            return CGSize(width: image.size.width*2.0, height: image.size.height*2.0)
        }
        
        
        //2、计算出来imageView的宽高 相等
        let imageViewW_H = (UIScreen.mainScreen().bounds.width - 2*edgeMargin - 2*itemMargin)/3
        
        //设置其他张图片layout的size
        layout.itemSize = CGSize(width: imageViewW_H, height: imageViewW_H)
        
        //3、有四张配图
        if count == 4 {
            let picViewWH = imageViewW_H * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //4、其他张配图
        //先计算行数
        let rows = CGFloat((count - 1)/3+1)
        
        //计算picView的高度
        let picViewH = rows * imageViewW_H + (rows-1)*itemMargin
        
        //计算picView的宽度
        let picViewW = UIScreen.mainScreen().bounds.width - 2*edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}




























