//
//  UtilityClasses.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 09/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class CheckBox: UIButton {
    
    var boundaryLayer: CALayer! {
        didSet{
            drawUI()
        }
    }
    
    @IBInspectable var checked: Bool = false {
        didSet {
            checkedStateChange()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            boundaryLayer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            boundaryLayer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .gray {
        didSet {
            boundaryLayer.borderColor = borderColor.cgColor
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boundaryLayer = CALayer()
        boundaryLayer.frame = CGRect(x: 10, y: 10, width: frame.width/2, height: frame.height/2)
        self.layer.addSublayer(boundaryLayer)
        checkedStateChange()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boundaryLayer.frame = CGRect(x: 10, y: 10, width: frame.width/2, height: frame.height/2)
    }    
    
    func drawUI() {
        boundaryLayer.cornerRadius = cornerRadius
        boundaryLayer.borderWidth = borderWidth
        boundaryLayer.borderColor = borderColor.cgColor
    }
    
    func checkedStateChange() {
        let shapeLayer = CAShapeLayer()
        let path = selectedPath
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0

        let fillColor = checked ? UIColor.blue : UIColor.white

        shapeLayer.fillColor = nil
        boundaryLayer.addSublayer(shapeLayer)
        
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.boundaryLayer.backgroundColor = fillColor.cgColor
            }) { (finish) in
                shapeLayer.strokeColor = self.checked ? UIColor.white.cgColor : UIColor.white.cgColor
        }
    }
    
    var selectedPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: boundaryLayer.bounds.origin.x + 3, y: boundaryLayer.frame.height/2 + 3))
        path.addLine(to: CGPoint(x: boundaryLayer.frame.width/2 - 3, y: boundaryLayer.frame.height - 3))
        path.addLine(to: CGPoint(x: boundaryLayer.frame.width - 3, y: boundaryLayer.bounds.width/2 - 3))
        
        return path
    }
}


private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.characters.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}



class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
