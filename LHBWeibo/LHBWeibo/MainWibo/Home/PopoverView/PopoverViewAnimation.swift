//
//  PopoverViewAnimation.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/17.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class PopoverViewAnimation: NSObject {
    //MARK: - 普通属性
    var isPresented = false
    var popAnimationFrame = CGRectZero
    
    //MARK: - 闭包属性
    var callBack : ((isPresentedCallBack : Bool)->())?
    
    //MARK: - 自定义构造函数以给闭包赋值
    //注意：如果自定义了一个构造函数，但是没有对默认构造函数init()进行重写，那么自定义的构造函数会覆盖默认的init()构造函数。所以得先重写init（）
    override init() {
    }
    init(callBack : ((isPresentedCallBack : Bool)->())) {
        self.callBack = callBack
    }
}
//MARK: - 自定义转场代理的方法
extension PopoverViewAnimation : UIViewControllerTransitioningDelegate{
    ///目的：改变弹出view的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        //返回UIPresentationController是系统的，弹出模式和系统的一样
        //要想弹出模式不一样，需要自定义UIPresentationController类
        //return UIPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        let presentation = LHBPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentation.presentFrame = popAnimationFrame
        return presentation
    }
    
    //目的：自定义弹出动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //return self,self必须遵守UIViewControllerAnimatedTransitioning协议
        isPresented = true
        
        //要想调用一个闭包，该闭包必须是有值的，不能是可选类型.需要强制解包
        callBack!(isPresentedCallBack : isPresented)
        
        return self
    }
    
    //目的：自定义消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresentedCallBack : isPresented)

        return self
    }
    
}

//MARK: - 弹出和消失动画代理的方法
extension PopoverViewAnimation:UIViewControllerAnimatedTransitioning{
    
    //动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    //获取转场的上下文, 可以通过转场的上下文获取弹出的view和消失的view
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    //自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        //1、获取弹出的view
        //key有两个东西：UITransitionContextFromViewKey, and UITransitionContextToViewKey
        //UITransitionContextFromViewKey获取消失的view
        //UITransitionContextToViewKey 获取弹出的view
        let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        //2、自定义转场:将弹出的view添加到containerView中（自定义需要自己添加，系统不会添加了）
        transitionContext.containerView()?.addSubview(presentView)
        //3、执行动画:缩放比例x轴不要变(此时锚点在presentView的中间)
        presentView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        //设置锚点
        presentView.layer.anchorPoint = CGPointMake(0.5, 0)
        
        //animateWithDuration可以直接写时间。为了和上面的时间统一，这里掉了下上面的方法，正好返回一个时间
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            //恢复最初的状态
            presentView.transform = CGAffineTransformIdentity
        }) { (_) in//_下划线位置本来有个bool值，不用的话可以写成下划线，也可以起个别名，系统会自动推出它的类型
            //动画执行完毕，必须告诉上下问你已经完成了动画
            transitionContext.completeTransition(true)
        }
        
    }
    
    //自定义消失动画
    private func animationForDismissedView(transitionContext:UIViewControllerContextTransitioning){
        //1、获取消失的view
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        //2、执行动画
        //        UIView.animateWithDuration(transitionDuration(transitionDuration(transitionContext)), animations: {
        //            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
        //            }) { (_) in
        //                dismissView?.removeFromSuperview()
        //                transitionContext.completeTransition(true)
        //        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
    
    
    
}
