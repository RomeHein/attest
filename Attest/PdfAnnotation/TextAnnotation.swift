//
//  TextAnnotation.swift
//  Attest
//
//  Created by Dev on 19/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import PDFKit

class TextAnnotation: PDFAnnotation {
    
    init(with text: String?, forBounds bounds: CGRect) {
        super.init(bounds: bounds, forType: .widget, withProperties: nil)
        widgetFieldType = .text
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        font = UIFont(name: "TimesNewRomanPSMT", size: 15)
        widgetStringValue = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

