//
//  CustomTitleBtn.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/17.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class CustomTitleBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //OC对象结构体的成员属性是不能修改的，但swift的可以
        titleLabel!.frame.origin.x  = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5

    }
}
