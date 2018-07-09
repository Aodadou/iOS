import UIKit

class DatePickerDataSource: NSObject,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 1{
            return 24
        }else if component == 2{
            return 60
        }else{
            return 0
        }
        
    }
    
    deinit{
        print("datePicker2销毁了")
    }
}
