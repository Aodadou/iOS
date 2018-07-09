

import UIKit

class DatePickerDelegate: NSObject,UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1{
            
        }else if component == 2{
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 1{
            if row < 10{
                return "0\(row)"
            }
            return "\(row)"
        }else if component == 2{
            
            if row < 10{
                return "0\(row)"
            }
            return "\(row)"
        }else{
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    deinit{
        print("datePicker1销毁了")
    }
}
