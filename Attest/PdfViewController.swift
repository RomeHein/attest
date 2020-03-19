//
//  pdfViewController.swift
//  Attest
//
//  Created by Dev on 18/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController {
    
    var profile : Profile?
    var raisonNumber: Int = 0
    
    @IBOutlet var pdfView : PDFView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "attestation", withExtension: "pdf") else { return }
        if let document = PDFDocument(url: url) {
            pdfView?.document = document
        }
        pdfView?.autoScales = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertAnnotations()
    }
    
    func insertAnnotations() {
        guard let profile = self.profile,
            let page = pdfView?.currentPage else { return }
        
        let pageBounds = page.bounds(for: .cropBox)
        
        // Add signature at the right spot
        if let fullname = profile.fullName,
            let signatureImage = Storage.retrieve(fullname.trimmingCharacters(in: .whitespaces).lowercased() + ".jpg", from: .caches) {
            let imageBounds = CGRect(x: pageBounds.maxX - 200, y: pageBounds.minY, width: 200, height: 100)
            let imageStamp = SignatureAnnotation(with: signatureImage, forBounds: imageBounds, withProperties: nil)
            page.addAnnotation(imageStamp)
        }
        
        // Add profile informations
        let nameAnnotation = TextAnnotation(with: profile.fullName, forBounds: CGRect(x: 135, y: 617, width: 200, height: 20))
        page.addAnnotation(nameAnnotation)
        let dobAnnotation = TextAnnotation(with: profile.dob, forBounds: CGRect(x: 135, y: 588, width: 100, height: 20))
        page.addAnnotation(dobAnnotation)
        let addressAnnotation = TextAnnotation(with: profile.address, forBounds: CGRect(x: 135, y: 525, width: 300, height: 50))
        addressAnnotation.isMultiline = true
        page.addAnnotation(addressAnnotation)
        let cityAnnotation = TextAnnotation(with: profile.city, forBounds: CGRect(x: 370, y: 133, width: 90, height: 20))
        page.addAnnotation(cityAnnotation)
        // Add date
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let dayAnnotation = TextAnnotation(with: "\(day)", forBounds: CGRect(x: 473, y: 133, width: 30, height: 20))
        let monthAnnotation = TextAnnotation(with: "\(month)", forBounds: CGRect(x: 495, y: 133, width: 30, height: 20))
        page.addAnnotation(dayAnnotation)
        page.addAnnotation(monthAnnotation)

        // Add checkbox
        var yPosition = 422
        if raisonNumber == 1 {
            yPosition = 349
        } else if raisonNumber == 2 {
            yPosition = 302
        } else if raisonNumber == 3 {
            yPosition = 272
        } else if raisonNumber == 4 {
            yPosition = 227
        }
        let checkAnnotation = ChoiceAnnotation(forBounds: CGRect(x: 48, y: yPosition, width: 13, height: 13))
        page.addAnnotation(checkAnnotation)
    }
    
    @IBAction func close() {
        dismiss(animated: true)
    }
    
    @IBAction func shareDocAction(_ sender: UIBarButtonItem) {

        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let tempUrl = documentsPath.appendingPathComponent("attestation.pdf")
        pdfView?.document?.write(toFile: tempUrl.path)
        
        let activityViewController = UIActivityViewController(activityItems: [tempUrl], applicationActivities: nil)
        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
