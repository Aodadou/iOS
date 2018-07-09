import UIKit

@objc protocol AoDeviceCellDelegate:NSObjectProtocol{
    func AoDeviceCell(_ cell:AoDeviceCell,didClickAt index:NSInteger)
    func AoDeviceCell(_ cell:AoDeviceCell,motifyAt index:NSInteger)
    func AoDeviceCell(_ cell:AoDeviceCell,deleteAt index:NSInteger)
    func AoDeviceCell(_ cell:AoDeviceCell,addNormalAt index:NSInteger)
    func AoDeviceCell(_ cell:AoDeviceCell,didCloseAt index:NSInteger)
}

class AoDeviceCell: UITableViewCell{
    
    weak var delegate:AoDeviceCellDelegate?
    var position:Int = 0
    var section:Int = 0
    var panGesture:UIPanGestureRecognizer?
    var lastContentOffset:CGFloat = 0
    var startOriginX:CGFloat = 0
    var endX:CGFloat = 0
    
    var isGetMaxandEndX:Bool = true
    var deviceType:Int?
    var deviceId:String?
    var groupId:String?
    var roomName:String?
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recoverView: UIView!
    @IBOutlet weak var enterView: UIButton!
    @IBOutlet weak var onlineLabel: UILabel!
    
    @IBOutlet weak var btnAddToCommond: UIButton!
    @IBOutlet weak var btnModifyName: UIButton!
    
    var hImage:UIImage?{
        set(image){
            self.headerImage.image = image
        }
        get{
            return self.headerImage.image
        }
    }
    var deviceName:String{
        set(name){
            self.nameLabel.text = name
        }
        get{
            return self.nameLabel!.text!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.mainBtn.adjustsImageWhenHighlighted = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func addGesture(){
        if self.panGesture != nil{
            self.mainBtn.removeGestureRecognizer(self.panGesture!)
        }
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(AoDeviceCell.handlePan(_:)))
        self.panGesture!.maximumNumberOfTouches = 1
        self.panGesture!.delaysTouchesBegan = true
        self.panGesture!.delaysTouchesEnded = true
        self.panGesture!.cancelsTouchesInView = true
        self.panGesture!.delegate = self
        self.mainBtn.addGestureRecognizer(self.panGesture!)
    }
    /**
    手势移动
    
    - parameter gesture: 手势
    */
    func handlePan(_ gesture:UIPanGestureRecognizer){
        if gesture.view != self.mainBtn{
            return
        }
        
        self.recoverView.isHidden = false
        if self.isGetMaxandEndX == true{
            self.startOriginX = self.slideView.frame.origin.x
            //最后x位置
            self.endX = self.startOriginX - self.slideView.frame.width

            self.isGetMaxandEndX = false
        }
        
        self.closeSlideViewByPosition()
        
        var slideViewFrame:CGRect?
        let translation = gesture.translation(in: self.mainBtn)//CGPoint类型,往左为负，往右为正
        
        var moveDistance:CGFloat = self.lastContentOffset - translation.x//实际手指位移距离
        self.lastContentOffset = translation.x//上次位移数比如-4或者4
        //代表往左移动
        if moveDistance > 0{
            self.enterView.isHidden = true
            self.slideView.isHidden = false
            slideViewFrame = self.slideView.frame
            
            //当slideView的x减去位移比最后位置小时，就移动slideView和最后位置的差
            if slideViewFrame!.origin.x - moveDistance < endX{
                moveDistance = slideViewFrame!.origin.x - endX
            }
            slideViewFrame!.origin.x = max(endX,slideViewFrame!.origin.x - moveDistance)
            self.slideView.frame = slideViewFrame!
            
            //如果slideView在最后位置，设置约束
            //if self.slideView.frame.origin.x == self.endX{
            //}
        }
        //代表往右移动
        if moveDistance < 0{
            
            slideViewFrame = self.slideView.frame
            //当slideView的x加上位移比最后位置大时，就移动  slideView和最后位置的和
            if slideViewFrame!.origin.x - moveDistance > self.startOriginX{
                moveDistance = self.startOriginX - slideViewFrame!.origin.x
                slideViewFrame!.origin.x = min(self.startOriginX,slideViewFrame!.origin.x + moveDistance)
            }else{
                slideViewFrame!.origin.x = min(self.startOriginX,slideViewFrame!.origin.x - moveDistance)
            }
            self.slideView.frame = slideViewFrame!
            //如果slideView在初始位置，设置约束
            //if self.slideView.frame.origin.x == self.startOriginX{
            //}
        }
    
        if gesture.state == UIGestureRecognizerState.ended{
            self.lastContentOffset = 0
            self.checkForScroll()
        }
    }
    
    //根据是否超出一半，更新frame   0.33
    func checkForScroll(){
        
        
        let positionX:CGFloat = self.slideView.frame.origin.x

        let limitWidth = self.slideView.frame.width//最大有效位移
        let halfWidth = limitWidth / 2.0//slideView 0.5
        
        
        let centerPositionX = self.recoverView.frame.origin.x - halfWidth
        //往右
        if positionX > centerPositionX{
            
            self.closeSlideView()

        }else{
            
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                var frame = self.slideView.frame
                frame.origin.x = self.endX
                self.slideView.frame = frame
                
                }, completion: { (finish) -> Void in
                    
            })
            
        }

    }
    
    @IBAction func tapMainBtnClose(_ sender: AnyObject) {
        self.closeAllSlideView()
        self.delegate?.AoDeviceCell(self, didClickAt: position)
    }
    
    @IBAction func modifyDeviceName(_ sender: AnyObject) {
        self.delegate?.AoDeviceCell(self, motifyAt: position)
    }
    
    @IBAction func deleteDevice(_ sender: AnyObject) {
        self.delegate?.AoDeviceCell(self, deleteAt: position)
    }
    
    @IBAction func addToCommondList(_ sender: AnyObject) {
        self.closeSlideView()
        self.delegate?.AoDeviceCell(self, addNormalAt: position)
    }
    
    /**
    关闭self的侧滑
    */
    func closeSlideView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            var frame = self.slideView.frame
            frame.origin.x = self.recoverView.frame.origin.x
            self.slideView.frame = frame
            
            }, completion: { (finish) -> Void in
                self.enterView.isHidden = false
        })
    }
    
    /**
    关闭除自己外的侧滑
    */
    func closeSlideViewByPosition(){
        let tbv = self.getVC(self)
        if tbv != nil{
            for cell in (tbv?.visibleCells as! [AoDeviceCell]){
                
                if cell.position != self.position{
                    cell.closeSlideView()
                }
                
            }
        }
    }
    
    /**
    关闭所有侧滑
    */
    func closeAllSlideView(){
        let tbv = self.getVC(self)
        if tbv != nil{
            for cell in (tbv?.visibleCells as! [AoDeviceCell]){
                cell.closeSlideView()
            }
        }
    }
    
    /**
    获取当前tableView
    
    - parameter view: cell
    
    - returns: cell所在的列表
    */
    func getVC(_ view:UIView) -> UITableView?{
        var target:AnyObject? = view
        while(target != nil){
            target = target!.next
            if target is UITableView{
                return target as? UITableView
            }
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeAllSlideView()
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer{
            let translationX = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self.mainBtn)
            if abs(translationX.y) > 0.01{
                //self.closeSlideView()
                return false
            }
        }
        return true
    }

    deinit{
        print("设备列表cell销毁")
    }
}

