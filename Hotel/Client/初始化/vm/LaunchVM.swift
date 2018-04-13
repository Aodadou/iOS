
import UIKit

class LaunchVM: NSObject {
    
    weak var keyWin:UIWindow?
    
    var isFirstLaunch:Bool!{
        get{
            let isFirst = UserDefaults.standard.bool(forKey: IS_FIRST_LAUNCH)
            if isFirst {
                UserDefaults.standard.set(true, forKey: IS_FIRST_LAUNCH)
            }
            return isFirst
        }
    }
    var isConfigAd:Bool?
    
    func launch(){
        
        let loginVM = LoginVM()
        loginVM.login()
        
        let tabbarVC = MyTabBarVC()
        let controllers = [DeviceListVC(),UIViewController(),SettingVC()]
        let titles = ["设备列表","情景模式","系统设置"]
        let normalImages = ["主页常态","情景模式常态","设置常态"]
        let selectImages = ["主页选中","情景模式按下","设置按下"]
        
        tabbarVC.setUpAllControllers(controllers: controllers, titles: titles, normalImages: normalImages, selectImages: selectImages)
        
        keyWin?.rootViewController = tabbarVC
        keyWin?.makeKeyAndVisible()
        
        
        loginVM.start(controller: tabbarVC)
    }
    
    func firstLaunch(){
        
    }
    
    func configAd(){
        
    }
    
}
