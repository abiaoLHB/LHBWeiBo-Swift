//
//  ComposeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/24.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    //MARK: - 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        titleView.becomeFirstResponder()
    }
}

//MARK: - UI界面
extension ComposeViewController{
    //MARK: - 设置发布界面导航栏
   private func setupNavBar() -> Void {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(ComposeViewController.coloseItemBtnClick))
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.title = "发微博"
        navigationItem.titleView = ComposeTitleView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    }
}

//MARK: - 事件监听
extension ComposeViewController{
    //MARK: - 取消发送
    @objc private func coloseItemBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - 发送(要发微博无正文不能点击)
    @objc private func sendItemClick(){
        print("打印")
    }
    
}

//MARK: - UITextView 的代理方法
extension ComposeViewController : UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
}


