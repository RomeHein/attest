//
//  SignatureView.swift
//  Attest
//
//  Created by Dev on 18/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import UIKit

class SignatureView: UIView {
    
    var lineColor = UIColor.black
    var lineWidth: CGFloat = 3.0
    var hasDraw = false
    var image = UIImage()
    
    private var pts = [CGPoint.zero, CGPoint.zero, CGPoint.zero, CGPoint.zero]
    private var ctr = 0
    private var path = UIBezierPath()
    
    
    
    override func draw(_ rect: CGRect) {
        image.draw(in: rect)
        path.lineWidth = lineWidth
        path.lineCapStyle = CGLineCap.round
        
        lineColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ctr = 0
        guard let touch = touches.first else {
            return
        }
        pts[0] = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let p = touch.location(in: self)
        ctr = ctr + 1
        pts[ctr] = p
        if  (ctr == 3) {
            pts[2] = CGPoint(x : (pts[1].x + pts[3].x)/2.0, y : (pts[1].y + pts[3].y)/2.0);
            path.move(to: pts[0])
            path.addQuadCurve(to: pts[2], controlPoint: pts[1])
            setNeedsDisplay()
            pts[0] = pts[2]
            pts[1] = pts[3]
            ctr = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (ctr == 0)
        {
            let magicNumber = lineWidth / 6
            path = UIBezierPath(roundedRect: CGRect(x: pts[0].x, y : pts[0].y,width: magicNumber,height: magicNumber), cornerRadius: magicNumber / 2)
            
        }
        else if (ctr == 1)
        {
            path.move(to: pts[0])
            path.addLine(to: pts[1])
        }
        else if (ctr == 2)
        {
            path.move(to: pts[0])
            path.addQuadCurve(to: pts[2], controlPoint: pts[1])
        }
        
        drawBitmap()
        
        setNeedsDisplay()
        path.removeAllPoints()
        ctr = 0;
        hasDraw = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        lineColor.setStroke()
        path.lineWidth = lineWidth
        path.lineCapStyle = CGLineCap.round
        
        image.draw(at: CGPoint.zero)
        path.stroke()
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    func removeDrawing() {
        path.removeAllPoints()
        image = UIImage()
        setNeedsDisplay()
        hasDraw = false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
}

