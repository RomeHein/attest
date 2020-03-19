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
    
    @IBOutlet var pdfView : PDFView?
    
    var currentlySelectedAnnotation: PDFAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "attestation", withExtension: "pdf") else { return }
        if let document = PDFDocument(url: url) {
            pdfView?.document = document
            let panAnnotationGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAnnotation(sender:)))
            pdfView?.addGestureRecognizer(panAnnotationGesture)
        }
        pdfView?.autoScales = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let profileFullName = self.profile?.fullName,
            let signatureImage = Storage.retrieve(profileFullName.trimmingCharacters(in: .whitespaces).lowercased() + ".jpg", from: .documents),
            let page = pdfView?.currentPage else { return }
        let pageBounds = page.bounds(for: .cropBox)
        // Add signature at the right spot
        let imageBounds = CGRect(x: pageBounds.maxX - 200, y: pageBounds.minY, width: 200, height: 100)
        let imageStamp = SignatureAnnotation(with: signatureImage, forBounds: imageBounds, withProperties: nil)
        page.addAnnotation(imageStamp)
        // Add profile informations
    }
    
    @objc func didPanAnnotation(sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: pdfView)
        
        guard let page = pdfView?.page(for: touchLocation, nearest: true),
            let locationOnPage = pdfView?.convert(touchLocation, to: page)
            else {
                return
        }
        
        switch sender.state {
        case .began:
            guard let annotation = page.annotation(at: locationOnPage) else {
                return
            }
            if annotation.isKind(of: SignatureAnnotation.self) {
                currentlySelectedAnnotation = annotation
            }
        case .changed:
            
            guard let annotation = currentlySelectedAnnotation else {
                return
            }
            let initialBounds = annotation.bounds
            // Set the center of the annotation to the spot of our finger
            annotation.bounds = CGRect(x: locationOnPage.x - (initialBounds.width / 2), y: locationOnPage.y - (initialBounds.height / 2), width: initialBounds.width, height: initialBounds.height)
        case .ended, .cancelled, .failed:
            currentlySelectedAnnotation = nil
        default:
            break
        }
    }
}
