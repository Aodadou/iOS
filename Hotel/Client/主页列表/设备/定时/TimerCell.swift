import UIKit

class TimerCell: UITableViewCell {
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!

    @IBOutlet weak var btn_detail: UIButton!
    @IBOutlet weak var switchBottomImg: UIImageView!
    @IBOutlet weak var timerSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_detail.alpha = 0
        
        if UIScreen.main.bounds.size.width == 320{
            weekLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func turnSwitch(_ sender: AnyObject) {
        
    }
    
    @IBAction func enterDetail(_ sender: AnyObject) {
        
    }
    
    
}
