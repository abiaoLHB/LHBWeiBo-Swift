//
//  ComposeTextView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/24.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    //MARK: - 懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    
    //从xib加载写这个方法里也行
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    //写这个方法里也行
    override func awakeFromNib() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        
        //设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8)
    }

}
//MARK: - 设置UI界面
extension ComposeTextView{
    
    private  func setupUI(){
        
        font = UIFont.systemFontOfSize(17.0)
    }
}