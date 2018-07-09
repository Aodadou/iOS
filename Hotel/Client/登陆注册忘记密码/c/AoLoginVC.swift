//
//  AoLoginVC.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/25.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class AoLoginVC: AoBaseViewController {
    var disposeBag = DisposeBag()
    var timer:Timer?
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPwd: UIButton!
    @IBOutlet weak var btnForgetPwd: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var viewModel:AoLoginViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func initUI(){
        
        self.viewModel = AoLoginViewModel(nameObservable: self.tfUserName.rx.text.orEmpty.asObservable(), pwdObservable: self.tfPassword.rx.text.orEmpty.asObservable())
        
        viewModel.username.bind(to: tfUserName.rx.text).disposed(by: disposeBag)
        viewModel.password.bind(to: tfPassword.rx.text).disposed(by: disposeBag)

        viewModel.usernameValid
            .bind(to: tfPassword.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.everythingValid
            .bind(to: btnLogin.rx.isEnabled)
            .disposed(by: disposeBag)
        
        btnLogin.rx.tap.subscribe(onNext: { [weak self] in
            let name = self!.tfUserName.text
            let pwd = self!.tfPassword.text
            self!.startTimer()
            SVProgressHUD.show(withStatus: "正在登陆")
            self!.viewModel.doLogin(username: name!, password: pwd!)
        }).disposed(by: disposeBag)
        
        btnShowPwd.rx.tap.subscribe(onNext: { [weak self] in
            self!.viewModel.reverseShowPassword()
        }).disposed(by: disposeBag)

        viewModel.showPublicSubject.subscribe { [weak self](event) in
            self!.btnShowPwd.isSelected = event.element!
            self!.tfPassword.isSecureTextEntry = !event.element!
        }.disposed(by: disposeBag)
        viewModel.consumeShowPassword()

        
//        timer = Observable<Int>.interval(15, scheduler: MainScheduler.instance)
//        timer.takeUntil(deallocTimerSequence).subscribe(onNext: { (interval) in
//
//            SVProgressHUD.showError(withStatus: "登陆超时")
//            SVProgressHUD.dismiss()
//
//        }).disposed(by: self.disposeBag)
    }

    func load(){
        
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_GETALLDEVICE))
            .takeUntil(self.deallocNotificationSequence).subscribe(onNext: { (notification) in
                //self.rx.deallocated
                DispatchQueue.global().async {
                    
                    DispatchQueue.main.async {
                        
                        SVProgressHUD.dismiss()
                        //SVProgressHUD.showSuccess(withStatus: "登录成功")
                        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        let window = appDelegate.window
                        
                        let tabbarVC = AoTabBarVC()
                        let deviceListVC = AoDeviceListVC .instantiateViewControllerWitnStoryBoard(name: "Main")
                        let controllers = [deviceListVC,SceneModelVC(),AoSettingVC()]
                        let titles = ["设备列表","情景模式","系统设置"]
                        let normalImages = ["主页常态","情景模式常态","设置常态"]
                        let selectImages = ["主页选中","情景模式按下","设置按下"]
                        
                        tabbarVC.setUpAllControllers(controllers: controllers, titles: titles, normalImages: normalImages, selectImages: selectImages)
                        
                        window?.rootViewController = tabbarVC
                        
                    }
                }
                
                
            }).disposed(by: disposeBag)
        
    }
    
    func startTimer(){
        self.cancelTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(AoLoginVC.timeOut), userInfo: nil, repeats: false)
    }
    func timeOut(){
        SVProgressHUD.showError(withStatus: "登陆超时")
        SVProgressHUD.dismiss()
    }
    
    func cancelTimer(){
        if self.timer != nil{
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    deinit {
        print("登陆销毁")
    }
}
