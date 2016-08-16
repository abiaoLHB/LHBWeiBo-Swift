//
//  ViewController.swift
//  抛出异常
//
//  Created by LHB on 16/8/16.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let pattern = "abc"
        
        do{
            let regex = try NSRegularExpression(pattern: pattern,options: .CaseInsensitive)}catch{
            print(error)}
        
        
        guard let regex = try? NSRegularExpression(pattern: pattern,options: .CaseInsensitive) else{
                return
        }
        
        
        
        
    }


}


































