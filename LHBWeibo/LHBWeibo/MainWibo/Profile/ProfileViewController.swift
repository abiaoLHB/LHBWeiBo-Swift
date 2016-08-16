//
//  ProfileViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/15.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVisitorViewInfo("visitordiscover_image_profile", title: "登录    后，你的微博、相册、个人资料会在这里，展示给别人")
    }
    
}
