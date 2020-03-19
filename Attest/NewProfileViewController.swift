//
//  NewProfile.swift
//  Attest
//
//  Created by Romain Cayzac on 18/03/2020.
//  Copyright © 2020 Romain Cayzac. All rights reserved.
//

import UIKit

class NewProfileViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var dobTextField: UITextField?
    @IBOutlet var addressTextField: UITextField?
    @IBOutlet var cityTextField: UITextField?
    @IBOutlet var signatureView: SignatureView?
    
    var newProfile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField?.setAccessoryView(target: self, selector: #selector(nextTextField))
        dobTextField?.setAccessoryView(target: self, selector: #selector(nextTextField))
        addressTextField?.setAccessoryView(target: self, selector: #selector(nextTextField))
        cityTextField?.setAccessoryView(target: self, selector: #selector(nextTextField))
        dobTextField?.setInputViewDatePicker()
    }

    @objc func nextTextField() {
        dismissTextField(goToNext: true)
    }
    
    func dismissTextField(goToNext: Bool) {
        if let textField = self.nameTextField, textField.isFirstResponder {
            newProfile.fullName = textField.text
            if goToNext {
                dobTextField?.becomeFirstResponder()
            }
        } else if let textField = self.dobTextField, let datePicker = textField.inputView as? UIDatePicker,
            textField.isFirstResponder {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            textField.text = dateformatter.string(from: datePicker.date)
            newProfile.dob = textField.text
            if goToNext {
               addressTextField?.becomeFirstResponder()
            }
        } else if let textField = self.addressTextField, textField.isFirstResponder {
            newProfile.address = textField.text
            if goToNext {
               cityTextField?.becomeFirstResponder()
            }
        } else if let textField = self.cityTextField, textField.isFirstResponder {
            newProfile.city = textField.text
            if goToNext {
               textField.resignFirstResponder()
            }
        }
    }
    
    @IBAction func addProfile() {
        if let _ = newProfile.address,
            let _ = newProfile.dob,
            let name = newProfile.fullName,
            let signature = signatureView?.image,
            signatureView?.hasDraw == true {
            var profiles = [Profile]()
            if Storage.fileExists("profiles.json", in: .documents) {
                profiles = Storage.retrieve("profiles.json", from: .documents, as: [Profile].self)
            }
            profiles.append(newProfile)
            Storage.store(profiles, to: .documents, as: "profiles.json")
            Storage.store(signature, to: .documents, as: name.trimmingCharacters(in: .whitespaces).lowercased() + ".jpg")
            dismiss(animated: true)
        } else {
            
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true)
    }
    
    @IBAction func eraseSignature() {
        signatureView?.removeDrawing()
    }
}

extension NewProfileViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissTextField(goToNext: false)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissTextField(goToNext: true)
        return true
    }
}
