//
//  PhotoBrowseViewCell.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/30.
//  Copyright © 2016年 LHB. All rights reserved.
// 怎样自定义一个cell

import UIKit
import SDWebImage

//代理协议
protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick();
}

class PhotoBrowseViewCell : UICollectionViewCell {
    //MARK: - 定义属性
    var picUrl : NSURL?{
        didSet{
            setupContent(picUrl)
        }
    }
    //代理属性
    var delegate : PhotoBrowserViewCellDelegate?
    
    //MARK: - 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    private lazy var progressView : ProgressView = ProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowseViewCell{
    
    private func setupUI(){
        //1、添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(progressView)
        //2、设置子控件frame
        scrollView.frame = contentView.bounds
        // 控制器的view加了20，这里减回来
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRectMake(0, 0, 50, 50)
        progressView.center = CGPointMake(UIScreen.mainScreen().bounds.width * 0.5,UIScreen.mainScreen().bounds.height * 0.5)
        //3、
        progressView.backgroundColor = UIColor.clearColor()
        progressView.hidden = true
        
        //4、监听imageView的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowseViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.userInteractionEnabled = true
    }
}
//MARK: -  事件监听
extension PhotoBrowseViewCell{
    @objc private func imageViewClick(){
        //通知代理
        delegate?.imageViewClick()
        
    }
}

extension PhotoBrowseViewCell{
    private func setupContent(picUrl : NSURL?){
        guard let picUrl = picUrl else{ return }
        //拿到iamge
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        //设置imageView的frame
        let x : CGFloat = 0
        let width = UIScreen.mainScreen().bounds.width
        let height = width / image.size.width * image.size.height
        var y : CGFloat = 0
        
        if height > UIScreen.mainScreen().bounds.size.height {
            y = 0
        }else{
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        imageView.frame = CGRectMake(x, y, width, height)
        
        //设置iamgeView的大图片
        progressView.hidden = false
        imageView.sd_setImageWithURL(getBigUrl(picUrl), placeholderImage: image, options: [], progress: { (current, total) in
                self.progressView.xiazaiProgress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                 self.progressView.hidden = true
        }
        
        // 设置scrollView的contentSize
        scrollView.contentSize = CGSizeMake(0, height)
    }
    
    private func getBigUrl(smallUrl : NSURL) -> NSURL{
        let samll = smallUrl.absoluteString
        let  bigUrlStr = samll.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: bigUrlStr)!
    }

}
