//
//  ViewController.swift
//  Attest
//
//  Created by Romain Cayzac on 18/03/2020.
//  Copyright © 2020 Romain Cayzac. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, Away {
    weak var home: Home?
    var profiles: [Profile] {
        get {
            if Storage.fileExists("profiles.json", in: .caches) {
                return Storage.retrieve("profiles.json", from: .caches, as: [Profile].self)
            }
            return []
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.notifyComingHome()
    }
    
    @IBAction func showWarningMessage() {
        let alertController = UIAlertController(title: "Attention", message: "Cette application existe pour faciliter l'impression de vos attestations. L'utiliser sans imprimer vos documents vous expose à une amende forfaitaire de 135 euros en cas de contrôle.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok, j'ai bien compris", style: .default) { [weak self] (action:UIAlertAction) in
            self?.performSegue(withIdentifier: "create", sender: nil)
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func openLink() {
        guard let url = URL(string: "https://github.com/RomeHein/attest") else { return }
        UIApplication.shared.open(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let vc = segue.destination as? NewProfileViewController {
            vc.home = self
        }
    }
}

extension OnboardingViewController: Home {
    func comingHome() {
        if profiles.count != 0 {
            dismiss(animated: true)
        }
    }
}

