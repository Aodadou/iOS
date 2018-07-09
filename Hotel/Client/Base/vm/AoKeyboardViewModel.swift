//
//  AoKeyboardVM.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/25.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit

class AoKeyboardViewModel: AoBaseViewModel {

    override init() {
        super.init()

    }
    
    func initKeyboard() -> Void {
        let manager = IQKeyboardManager.shared()
        //控制整个功能是否启用。
        manager?.isEnabled = true
        //控制点击背景是否收起键盘
        manager?.shouldResignOnTouchOutside = true
        //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
        manager?.shouldToolbarUsesTextFieldTintColor = true
        //中间位置是否显示占位文字
        manager?.shouldShowTextFieldPlaceholder = true
        //设置占位文字的字体
        manager?.placeholderFont = UIFont.boldSystemFont(ofSize: 17)
        //控制是否显示键盘上的工具条。
        manager?.isEnableAutoToolbar = true
        //某个类中禁止使用工具条
        IQKeyboardManager.shared().disableToolbar(inViewControllerClass: UIViewController.classForCoder())
        
    }
    
}
