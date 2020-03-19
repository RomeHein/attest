//
//  SettingViewController.swift
//  Attest
//
//  Created by Dev on 19/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBAction func openLink() {
        guard let url = URL(string: "https://github.com/RomeHein/attest/tree/master/Attest") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func close() {
        dismiss(animated: true)
    }
}
