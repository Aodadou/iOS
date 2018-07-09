

import UIKit
import RxSwift

class AoLoginViewModel: AoBaseViewModel {

    var username:Observable<String>!
    var password:Observable<String>!
    
    var usernameValid: Observable<Bool>!
    var passwordValid: Observable<Bool>!
    var everythingValid: Observable<Bool>!
    
    var autoLoginValid: Observable<Bool>!
    
    var showPublicSubject = PublishSubject<Bool>()
    
    
    lazy var sm:SessionManager! = SessionManager.share()
    
    override init() {
        super.init()
    }
    
    convenience init(nameObservable:Observable<String>,pwdObservable:Observable<String>) {
    
        self.init()
        
        let name = (AoUserDefault.value(forKey: AO_USERNAME) as? String)
        let pwd = AoUserDefault.value(forKey: AO_PASSWORD) as? String
        
        self.username = Observable.just(name == nil ? "" : name!)
        self.password = Observable.just(pwd == nil ? "" : pwd!)
        
        usernameValid = nameObservable
            .map { $0.count > 0 }
            .share(replay: 1)
        
        passwordValid = pwdObservable
            .map { $0.count > 0 }
            .share(replay: 1)
        
        everythingValid = Observable.combineLatest(usernameValid!, passwordValid!) { $0 && $1 }
            .share(replay: 1)
        
    }
    
    
    func consumeShowPassword(){
        let showPassword = AoUserDefault.bool(forKey: AO_SHOW_PASSWORD)
        self.showPublicSubject.onNext(showPassword)
    }
    
    func reverseShowPassword(){
        let showPassword = AoUserDefault.bool(forKey: AO_SHOW_PASSWORD)
        AoUserDefault.set(!showPassword, forKey: AO_SHOW_PASSWORD)
        AoUserDefault.synchronize()
        self.showPublicSubject.onNext(!showPassword)
    }
    
    func reverseRemember(){
        
    }
    
    func doLogin(username:String,password:String){
        
        
        sm.mode = "login"
        sm.startSession()
        
        AoUserDefault.set(username, forKey: AO_USERNAME)
        AoUserDefault.set(password, forKey: AO_PASSWORD)
        AoUserDefault.synchronize()
        
    }
    
    
    
}
