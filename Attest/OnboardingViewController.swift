//
//  ViewController.swift
//  Attest
//
//  Created by Romain Cayzac on 18/03/2020.
//  Copyright © 2020 Romain Cayzac. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    var profiles: [Profile] = {
        if Storage.fileExists("profiles.json", in: .documents) {
            return Storage.retrieve("profiles.json", from: .documents, as: [Profile].self)
        }
        return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if profiles.count != 0 {
            dismiss(animated: true)
        }
    }

}

