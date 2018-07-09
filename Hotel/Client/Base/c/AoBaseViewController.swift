import UIKit
import RxSwift
class AoBaseViewController: UIViewController {

    
    let deallocNotificationSequence = PublishSubject<String>()//用来注销通知
    let deallocTimerSequence = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        self.edgesForExtendedLayout = []
        //self.extendedLayoutIncludesOpaqueBars = false
        //self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.notificationTakeUntilSequence()
    }
    
    func setNavTitle(title:String){
        self.navigationItem.title = title
    }
    
    //发送消息，结束引入takeUntil的通知
    func notificationTakeUntilSequence(){
        self.deallocNotificationSequence.onNext("over obsever")
    }
    
    deinit {

    }

}


