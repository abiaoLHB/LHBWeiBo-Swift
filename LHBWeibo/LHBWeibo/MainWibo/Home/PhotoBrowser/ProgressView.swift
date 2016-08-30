//
//  ProgressView.swift
//  LHBWeibo
//
//  Created by LHB on 16/8/30.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    //MARK: - 定义进度属性
    var xiazaiProgress : CGFloat = 0.0{
        didSet{//进度发生改变
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        //MARK: - 重写drawRect方法
        super.drawRect(rect)
        //创建Bezier曲线
        let center = CGPointMake(rect.width * 0.5, rect.width * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * xiazaiProgress + startAngle
        
        //clockwise: true 是关闭路径
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制到中心点的线
        path.addLineToPoint(center)
        //关闭路径
        path.closePath()
        //颜色填充
        UIColor(white: 1.0, alpha: 0.4).setFill()
        //开始绘制 
        //path.stroke()//绘制空心
        path.fill()//绘制实心
    }
 

}
