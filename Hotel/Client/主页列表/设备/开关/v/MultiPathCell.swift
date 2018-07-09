import UIKit

protocol MultiPathCellDelegate:NSObjectProtocol{
    func detailClick(_ cell:MultiPathCell)
    func changePower(_ cell:MultiPathCell)
}

class MultiPathCell: UITableViewCell {
    weak var delegate:MultiPathCellDelegate?
    var position:Int?
    @IBOutlet weak var mianBtn: UIButton!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mianBtn.adjustsImageWhenHighlighted = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func detailClick(_ sender: AnyObject) {
        
        self.delegate?.detailClick(self)
        
    }
    @IBAction func changePower(_ sender: AnyObject) {
        
        self.delegate?.changePower(self)
        
    }
    
    
}
