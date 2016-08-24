//
//  ComposeTitleView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/24.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    private lazy var titleLabel : UILabel = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ComposeTitleView{
    private func setupTitleView(){
        //1、将子控件添加到view中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //2、设置frame
         titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
        }
        //3、设置属性
        titleLabel.font = UIFont.systemFontOfSize(16)
        screenNameLabel.font = UIFont.systemFontOfSize(13)
        screenNameLabel.textColor = UIColor.lightGrayColor()
        //4、文字内容 
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewMdoel.shareInstance.account?.screen_name
    }
}