//
//  PicPickerViewCell.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/26.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    //MARK: - 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    //在这个btn上又盖上了一层uiimageView，因为btn的contentModel只是对image的，不是对backgroudImage的
    @IBOutlet weak var delegatePhotoBtn: UIButton!
    @IBOutlet weak var addImageView: UIImageView!
    
    //MARK: - 定义属性
    var image : UIImage? {
        didSet{
            if image != nil {
                 //addPhotoBtn.setBackgroundImage(image, forState: .Normal)
                addImageView.image = image
                //设置好图片后，按钮不能点击。但是enabled会有灰色萌版
                //addPhotoBtn.enabled = false
                addPhotoBtn.userInteractionEnabled = false
                delegatePhotoBtn.hidden = false
            }else{
                //addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                addImageView.image = UIImage(named: "compose_pic_add")
                addPhotoBtn.userInteractionEnabled = true
                delegatePhotoBtn.hidden = true
            }

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func addPhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerADDPhotoNoti, object: nil)
    }
    
    //MARK: - 删除图片
    @IBAction func delegatePhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerDelePhotoNoti, object: addImageView.image)
    }
    
    
}
