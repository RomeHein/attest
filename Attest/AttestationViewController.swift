//
//  AttestationController.swift
//  Attest
//
//  Created by Romain Cayzac on 18/03/2020.
//  Copyright © 2020 Romain Cayzac. All rights reserved.
//

import UIKit


class AttestationViewController: UIViewController {
    
    @IBOutlet var attestationTableView: UITableView?
    @IBOutlet var profileTableView: UITableView?
    @IBOutlet var informationButton: UIButton?
    @IBOutlet var profileContainerView: UIView?
    var selectedProfile: Profile?
    var selectedRaison = 0
    
    lazy var raisons: [String] = {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "raisons", ofType: "plist"),
            let raisons = NSDictionary(contentsOfFile: path) as? [String: [String]],
            let frenchRaisons = raisons["fr"] {
            return frenchRaisons
        }
        return []
    }()
    
    var profiles: [Profile] = {
        if Storage.fileExists("profiles.json", in: .caches) {
            return Storage.retrieve("profiles.json", from: .caches, as: [Profile].self)
        }
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileContainerView?.round(corners: [.topLeft,.topRight], radius: 10)
        if profiles.count == 0 {
            performSegue(withIdentifier: "onboarding", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PdfViewController {
            vc.profile = selectedProfile
            vc.raisonNumber = selectedRaison
        }
    }
    
    func removeProfile(at index: Int) {
        var tempProfiles = profiles
        tempProfiles.remove(at: index)
        if let name = profiles[index].fullName {
            Storage.remove(name.trimmingCharacters(in: .whitespaces).lowercased() + ".jpg", from: .caches)
        }
        Storage.store(tempProfiles, to: .caches, as: "profiles.json")
        profileTableView?.reloadData()
    }
}

extension AttestationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == attestationTableView {
            selectedRaison = indexPath.row
            performSegue(withIdentifier: "attestation", sender: nil)
        } else {
            selectedProfile = profiles[indexPath.row]
        }
    }
}

extension AttestationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attestationTableView {
            return raisons.count
        }
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == attestationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "raison", for: indexPath)
            if let raisonLabel = cell.viewWithTag(1) as? UILabel {
                raisonLabel.text = raisons[indexPath.row]
            }
            if let roundedView = cell.viewWithTag(2){
                roundedView.layer.cornerRadius = 10
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath)
            if let profileNameLabel = cell.viewWithTag(1) as? UILabel {
                profileNameLabel.text = profiles[indexPath.row].fullName
            }
            if let deleteButton = cell.viewWithTag(2) as? UIButton {
                deleteButton.addAction(for: .touchUpInside) {[weak self] (button) in
                    self?.removeProfile(at: indexPath.row)
                }
            }
            return cell
        }
    }
}

