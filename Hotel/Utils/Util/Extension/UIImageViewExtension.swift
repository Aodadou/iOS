//
//  File.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/4/20.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func setImageWithFileName(image:String){
        
        let p = Bundle.main.resourcePath
        let path = p! + "/" + image
        self.image = UIImage(contentsOfFile: path)
    }
    
}
