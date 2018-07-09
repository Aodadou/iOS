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
    
    func setImageWithName(imageName:String,with statu:UIControlState) -> Void{
        let imagePath = Bundle.main.resourcePath! + "/" + imageName
        let image = UIImage(contentsOfFile: imagePath)
        self.setImage(image, for: statu)
    }
    
    func setBackImageForStatus(normal:String,highLight:String){
        let bundlePath = Bundle.main.resourcePath! + "/"
        let normalPath = bundlePath + normal
        let highlightPath = bundlePath + highLight
        let imageNormal = UIImage(contentsOfFile: normalPath)
        let imageHightlight = UIImage(contentsOfFile: highlightPath)
        
        self.setBackgroundImage(imageNormal, for: .normal)
        self.setBackgroundImage(imageHightlight, for: .highlighted)
    }
    
}
