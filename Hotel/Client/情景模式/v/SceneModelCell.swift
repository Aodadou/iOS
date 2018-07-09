
import UIKit

protocol SceneModelCellDelegate:NSObjectProtocol{
    
    func sceneModelDelete(_ cell:SceneModelCell,position:Int)
    func sceneModelModifyName(_ cell:SceneModelCell,position:Int)
    func sceneModelSlide(_ cell:SceneModelCell,position:Int)
    func sceneModelDetail(_ cell:SceneModelCell,position:Int)
    func sceneModelPowerTurn(_ cell:SceneModelCell,position:Int,btn:UIButton)
}

class SceneModelCell: UITableViewCell {

    @IBOutlet weak var btn_main: UIButton!
    
    @IBOutlet weak var imgv_header: UIImageView!
    
    @IBOutlet weak var lb_model: UILabel!
    
    @IBOutlet weak var btn_power: UIButton!
    
    @IBOutlet weak var view_cover: UIView!
    
    @IBOutlet weak var view_slide: UIView!
    
    @IBOutlet weak var imgv_arrow: UIImageView!
    
    
    var panGesture:UIPanGestureRecognizer?
    
    weak var delegate:SceneModelCellDelegate?
    var position:Int = 0
    var lastContentOffset:CGFloat = 0
    var startOriginX:CGFloat = 0
    var endX:CGFloat = 0
    
    var isGetMaxandEndX:Bool = true

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.panGesture != nil{
            self.btn_main.removeGestureRecognizer(self.panGesture!)
        }
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(SceneModelCell.handlePan(_:)))
        self.panGesture!.maximumNumberOfTouches = 1
        self.panGesture!.delaysTouchesBegan = true
        self.panGesture!.delaysTouchesEnded = true
        self.panGesture!.cancelsTouchesInView = true
        self.panGesture!.delegate = self
//        self.panGesture?.isEnabled = true
        self.btn_main.addGestureRecognizer(self.panGesture!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func actionDelete(_ sender: UIButton) {
        self.delegate?.sceneModelDelete(self, position: self.position)
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        self.delegate?.sceneModelModifyName(self, position: self.position)
    }
    
    @IBAction func actionDetail(_ sender: UIButton) {
        self.delegate?.sceneModelDetail(self, position: self.position)
        
    }
    
    @IBAction func actionPowerTurn(_ sender: AnyObject) {
        self.delegate?.sceneModelPowerTurn(self, position: self.position, btn:sender as! UIButton)
    }

    /**
     手势移动
     
     - parameter gesture: 手势
     */
    func handlePan(_ gesture:UIPanGestureRecognizer){
        if gesture.view != self.btn_main{
            return
        }
        
        self.delegate?.sceneModelSlide(self, position: self.position)
        
        self.imgv_arrow?.isHidden = true
        self.view_cover.isHidden = false
        if self.isGetMaxandEndX == true{
            self.startOriginX = self.view_slide.frame.origin.x
            //最后x位置
            self.endX = self.startOriginX - self.view_slide.frame.width
            
            self.isGetMaxandEndX = false
        }
        
//        self.closeSlideViewByPosition()
        
        var slideViewFrame:CGRect?
        let translation = gesture.translation(in: self.btn_main)//CGPoint类型,往左为负，往右为正
        
        var moveDistance:CGFloat = self.lastContentOffset - translation.x//实际手指位移距离
        self.lastContentOffset = translation.x//上次位移数比如-4或者4
        //代表往左移动
        if moveDistance > 0{
            //self.enterView.hidden = true
            self.view_slide.isHidden = false
            slideViewFrame = self.view_slide.frame
            
            //当slideView的x减去位移比最后位置小时，就移动slideView和最后位置的差
            if slideViewFrame!.origin.x - moveDistance < endX{
                moveDistance = slideViewFrame!.origin.x - endX
            }
            slideViewFrame!.origin.x = max(endX,slideViewFrame!.origin.x - moveDistance)
            self.view_slide.frame = slideViewFrame!
            
        }
        //代表往右移动
        if moveDistance < 0{
            
            slideViewFrame = self.view_slide.frame
            //当slideView的x加上位移比最后位置大时，就移动slideView和最后位置的和
            if slideViewFrame!.origin.x - moveDistance > self.startOriginX{
                moveDistance = self.startOriginX - slideViewFrame!.origin.x
                slideViewFrame!.origin.x = min(self.startOriginX,slideViewFrame!.origin.x + moveDistance)
            }else{
                slideViewFrame!.origin.x = min(self.startOriginX,slideViewFrame!.origin.x - moveDistance)
            }
            self.view_slide.frame = slideViewFrame!
    
        }
        
        if gesture.state == UIGestureRecognizerState.ended{
            self.lastContentOffset = 0
            self.checkForScroll()
        }
    }
    
    //根据是否超出一半，更新frame
    func checkForScroll(){
        
        
        let positionX:CGFloat = self.view_slide.frame.origin.x
        
        let limitWidth = self.view_slide.frame.width//最大有效位移
        let halfWidth = limitWidth / 2//slideView一半
        let centerPositionX = self.view_cover.frame.origin.x - halfWidth
        //往右
        if positionX > centerPositionX{
            
            self.closeSlideView()
            //self.imgv_arrow.hidden = false
            
        }else{
            
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                var frame = self.view_slide.frame
                frame.origin.x = self.endX
                self.view_slide.frame = frame
                
                }, completion: { (finish) -> Void in
                    
            })
            
        }
        
    }
    
    /**
     关闭self的侧滑
     */
    func closeSlideView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            var frame = self.view_slide.frame
            frame.origin.x = self.view_cover.frame.origin.x
            self.view_slide.frame = frame
            
            }, completion: { (finish) -> Void in
                //self.enterView.hidden = false
        })
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer{
            let translationX = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self.btn_main)
            if abs(translationX.y) > 0.1{
                self.closeSlideView()
                return false
            }
        }
        return true
    }

    
    deinit{
        print("情景模式cell销毁了")
    }
}
