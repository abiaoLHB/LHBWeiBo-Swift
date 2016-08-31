//
//  PhotoBrowseAnimator.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/31.
//  Copyright © 2016年 LHB. All rights reserved.
//  专门用来管理图片浏览的动画

import UIKit

//MARK: - 面向协议开发 根据我提供的参数，让外界给我给我提供数据
protocol AnimatorPresetnecDelegate : NSObjectProtocol{
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}

protocol  AnimatorDismisDelegate : NSObjectProtocol {
    func disIndexPath() -> NSIndexPath
    
    func disImageView() -> UIImageView
}


class PhotoBrowseAnimator: NSObject {

    var isPresented : Bool = false
    
    //MARK: - 代理属性
    var presentedDelegate : AnimatorPresetnecDelegate?
    var dismissDelegate : AnimatorDismisDelegate?
    
    var indexPath : NSIndexPath?
}

//遵守完UIViewControllerTransitioningDelegate协议，就可以自定义转场了
extension PhotoBrowseAnimator : UIViewControllerTransitioningDelegate{
    //弹出动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self//return self 又必须遵守UIViewControllerAnimatedTransitioning协议，所以还得写个extension
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

//MARK: - 消失和弹出都会执行下面的动画
extension PhotoBrowseAnimator : UIViewControllerAnimatedTransitioning{//两个方法必须实现，否则报错
    //MARK: - 方法一：动画执行时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationforPresentecView(transitionContext) : animatonFordismisiew(transitionContext)
    }
    
    //MARK: - 弹出动画
    //单独抽一个方法执行弹出动画
    func animationforPresentecView(transitionContext: UIViewControllerContextTransitioning) -> Void {
       //0、nil值校验
        guard let presentedDelegate = presentedDelegate,indexPath = indexPath else {
            return
        }
        //1、取出弹出的view
        let prensentdView = transitionContext.viewForKey(UITransitionContextToViewKey)!//UITransitionContextFromViewKey
        //2、将prensentdView添加到容器视图：containerView中
        transitionContext.containerView()?.addSubview(prensentdView)
        //3、获取执行动画的iamgeview
        let startRect = presentedDelegate.startRect(indexPath)
        let imageView = presentedDelegate.imageView(indexPath)
        transitionContext.containerView()?.addSubview(imageView)
        imageView.frame = startRect
    
        //4、执行动画
        prensentdView.alpha = 0.0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect(indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            prensentdView.alpha = 1.0
            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
            //必须告诉上下文动画执行完毕了
            transitionContext.completeTransition(true)
        }
    }
    
    //MARK: - 消失动画
    //单独抽一个方法执行消失动画
    func animatonFordismisiew(transitionContext: UIViewControllerContextTransitioning) -> Void {
       //nil值校验
        guard let dismissDelegate = dismissDelegate,presentedDelegate = presentedDelegate else{
            return
        }
        //1、取出消失的view
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        dismissView?.removeFromSuperview()
        //2、获取执行动画的imageView
        let imageview = dismissDelegate.disImageView()
        transitionContext.containerView()?.addSubview(imageview)
        let indexPath = dismissDelegate.disIndexPath()
    
        //3、执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 

            imageview.frame = presentedDelegate.startRect(indexPath)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
        
    }
    
}










//一下是淡出淡入效果
/*
 //遵守完UIViewControllerTransitioningDelegate协议，就可以自定义转场了
 extension PhotoBrowseAnimator : UIViewControllerTransitioningDelegate{
 //弹出动画
 func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 isPresented = true
 return self//return self 又必须遵守UIViewControllerAnimatedTransitioning协议，所以还得写个extension
 }
 func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 isPresented = false
 return self
 }
 }
 
 //MARK: - 消失和弹出都会执行下面的动画
 extension PhotoBrowseAnimator : UIViewControllerAnimatedTransitioning{//两个方法必须实现，否则报错
 //MARK: - 方法一：动画执行时间
 func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
 return 0.5
 }
 
 
 func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
 isPresented ? animationforPresentecView(transitionContext) : animatonFordismisiew(transitionContext)
 }
 
 //单独抽一个方法执行弹出动画
 func animationforPresentecView(transitionContext: UIViewControllerContextTransitioning) -> Void {
 //1、取出弹出的view
 let prensentdView = transitionContext.viewForKey(UITransitionContextToViewKey)!//UITransitionContextFromViewKey
 //2、将prensentdView添加到容器视图：containerView中
 transitionContext.containerView()?.addSubview(prensentdView)
 //3、执行动画
 prensentdView.alpha = 0.0
 UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
 prensentdView.alpha = 1.0
 }) { (_) in
 //必须告诉上下文动画执行完毕了
 transitionContext.completeTransition(true)
 }
 }
 //单独抽一个方法执行消失动画
 func animatonFordismisiew(transitionContext: UIViewControllerContextTransitioning) -> Void {
 //1、取出消失的view
 let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
 //2、执行动画
 UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
 dismissView?.alpha = 0.0
 }) { (_) in
 dismissView?.removeFromSuperview()
 transitionContext.completeTransition(true)
 }
 
 }
 
 }
 */






