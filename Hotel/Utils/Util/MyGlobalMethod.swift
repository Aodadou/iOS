
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let mainWindow = UIApplication.shared.keyWindow
let overlay = UIView(frame: mainWindow!.bounds)


let isRetina = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode!.size) : false

let mainTintColor = UIColor(red: 57.0/255, green: 161.0/255, blue: 232.0/255, alpha: 1.0)
let selectTfColor = UIColor(red: 162/255.0, green: 162/255.0, blue: 162/255.0, alpha: 1)
let noSelectTfColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1)
let backColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
let sceneModeTextColor = UIColor(red: 158 / 255.0, green: 176/255.0, blue: 192/255.0, alpha: 1.0)

class MyGlobalMethod: NSObject {

    class func addImageCutView(_ cropImageView:UIView){
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.backgroundColor = UIColor.black
        
        mainWindow?.addSubview(cropImageView)
    }
    
//    class func removeImageCutView(){
//        
//        let mainWindow = UIApplication.sharedApplication().keyWindow
//        for view in mainWindow!.subviews{
//            if view.tag == 1113{
//                
//                //JNW缩放
//                let scale = JNWSpringAnimation(keyPath: "transform.scale")
//                //设置阻尼值，阻尼越小，弹得幅度越大
//                scale.damping = 10
//                //弹性系数越大，弹得越久
//                scale.stiffness = 200
//                //设置质量，质量越小播放速度越快
//                scale.mass = 1
//                scale.fromValue = 1
//                scale.toValue = 0.7
//                view.layer.addAnimation(scale, forKey: scale.keyPath)
//                //JNWSpringAnimation最后会还原初始值，这里手动改变结束状态
//                view.transform = CGAffineTransformMakeScale(0.7, 0.7)
//                
//                UIView.animateWithDuration(0.5, delay: NSTimeInterval(0.5), options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//                        view.alpha = 0
//                    }, completion: { (finish) -> Void in
//                        view.removeFromSuperview()
//                })
//                
//                let minseconds = 0.5 * Double(NSEC_PER_SEC)
//                let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
//                dispatch_after(dtime, dispatch_get_main_queue(), {
//                    view.removeFromSuperview()
//                })
//                
//            }
//        }
//    }
//    
    class func showAlert(_ alertView:UIView){
        let mainWindow = UIApplication.shared.keyWindow
        //遮挡层
        let overlayView = UIView(frame: mainWindow!.bounds)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.5
        overlayView.tag = 1111
        mainWindow?.addSubview(overlayView)
        
        //警告框
        alertView.alpha = 0
        alertView.tag = 1112
        //alertView.transform = CGAffineTransformMakeScale(1.2, 1.2)
        mainWindow?.addSubview(alertView)
        alertView.layer.cornerRadius = 10
        
        //阴影设置
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 5, height: 5)
        alertView.layer.shadowOpacity = 0.8
        alertView.layer.shadowRadius = 10
        
        //设置延时执行的时间为1秒
        let minseconds = 0.01 * Double(NSEC_PER_SEC)
        let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                alertView.alpha = 1
                }, completion: nil)
            //JNW动画,出现
            let scale1 = JNWSpringAnimation(keyPath: "transform.scale")
            scale1?.damping = 10
            scale1?.stiffness = 500
            scale1?.mass = 1
            scale1?.fromValue = 1.2
            scale1?.toValue = 1
            alertView.layer.add(scale1!, forKey: scale1?.keyPath)
            alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    class func dismissAlert(_ alertView:UIView){
            
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            alertView.alpha = 0
            }, completion: nil)
        
        //JNW动画，消失
        let scale = JNWSpringAnimation(keyPath: "transform.scale")
        scale?.damping = 10
        scale?.stiffness = 100
        scale?.mass = 1
        
        scale?.fromValue = 1
        scale?.toValue = 0.7
        
        alertView.layer.add(scale!, forKey: scale?.keyPath)
        alertView.transform = CGAffineTransform(scaleX: 0, y: 0)

        
        //设置延迟执行的时间为
        let minseconds2 = 0.2 * Double(NSEC_PER_SEC)
        let dtime2 = DispatchTime.now() + Double(Int64(minseconds2)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dtime2, execute: {
            let mainWindow = UIApplication.shared.keyWindow
            for view in mainWindow!.subviews{
                if view.tag == 1111{
                    view.removeFromSuperview()
                }else if view.tag == 1112{
                    view.removeFromSuperview()
                }
                
            }
        })
    }
    
    
    class func addView(view1:UIView,view2:UIView){
        let overlayView = UIView(frame: mainWindow!.bounds)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.5
        mainWindow?.addSubview(overlayView)
        
        mainWindow?.addSubview(view1)
        mainWindow?.addSubview(view2)
    }
    
//    class func viewSwitchAnimation(view1:UIView,view2:UIView){
//        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            
//            view1.alpha = 0.5
//            view2.alpha = 1.0
//            mainWindow!.bringSubviewToFront(view2)
//            
//            }) { (finish) -> Void in
//        }
//        //JNW动画,出现
//        let scale1 = JNWSpringAnimation(keyPath: "transform.scale")
//        scale1.damping = 20
//        scale1.stiffness = 300
//        scale1.mass = 1
//        scale1.fromValue = 1
//        scale1.toValue = 0.6
//        view1.layer.addAnimation(scale1, forKey: scale1.keyPath)
//        view1.transform = CGAffineTransformMakeScale(0.6, 0.6)
//        
//        
//        //JNW动画,出现
//        let scale2 = JNWSpringAnimation(keyPath: "transform.scale")
//        scale2.damping = 20
//        scale2.stiffness = 300
//        scale2.mass = 1
//        scale2.fromValue = 0.6
//        scale2.toValue = 1
//        view2.layer.addAnimation(scale2, forKey: scale2.keyPath)
//        view2.transform = CGAffineTransformMakeScale(1, 1)
//        
//        
//    }
    
    //获取时区
    class func getTimeZone() ->Int32{
        let currentDate = Date()
        let zone = TimeZone.current
        let interval:NSInteger = zone.secondsFromGMT(for: currentDate)
        let timeZone:NSInteger = interval/60/60
        return Int32(timeZone)
    }
    
    
    //获取当前显示VC
//    class func getVC(view:UIView) -> UIViewController?{
//        var target:AnyObject? = view
//        while(target != nil){
//            target = target!.nextResponder()
//            if target is UIViewController{
//                return target as? UIViewController
//            }
//        }
//        return nil
//    }
}
