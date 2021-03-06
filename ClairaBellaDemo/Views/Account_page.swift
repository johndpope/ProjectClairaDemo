//
//  Account_page.swift
//
//  Created on 11/05/17.
//
//  Generated by PaintCode Plugin for Sketch
//  http://www.paintcodeapp.com/sketch
//

import UIKit



class Account_page: NSObject {
    
    
    //MARK: - Canvas Drawings
    
    /// Account
    
    class func draw_1AccountPage(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 580), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 320, height: 580), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 320, y: resizedFrame.height / 580)
        
        /// Background Color
        UIColor(hue: 0.882, saturation: 0.11, brightness: 1, alpha: 1).setFill()
        context.fill(context.boundingBoxOfClipPath)
        
        /// Footer Nav / - account
        // Warning: New symbols are not supported.
        /// Hey there, {Name}
        let heyThereName = NSMutableAttributedString(string: "Hey there,\n{Name}")
        heyThereName.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 22)!, range: NSRange(location: 0, length: heyThereName.length))
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            heyThereName.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: heyThereName.length))
        }
        context.saveGState()
        heyThereName.draw(in: CGRect(x: 106, y: 98, width: 214, height: 58))
        context.restoreGState()
        /// PLACEHOLDER - Character
        // Warning: Image layers are not supported.
        /// LIST - About
        do {
            context.saveGState()
            context.translateBy(x: 0, y: 356)
            
            /// Rectangle 4
            let rectangle4 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 321, height: 138))
            context.saveGState()
            context.translateBy(x: 0, y: 26)
            UIColor.white.setFill()
            rectangle4.fill()
            context.saveGState()
            rectangle4.lineWidth = 1
            context.beginPath()
            context.addPath(rectangle4.cgPath)
            context.clip(using: .evenOdd)
            UIColor(white: 0.678, alpha: 1).setStroke()
            rectangle4.stroke()
            context.restoreGState()
            context.restoreGState()
            
            /// Privacy Policy
            do {
                context.saveGState()
                context.translateBy(x: 17, y: 40)
                
                /// Disclosure Indicator
                let disclosureIndicator = UIBezierPath()
                disclosureIndicator.move(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator.addLine(to: CGPoint(x: 1.44, y: 0))
                disclosureIndicator.addLine(to: CGPoint(x: 7.69, y: 6.5))
                disclosureIndicator.addLine(to: CGPoint(x: 1.44, y: 13))
                disclosureIndicator.addLine(to: CGPoint(x: 0, y: 11.5))
                disclosureIndicator.addLine(to: CGPoint(x: 4.81, y: 6.5))
                disclosureIndicator.addLine(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator.close()
                disclosureIndicator.move(to: CGPoint(x: 0, y: 1.5))
                context.saveGState()
                context.translateBy(x: 277, y: 4)
                disclosureIndicator.usesEvenOddFillRule = true
                UIColor(hue: 0.855, saturation: 0.359, brightness: 0.926, alpha: 1).setFill()
                disclosureIndicator.fill()
                context.restoreGState()
                
                /// Privacy Policy
                let privacyPolicy = NSMutableAttributedString(string: "Privacy Policy")
                privacyPolicy.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: privacyPolicy.length))
                context.saveGState()
                privacyPolicy.draw(in: CGRect(x: 0, y: -1, width: 123, height: 20))
                context.restoreGState()
                
                context.restoreGState()
            }
            
            /// Terms of Service
            do {
                context.saveGState()
                context.translateBy(x: 17, y: 84)
                
                /// Terms of Service
                let termsOfService = NSMutableAttributedString(string: "Terms of Service")
                termsOfService.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: termsOfService.length))
                context.saveGState()
                termsOfService.draw(in: CGRect(x: 0, y: 0, width: 138, height: 20))
                context.restoreGState()
                
                /// Disclosure Indicator
                let disclosureIndicator2 = UIBezierPath()
                disclosureIndicator2.move(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator2.addLine(to: CGPoint(x: 1.44, y: 0))
                disclosureIndicator2.addLine(to: CGPoint(x: 7.69, y: 6.5))
                disclosureIndicator2.addLine(to: CGPoint(x: 1.44, y: 13))
                disclosureIndicator2.addLine(to: CGPoint(x: 0, y: 11.5))
                disclosureIndicator2.addLine(to: CGPoint(x: 4.81, y: 6.5))
                disclosureIndicator2.addLine(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator2.close()
                disclosureIndicator2.move(to: CGPoint(x: 0, y: 1.5))
                context.saveGState()
                context.translateBy(x: 277, y: 3)
                disclosureIndicator2.usesEvenOddFillRule = true
                UIColor(hue: 0.855, saturation: 0.359, brightness: 0.926, alpha: 1).setFill()
                disclosureIndicator2.fill()
                context.restoreGState()
                
                context.restoreGState()
            }
            
            /// Customer Service
            do {
                context.saveGState()
                context.translateBy(x: 17, y: 129)
                
                /// Disclosure Indicator
                let disclosureIndicator3 = UIBezierPath()
                disclosureIndicator3.move(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator3.addLine(to: CGPoint(x: 1.44, y: 0))
                disclosureIndicator3.addLine(to: CGPoint(x: 7.69, y: 6.5))
                disclosureIndicator3.addLine(to: CGPoint(x: 1.44, y: 13))
                disclosureIndicator3.addLine(to: CGPoint(x: 0, y: 11.5))
                disclosureIndicator3.addLine(to: CGPoint(x: 4.81, y: 6.5))
                disclosureIndicator3.addLine(to: CGPoint(x: 0, y: 1.5))
                disclosureIndicator3.close()
                disclosureIndicator3.move(to: CGPoint(x: 0, y: 1.5))
                context.saveGState()
                context.translateBy(x: 277, y: 2)
                disclosureIndicator3.usesEvenOddFillRule = true
                UIColor(hue: 0.855, saturation: 0.359, brightness: 0.926, alpha: 1).setFill()
                disclosureIndicator3.fill()
                context.restoreGState()
                
                /// Customer Service
                let customerService = NSMutableAttributedString(string: "Customer Service")
                customerService.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: customerService.length))
                context.saveGState()
                customerService.draw(in: CGRect(x: 0, y: -1, width: 171, height: 20))
                context.restoreGState()
                
                context.restoreGState()
            }
            
            /// Line
            let line = UIBezierPath()
            line.move(to: CGPoint(x: 282, y: 1.25))
            line.addLine(to: CGPoint(x: 0, y: 1.25))
            context.saveGState()
            context.translateBy(x: 19, y: 70)
            line.lineCapStyle = .square
            line.lineWidth = 0.5
            UIColor(white: 0.678, alpha: 1).setStroke()
            line.stroke()
            context.restoreGState()
            
            /// Line
            let line2 = UIBezierPath()
            line2.move(to: CGPoint(x: 282, y: 1.25))
            line2.addLine(to: CGPoint(x: 0, y: 1.25))
            context.saveGState()
            context.translateBy(x: 19, y: 115)
            line2.lineCapStyle = .square
            line2.lineWidth = 0.5
            UIColor(white: 0.678, alpha: 1).setStroke()
            line2.stroke()
            context.restoreGState()
            
            /// ABOUT
            let aBOUT = NSMutableAttributedString(string: "ABOUT")
            aBOUT.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14)!, range: NSRange(location: 0, length: aBOUT.length))
            aBOUT.addAttribute(NSForegroundColorAttributeName, value: UIColor(hue: 1, saturation: 0.02, brightness: 0.259, alpha: 1), range: NSRange(location: 0, length: aBOUT.length))
            do {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.maximumLineHeight = 13
                paragraphStyle.minimumLineHeight = 13
                aBOUT.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: aBOUT.length))
            }
            context.saveGState()
            aBOUT.draw(in: CGRect(x: 21, y: 0, width: 172, height: 15))
            context.restoreGState()
            
            context.restoreGState()
        }
        /// LIST - Your Details
        do {
            context.saveGState()
            context.translateBy(x: -11, y: 175)
            
            /// Rectangle 4
            let rectangle9 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 337, height: 145))
            context.saveGState()
            context.translateBy(x: 0, y: 20)
            UIColor.white.setFill()
            rectangle9.fill()
            context.saveGState()
            rectangle9.lineWidth = 1
            context.beginPath()
            context.addPath(rectangle9.cgPath)
            context.clip(using: .evenOdd)
            UIColor(white: 0.678, alpha: 1).setStroke()
            rectangle9.stroke()
            context.restoreGState()
            context.restoreGState()
            
            /// Email
            do {
                context.saveGState()
                context.translateBy(x: 32, y: 34)
                
                /// gthelwell@toxicfox.c
                let gthelwelltoxicfoxc = NSMutableAttributedString(string: "gthelwell@toxicfox.co.uk")
                gthelwelltoxicfoxc.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14)!, range: NSRange(location: 0, length: gthelwelltoxicfoxc.length))
                gthelwelltoxicfoxc.addAttribute(NSForegroundColorAttributeName, value: UIColor(hue: 1, saturation: 0.02, brightness: 0.259, alpha: 1), range: NSRange(location: 0, length: gthelwelltoxicfoxc.length))
                gthelwelltoxicfoxc.addAttribute(NSKernAttributeName, value: -0.22, range: NSRange(location: 0, length: gthelwelltoxicfoxc.length))
                do {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.maximumLineHeight = 13
                    paragraphStyle.minimumLineHeight = 13
                    gthelwelltoxicfoxc.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: gthelwelltoxicfoxc.length))
                }
                context.saveGState()
                gthelwelltoxicfoxc.draw(in: CGRect(x: 80, y: 2, width: 172, height: 15))
                context.restoreGState()
                
                /// Email
                let email = NSMutableAttributedString(string: "Email")
                email.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: email.length))
                context.saveGState()
                email.draw(in: CGRect(x: 0, y: -1, width: 43, height: 20))
                context.restoreGState()
                
                /// Edit Icon
                do {
                    context.saveGState()
                    context.translateBy(x: 261, y: 2)
                    
                    /// Path 14
                    let path14 = UIBezierPath()
                    path14.move(to: CGPoint(x: 3.33, y: 8.01))
                    path14.addCurve(to: CGPoint(x: 0.8, y: 11.62), controlPoint1: CGPoint(x: 2.39, y: 8.84), controlPoint2: CGPoint(x: 1.25, y: 10.46))
                    path14.addLine(to: CGPoint(x: 0.05, y: 13.54))
                    path14.addCurve(to: CGPoint(x: 0.54, y: 14.19), controlPoint1: CGPoint(x: -0.1, y: 13.92), controlPoint2: CGPoint(x: 0.11, y: 14.21))
                    path14.addLine(to: CGPoint(x: 2.38, y: 14.09))
                    path14.addCurve(to: CGPoint(x: 6.41, y: 12.55), controlPoint1: CGPoint(x: 3.63, y: 14.03), controlPoint2: CGPoint(x: 5.44, y: 13.33))
                    path14.addLine(to: CGPoint(x: 15.67, y: 5.08))
                    path14.addCurve(to: CGPoint(x: 15.97, y: 1.92), controlPoint1: CGPoint(x: 16.64, y: 4.29), controlPoint2: CGPoint(x: 16.78, y: 2.88))
                    path14.addLine(to: CGPoint(x: 15.04, y: 0.8))
                    path14.addCurve(to: CGPoint(x: 11.87, y: 0.56), controlPoint1: CGPoint(x: 14.23, y: -0.16), controlPoint2: CGPoint(x: 12.81, y: -0.27))
                    path14.addLine(to: CGPoint(x: 3.33, y: 8.01))
                    path14.close()
                    path14.move(to: CGPoint(x: 3.33, y: 8.01))
                    context.saveGState()
                    context.translateBy(x: 0.55, y: 0.29)
                    path14.lineCapStyle = .round
                    path14.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path14.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path15 = UIBezierPath()
                    path15.move(to: CGPoint.zero)
                    path15.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 11.16, y: 2.21)
                    path15.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path15.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path12 = UIBezierPath()
                    path12.move(to: CGPoint.zero)
                    path12.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 2.9, y: 8.72)
                    path12.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path12.stroke()
                    context.restoreGState()
                    
                    context.restoreGState()
                }
                
                context.restoreGState()
            }
            
            /// Name
            do {
                context.saveGState()
                context.translateBy(x: 32, y: 81)
                
                /// Gemma Thelwell
                let gemmaThelwell = NSMutableAttributedString(string: "Gemma Thelwell")
                gemmaThelwell.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14)!, range: NSRange(location: 0, length: gemmaThelwell.length))
                gemmaThelwell.addAttribute(NSForegroundColorAttributeName, value: UIColor(hue: 1, saturation: 0.02, brightness: 0.259, alpha: 1), range: NSRange(location: 0, length: gemmaThelwell.length))
                gemmaThelwell.addAttribute(NSKernAttributeName, value: -0.22, range: NSRange(location: 0, length: gemmaThelwell.length))
                do {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.maximumLineHeight = 13
                    paragraphStyle.minimumLineHeight = 13
                    gemmaThelwell.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: gemmaThelwell.length))
                }
                context.saveGState()
                gemmaThelwell.draw(in: CGRect(x: 85, y: 2, width: 164, height: 15))
                context.restoreGState()
                
                /// Name
                let name = NSMutableAttributedString(string: "Name")
                name.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: name.length))
                context.saveGState()
                name.draw(in: CGRect(x: 0, y: -1, width: 80, height: 20))
                context.restoreGState()
                
                /// Edit Icon
                do {
                    context.saveGState()
                    context.translateBy(x: 261, y: 0)
                    
                    /// Path 14
                    let path16 = UIBezierPath()
                    path16.move(to: CGPoint(x: 3.33, y: 8.01))
                    path16.addCurve(to: CGPoint(x: 0.8, y: 11.62), controlPoint1: CGPoint(x: 2.39, y: 8.84), controlPoint2: CGPoint(x: 1.25, y: 10.46))
                    path16.addLine(to: CGPoint(x: 0.05, y: 13.54))
                    path16.addCurve(to: CGPoint(x: 0.54, y: 14.19), controlPoint1: CGPoint(x: -0.1, y: 13.92), controlPoint2: CGPoint(x: 0.11, y: 14.21))
                    path16.addLine(to: CGPoint(x: 2.38, y: 14.09))
                    path16.addCurve(to: CGPoint(x: 6.41, y: 12.55), controlPoint1: CGPoint(x: 3.63, y: 14.03), controlPoint2: CGPoint(x: 5.44, y: 13.33))
                    path16.addLine(to: CGPoint(x: 15.67, y: 5.08))
                    path16.addCurve(to: CGPoint(x: 15.97, y: 1.92), controlPoint1: CGPoint(x: 16.64, y: 4.29), controlPoint2: CGPoint(x: 16.78, y: 2.88))
                    path16.addLine(to: CGPoint(x: 15.04, y: 0.8))
                    path16.addCurve(to: CGPoint(x: 11.87, y: 0.56), controlPoint1: CGPoint(x: 14.23, y: -0.16), controlPoint2: CGPoint(x: 12.81, y: -0.27))
                    path16.addLine(to: CGPoint(x: 3.33, y: 8.01))
                    path16.close()
                    path16.move(to: CGPoint(x: 3.33, y: 8.01))
                    context.saveGState()
                    context.translateBy(x: 0.55, y: 0.29)
                    path16.lineCapStyle = .round
                    path16.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path16.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path18 = UIBezierPath()
                    path18.move(to: CGPoint.zero)
                    path18.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 11.16, y: 2.21)
                    path18.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path18.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path20 = UIBezierPath()
                    path20.move(to: CGPoint.zero)
                    path20.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 2.9, y: 8.72)
                    path20.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path20.stroke()
                    context.restoreGState()
                    
                    context.restoreGState()
                }
                
                context.restoreGState()
            }
            
            /// Birthday
            do {
                context.saveGState()
                context.translateBy(x: 32, y: 126)
                
                /// DD / MM / YYYY
                let dDMMYYYY = NSMutableAttributedString(string: "DD / MM / YYYY")
                dDMMYYYY.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14)!, range: NSRange(location: 0, length: dDMMYYYY.length))
                dDMMYYYY.addAttribute(NSForegroundColorAttributeName, value: UIColor(hue: 1, saturation: 0.02, brightness: 0.259, alpha: 1), range: NSRange(location: 0, length: dDMMYYYY.length))
                dDMMYYYY.addAttribute(NSKernAttributeName, value: -0.22, range: NSRange(location: 0, length: dDMMYYYY.length))
                do {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.maximumLineHeight = 13
                    paragraphStyle.minimumLineHeight = 13
                    dDMMYYYY.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: dDMMYYYY.length))
                }
                context.saveGState()
                dDMMYYYY.draw(in: CGRect(x: 88, y: 2, width: 164, height: 15))
                context.restoreGState()
                
                /// Birthday
                let birthday = NSMutableAttributedString(string: "Birthday")
                birthday.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 15)!, range: NSRange(location: 0, length: birthday.length))
                context.saveGState()
                birthday.draw(in: CGRect(x: 0, y: -1, width: 80, height: 20))
                context.restoreGState()
                
                /// Edit Icon
                do {
                    context.saveGState()
                    context.translateBy(x: 261, y: 0)
                    
                    /// Path 14
                    let path22 = UIBezierPath()
                    path22.move(to: CGPoint(x: 3.33, y: 8.01))
                    path22.addCurve(to: CGPoint(x: 0.8, y: 11.62), controlPoint1: CGPoint(x: 2.39, y: 8.84), controlPoint2: CGPoint(x: 1.25, y: 10.46))
                    path22.addLine(to: CGPoint(x: 0.05, y: 13.54))
                    path22.addCurve(to: CGPoint(x: 0.54, y: 14.19), controlPoint1: CGPoint(x: -0.1, y: 13.92), controlPoint2: CGPoint(x: 0.11, y: 14.21))
                    path22.addLine(to: CGPoint(x: 2.38, y: 14.09))
                    path22.addCurve(to: CGPoint(x: 6.41, y: 12.55), controlPoint1: CGPoint(x: 3.63, y: 14.03), controlPoint2: CGPoint(x: 5.44, y: 13.33))
                    path22.addLine(to: CGPoint(x: 15.67, y: 5.08))
                    path22.addCurve(to: CGPoint(x: 15.97, y: 1.92), controlPoint1: CGPoint(x: 16.64, y: 4.29), controlPoint2: CGPoint(x: 16.78, y: 2.88))
                    path22.addLine(to: CGPoint(x: 15.04, y: 0.8))
                    path22.addCurve(to: CGPoint(x: 11.87, y: 0.56), controlPoint1: CGPoint(x: 14.23, y: -0.16), controlPoint2: CGPoint(x: 12.81, y: -0.27))
                    path22.addLine(to: CGPoint(x: 3.33, y: 8.01))
                    path22.close()
                    path22.move(to: CGPoint(x: 3.33, y: 8.01))
                    context.saveGState()
                    context.translateBy(x: 0.55, y: 0.29)
                    path22.lineCapStyle = .round
                    path22.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path22.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path24 = UIBezierPath()
                    path24.move(to: CGPoint.zero)
                    path24.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 11.16, y: 2.21)
                    path24.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path24.stroke()
                    context.restoreGState()
                    
                    /// Path 15
                    let path26 = UIBezierPath()
                    path26.move(to: CGPoint.zero)
                    path26.addLine(to: CGPoint(x: 3.66, y: 4.29))
                    context.saveGState()
                    context.translateBy(x: 2.9, y: 8.72)
                    path26.lineWidth = 1.51
                    UIColor(hue: 0.855, saturation: 0.356, brightness: 0.925, alpha: 1).setStroke()
                    path26.stroke()
                    context.restoreGState()
                    
                    context.restoreGState()
                }
                
                context.restoreGState()
            }
            
            /// YOUR DETAILS
            let yOURDETAILS = NSMutableAttributedString(string: "YOUR DETAILS")
            yOURDETAILS.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14)!, range: NSRange(location: 0, length: yOURDETAILS.length))
            yOURDETAILS.addAttribute(NSForegroundColorAttributeName, value: UIColor(hue: 1, saturation: 0.02, brightness: 0.259, alpha: 1), range: NSRange(location: 0, length: yOURDETAILS.length))
            yOURDETAILS.addAttribute(NSKernAttributeName, value: -0.2, range: NSRange(location: 11, length: 1))
            do {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.maximumLineHeight = 13
                paragraphStyle.minimumLineHeight = 13
                yOURDETAILS.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: yOURDETAILS.length))
            }
            context.saveGState()
            yOURDETAILS.draw(in: CGRect(x: 32, y: 0, width: 172, height: 15))
            context.restoreGState()
            
            /// Line
            let line3 = UIBezierPath()
            line3.move(to: CGPoint(x: 282, y: 1.25))
            line3.addLine(to: CGPoint(x: 0, y: 1.25))
            context.saveGState()
            context.translateBy(x: 30, y: 64)
            line3.lineCapStyle = .square
            line3.lineWidth = 0.5
            UIColor(white: 0.678, alpha: 1).setStroke()
            line3.stroke()
            context.restoreGState()
            
            /// Line
            let line4 = UIBezierPath()
            line4.move(to: CGPoint(x: 282, y: 1.25))
            line4.addLine(to: CGPoint(x: 0, y: 1.25))
            context.saveGState()
            context.translateBy(x: 30, y: 107)
            line4.lineCapStyle = .square
            line4.lineWidth = 0.5
            UIColor(white: 0.678, alpha: 1).setStroke()
            line4.stroke()
            context.restoreGState()
            
            context.restoreGState()
        }
        /// Top Bar
        do {
            context.saveGState()
            context.translateBy(x: 0, y: -4)
            
            // Empty.
            
            context.restoreGState()
        }
        
        context.restoreGState()
    }
    
    
    //MARK: - Canvas Images
    
    /// Account
    
    class func imageOf_1AccountPage() -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 320, height: 580), false, 0)
        Account_page.draw_1AccountPage()
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        LocalCache.image = image
        return image
    }
    
    
    //MARK: - Resizing Behavior
    
    enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
    
    
}
