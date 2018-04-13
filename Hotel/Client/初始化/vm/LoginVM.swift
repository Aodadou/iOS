
import UIKit

class LoginVM: NSObject {
    
    weak var targetVC:UIViewController?
    lazy var sm:SessionManager! = SessionManager.share()
    
    var username:String?
    var pwd:String?
    
    override init() {
        super.init()
    }
    
    convenience init(username:String,pwd:String ){
        self.init()
        self.username = username
        self.pwd = pwd
        
    }
    
    func login(){
//        if let _ = UserDefaults.standard.value(forKey: USERNAME){
//            GlobalMethod.toast("login")
//        }else{
//            GlobalMethod.toast("null")
//        }
        
        GlobalMethod.toast("正在登录...")
        sm.mode = "login"
        sm.startSession()
        
    }
    
    func start(controller:UIViewController){
        
        if let _ = UserDefaults.standard.value(forKey: ACCOUNT){
            
            
            
        }else{
            
//            let alert = UIAlertController(title: "未登录", message: "", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: { (textField) in
//                textField.placeholder = "请输入房间账号"
//                textField.textAlignment = .center
//            })
//            let sure = UIAlertAction(title: "登录", style: .default, handler: { (action) in
//
//                let inputText = alert.textFields?.first?.text
//                if inputText == nil || inputText == ""{
//
//                    DispatchQueue.main.async(execute: {
//                        GlobalMethod.toast("请输入房间账号")
//                    })
//
//                }else{
//
//                    self.login()
//
//                }
//
//            })
//            alert.addAction(sure)
//            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
