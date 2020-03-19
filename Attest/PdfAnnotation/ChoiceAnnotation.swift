//
//  ChoiceAnnotation.swift
//  Attest
//
//  Created by Dev on 19/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import PDFKit

class ChoiceAnnotation: PDFAnnotation {
    
    init(forBounds bounds: CGRect) {
        super.init(bounds: bounds, forType: .widget, withProperties: nil)
        widgetFieldType = .button
        widgetControlType = .checkBoxControl
        buttonWidgetState = .onState
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

