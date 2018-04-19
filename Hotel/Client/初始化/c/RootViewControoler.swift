

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func setNavTitle(title:String){
        self.navigationItem.title = title
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
