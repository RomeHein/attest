// See https://www.swiftdevcenter.com/uidatepicker-as-input-view-to-uitextfield-swift/

import UIKit
extension UITextField {
    
    func setInputViewDatePicker() {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
    }
    
    func setAccessoryView(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Next", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
