import UIKit

//此项目的根视图
class MyTabBarVC: UITabBarController {
    var index = 0
    var maskView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backColor
        
        self.hidesBottomBarWhenPushed = true

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //所有参数个数必须一样
    func setUpAllControllers(controllers:[UIViewController]!,titles:[String],normalImages:[String],selectImages:[String]){
        
        for (index,controller) in controllers.enumerated(){
            
            var normalImage:String?
            var selectImage:String?
            var title:String?
            if index > titles.count - 1{
                title = ""
            }else{
                title = titles[index]
            }
            
            if index > normalImages.count - 1{
                normalImage = ""
            }else{
                normalImage = normalImages[index]
            }
            
            if index > selectImages.count - 1{
                selectImage = ""
            }else{
                selectImage = selectImages[index]
            }
            controller.navigationItem.title = title
            let nav = NavigationController(rootViewController: controller)
            self.setUpChildController(nav, image: normalImage!, selectImage: selectImage!)
        }
        

        
    }
    
    
    func setUpChildController(_ controller: UIViewController,image:String,selectImage:String){
        
        let noSelectImage = image + ""
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0)
        controller.tabBarItem.image = UIImage(named: noSelectImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named:selectImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.addChildViewController(controller)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
    func showMaskView(){
        self.maskView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.alpha = 0.5
        view.backgroundColor = .black
        self.view.addSubview(self.maskView!)
    }
    
    func removeMaskView(){
        if self.maskView != nil {
            self.maskView?.removeFromSuperview()
        }
    }
    
    
    deinit{
        print("切换栏销毁了")
    }
    
    func dismissSelf(_ notification:Notification){
        self.dismiss(animated: true, completion: nil)
    }
}
