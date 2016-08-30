//
//  PicPickerCollectionView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/26.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

private let cellID = "cellId"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    //数据源数组
    var images : [UIImage] = [UIImage](){
    //监听数组变化
        didSet{
            reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    
        //设置布局
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.mainScreen().bounds.width - 4*edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        //设置内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: edgeMargin, right: edgeMargin)
    
        //注册cell
        registerNib(UINib(nibName: "PicPickerViewCell",bundle: nil), forCellWithReuseIdentifier: cellID)
    
        dataSource = self
    }
    

}

extension PicPickerCollectionView : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1 //(多个1是给添加按钮，否则显示不出来)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PicPickerViewCell
        cell.image = indexPath.item <= images.count-1 ? images[indexPath.item] : nil
        
        return cell
    }
}

