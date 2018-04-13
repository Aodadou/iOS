//
//  UIButtonExtension.swift
//  YunHai
//
//  Created by WJP on 16/10/19.
//  Copyright © 2016年 WJP. All rights reserved.
//

import Foundation
import UIKit


extension UIButton{
    
    func setBackImageWithName(imageName:String,with statu:UIControlState) -> Void{
        let imagePath = Bundle.main.resourcePath! + "/" + imageName
        let image = UIImage(contentsOfFile: imagePath)
        self.setImage(image, for: statu)
    }
    
}
