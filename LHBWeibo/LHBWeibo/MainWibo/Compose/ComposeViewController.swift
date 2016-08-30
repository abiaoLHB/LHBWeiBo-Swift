//
//  ComposeViewController.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/24.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    //MARK: - 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!
    private lazy var emoticonVc : EmoticonController = EmoticonController { [weak self](emoticon) in
    self?.textView.insertEmoticon(emoticon)
        //直接插入图片不回触发代理方法，要手动触发
        self?.textViewDidChange(self!.textView)
    }
    
    
    //选中的照片数组
    private lazy var images : [UIImage] = [UIImage]()
    //展示照片的collectionView
    @IBOutlet weak var picPikerView: PicPickerCollectionView!
    
    //MARK: - 约束的属性
    @IBOutlet weak var toolBarToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setupNavBar()

        //MARK: - 注册通知
        setupNoti()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    //把自己从通知中心移除掉
    deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    //MARK: - 注册通知
    private func setupNoti(){
        
        //监听键盘变化
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        //监听添加照片通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.addPhotoClick), name: PicPickerADDPhotoNoti, object: nil)
        //MARK: - 监听删除照片的通知
         NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ComposeViewController.deletePhototClick(_:)), name: PicPickerDelePhotoNoti, object: nil)
    }
}

//MARK: - 事件监听
extension ComposeViewController{
    //MARK: - 取消发送
    @objc private func coloseItemBtnClick(){
        self.view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 发送微博(要发微博无正文不能点击)
    @objc private func sendItemClick(){
        //0、退出键盘，好看一点
        textView.resignFirstResponder()
        //1、获得要发布的文字
        let statusText = (textView.getEmoticonString())
        
        //1.5、定义回调的闭包
        let finishedCallBack = { (isSuccess : Bool) in
            if !isSuccess{
                SVProgressHUD.showErrorWithStatus("发送微博失败!")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发送成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //2、获取要上船的图片.授权借口职能上船一张图片
        if  let image = images.first {
            //发送带图片的微博
            NetworkTools.shareInstance.sendStats(statusText, image: image, isSuccess:finishedCallBack)
        }else{
            //发送不带图片的微博
            NetworkTools.shareInstance.sendStats(statusText, isSuccess: finishedCallBack)
        }
    }
    //MARK: - 处理键盘
    func keyboardDidChangeFrame(noti : NSNotification) -> Void {
    
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        //键盘高度 NSRect 对应NSVlaue类型
        let endFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        let margin = UIScreen.mainScreen().bounds.height - y
        //改变间距
        toolBarToBottomConstraint.constant = margin
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - 图片选择
    @IBAction func picPickerBtnClick() {
        //退出键盘
        textView.resignFirstResponder()
        //执行动画
        picPickerViewHeightConstraint.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - 删除图片
    @objc private func deletePhototClick(noti : NSNotification){
        //1、校验有没有图片
        guard let image = noti.object as? UIImage else{
            return
        }
        //2、获取image对象所在的下标
        guard let index = images.indexOf(image) else{
            return
        }
        //3、将图片删除
        images.removeAtIndex(index)
        
        //4、给collcetionView的数组重新赋值
        picPikerView.images = images
        
    }
    //MARK: - 表情按钮点击，切换表情键盘
    @IBAction func emoticonBtnclick() {
        //1、必须先退出键盘，才能切换键盘
        textView.resignFirstResponder()
        //2、切换键盘//nil是默认键盘
         textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        //3、在弹出键盘
        textView.becomeFirstResponder()
    }
    
}

extension ComposeViewController{
    //MARK: - 添加照片
    @objc private func addPhotoClick(){
        //1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        //2、创建照片选择控制器
        let pic = UIImagePickerController()
        
        //3、设置照片源 设置代理
        pic.sourceType = .PhotoLibrary
        
        pic.delegate = self
        
        //弹出
        presentViewController(pic, animated: true, completion: nil)
        
        
    }
}
//MARK: - UIImagePickerController的代理
extension ComposeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //1、获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //2、将选中的照片添加到iamges数组
        images.append(image)
        //3、将图片数组赋值给collection，让collection自己去展示数据
        picPikerView.images = images
        //4、退出选择
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//MARK: - UITextView 的代理方法
extension ComposeViewController : UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
}


