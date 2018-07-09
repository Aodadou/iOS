//
//  AoBaseNavigationController.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/25.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit

class AoBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = .white
        self.setNavBackColor(color: mainTintColor)
        self.setNavTitleColor(color: .white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setTitle(title:String){
        self.title = title
    }
    
    func setNavBackColor(color:UIColor){
        self.navigationBar.barTintColor = color
    }
    
    func setNavTitleColor(color:UIColor){
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:color,
                                                  NSFontAttributeName : UIFont.systemFont(ofSize: 19)]
    }
    

}


extension UINavigationController{
    
    func setLeftItem(image:UIImage?,title:String?,target:Any?,action:Selector?){
        if image == nil{
            let leftItem = UIBarButtonItem(image: image, style: .plain, target: target, action:action)
            self.navigationItem.leftBarButtonItem = leftItem
        }else{
            let leftItem = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
            self.navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    func setRightItem(image:UIImage?,title:String?,target:Any?,action:Selector?){
        if image == nil{
            let rightItem = UIBarButtonItem(image: image, style: .plain, target: target, action:action)
            self.navigationItem.rightBarButtonItem = rightItem
        }else{
            let rightItem = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }
    
}
