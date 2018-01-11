//
//  LoadingVC.swift
//  Claireabella
//
//  Created by Intelivita on 04/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit
import GTProgressBar
import PocketSVG
import AWSCognitoIdentityProvider


class LoadingVC: UIViewController {

    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?

    
    @IBOutlet var go_btn: UIButton!
    @IBOutlet var loading_lable: UILabel!
    @IBOutlet var loading_indicator: UIImageView!
    @IBOutlet var loader_image: UIImageView!
    @IBOutlet var main_loadingView: UIView!
    @IBOutlet var loadview: UIView!
    @IBOutlet var temp_view: LoaderView!
    @IBOutlet var loading_progressBar: UIProgressView!
    @IBOutlet var progressBar: GTProgressBar!
    @IBOutlet var Character_imageView: UIImageView!
    var logoImages: Array<UIImage> = []
    var logolable = Array<String>()
    var index = Int()
    var progress_index = CGFloat()
    var timer = Timer()
    var timerTest : Timer?
    let layer:CAShapeLayer = CAShapeLayer()
    let layer_line:CASpringAnimation = CASpringAnimation()
    
    let fill1Path = UIBezierPath()
    let rwLayer = CAShapeLayer()
    let rwColor = UIColor(hue: 0.527, saturation: 0.591, brightness: 0.929, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImages += [UIImage(named: "Character")!, UIImage(named: "Character1")!, UIImage(named: "Character2")!,UIImage(named: "Character3")!,UIImage(named: "Character4")!]
        logolable += ["Start Your ClaireaBella Journey","The Home Of Personalised Characters","Have fun with outfits & hair styles","Share Your Characters In Fun Emoji’s","Share Your Characters In Fun Emoji’s"]
        
        index = 0
        loading_lable.text = logolable[0] as String
        imagePath()
       // setUpRWLayer()
       // loadview.layer.addSublayer(rwLayer)
       
        UIView.animate(withDuration: 13.0, animations: {() -> Void in
            var frame: CGRect = self.loading_indicator.frame
            frame.origin.x = 0
            self.loading_indicator.frame = frame
            self.loading_indicator.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: {(_ finished: Bool) -> Void in
         //   UIView.beginAnimations({  nil }, context: {  nil })
            UIView.setAnimationDuration(5.3)
            UIView.commitAnimations()
        })
        
        
        
        UIImage.animatedImageNamed("allowfullaccess", duration: TimeInterval(4))
        
    }
   
    func animateSVG(From startProportion: CGFloat, To endProportion: CGFloat, Duration duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProportion
        animation.toValue = endProportion
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault/*kCAMediaTimingFunctionEaseOut*/)
        rwLayer.strokeEnd = endProportion
        rwLayer.strokeStart = startProportion
        animation.repeatCount = Float(Int.max)
        rwLayer.add(animation, forKey: "strokeEnd")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        self .startTimer()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    func startTimer () {
        
        if timerTest == nil {
            timerTest =  Timer.scheduledTimer(
                timeInterval: TimeInterval(13),
                target      : self,
                selector    : #selector(LoadingVC.time),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            self .navigate()
            timerTest = nil
        }
    }
    
    func runTimedCode()  {
        index += 1
         if index == logoImages.count
         {
            index = 0
            timer .invalidate()
        }
        Character_imageView.image = logoImages[index] as UIImage
        loading_lable.text = logolable[index] as String
    }
    
    // must be internal or public.
    func update()
    {
        index += 1
        progress_index += 0.4
       
        loading_progressBar.setProgress(Float(progress_index), animated: true)
        if index == logoImages.count
        {
            
            
                //
        }
        Character_imageView.image = logoImages[index] as UIImage
        loading_lable.text = logolable[index] as String
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func imagePath() {
        fill1Path.move(to: CGPoint(x: 206.04, y: 7.1))
        fill1Path.addCurve(to: CGPoint(x: 208.06, y: 11.32), controlPoint1: CGPoint(x: 206.62, y: 8.49), controlPoint2: CGPoint(x: 206.43, y: 10.08))
        fill1Path.addCurve(to: CGPoint(x: 206.04, y: 7.1), controlPoint1: CGPoint(x: 208.78, y: 9.84), controlPoint2: CGPoint(x: 208.58, y: 9.39))
        fill1Path.close()
        fill1Path.move(to: CGPoint(x: 89.78, y: 1.09))
        fill1Path.addCurve(to: CGPoint(x: 90.21, y: 1.53), controlPoint1: CGPoint(x: 89.93, y: 1.24), controlPoint2: CGPoint(x: 90.07, y: 1.38))
        fill1Path.addCurve(to: CGPoint(x: 92.32, y: 2.65), controlPoint1: CGPoint(x: 90.34, y: 2.46), controlPoint2: CGPoint(x: 91.01, y: 2.89))
        fill1Path.addCurve(to: CGPoint(x: 95.67, y: 4.04), controlPoint1: CGPoint(x: 94.08, y: 2.34), controlPoint2: CGPoint(x: 94.94, y: 3.12))
        fill1Path.addCurve(to: CGPoint(x: 96.45, y: 5.34), controlPoint1: CGPoint(x: 95.93, y: 4.38), controlPoint2: CGPoint(x: 96.11, y: 4.76))
        fill1Path.addCurve(to: CGPoint(x: 101.49, y: 4.65), controlPoint1: CGPoint(x: 97.93, y: 4.02), controlPoint2: CGPoint(x: 99.63, y: 4.14))
        fill1Path.addCurve(to: CGPoint(x: 106.05, y: 4.39), controlPoint1: CGPoint(x: 102.71, y: 3.58), controlPoint2: CGPoint(x: 104.18, y: 3.2))
        fill1Path.addCurve(to: CGPoint(x: 107.82, y: 1.28), controlPoint1: CGPoint(x: 106.06, y: 2.92), controlPoint2: CGPoint(x: 106.03, y: 1.73))
        fill1Path.addCurve(to: CGPoint(x: 111.49, y: 4.16), controlPoint1: CGPoint(x: 110.42, y: 1.42), controlPoint2: CGPoint(x: 110.35, y: 3.17))
        fill1Path.addCurve(to: CGPoint(x: 115.81, y: 4.39), controlPoint1: CGPoint(x: 113.83, y: 3.29), controlPoint2: CGPoint(x: 114.15, y: 3.31))
        fill1Path.addCurve(to: CGPoint(x: 117.88, y: 8.63), controlPoint1: CGPoint(x: 116.43, y: 5.68), controlPoint2: CGPoint(x: 117.07, y: 6.97))
        fill1Path.addCurve(to: CGPoint(x: 116.86, y: 4.34), controlPoint1: CGPoint(x: 118.37, y: 6.8), controlPoint2: CGPoint(x: 117.77, y: 5.55))
        fill1Path.addCurve(to: CGPoint(x: 120.39, y: 3.12), controlPoint1: CGPoint(x: 117.74, y: 2.71), controlPoint2: CGPoint(x: 119.33, y: 2.11))
        fill1Path.addCurve(to: CGPoint(x: 123.32, y: 4.57), controlPoint1: CGPoint(x: 121.43, y: 4.1), controlPoint2: CGPoint(x: 123.13, y: 3.1))
        fill1Path.addCurve(to: CGPoint(x: 124.51, y: 6.56), controlPoint1: CGPoint(x: 123.41, y: 5.25), controlPoint2: CGPoint(x: 124.1, y: 5.9))
        fill1Path.addCurve(to: CGPoint(x: 124.92, y: 4.57), controlPoint1: CGPoint(x: 124.91, y: 5.85), controlPoint2: CGPoint(x: 124.88, y: 5.21))
        fill1Path.addCurve(to: CGPoint(x: 128.26, y: 3.63), controlPoint1: CGPoint(x: 125.05, y: 2.79), controlPoint2: CGPoint(x: 125.95, y: 3.76))
        fill1Path.addCurve(to: CGPoint(x: 131.28, y: 3.76), controlPoint1: CGPoint(x: 129.28, y: 3.58), controlPoint2: CGPoint(x: 130.54, y: 3.42))
        fill1Path.addCurve(to: CGPoint(x: 132.7, y: 5.59), controlPoint1: CGPoint(x: 132.03, y: 4.11), controlPoint2: CGPoint(x: 132.28, y: 5.01))
        fill1Path.addCurve(to: CGPoint(x: 133.19, y: 4.16), controlPoint1: CGPoint(x: 132.83, y: 5.19), controlPoint2: CGPoint(x: 132.98, y: 4.67))
        fill1Path.addCurve(to: CGPoint(x: 137.93, y: 3.09), controlPoint1: CGPoint(x: 134.02, y: 2.19), controlPoint2: CGPoint(x: 136.02, y: 1.66))
        fill1Path.addCurve(to: CGPoint(x: 142.9, y: 4.21), controlPoint1: CGPoint(x: 139.41, y: 4.2), controlPoint2: CGPoint(x: 140.88, y: 4.6))
        fill1Path.addCurve(to: CGPoint(x: 144.12, y: 2.63), controlPoint1: CGPoint(x: 143.3, y: 3.69), controlPoint2: CGPoint(x: 143.61, y: 3.11))
        fill1Path.addCurve(to: CGPoint(x: 147.81, y: 3), controlPoint1: CGPoint(x: 145.36, y: 1.49), controlPoint2: CGPoint(x: 147.02, y: 1.68))
        fill1Path.addCurve(to: CGPoint(x: 148.78, y: 4.59), controlPoint1: CGPoint(x: 148.13, y: 3.54), controlPoint2: CGPoint(x: 148.46, y: 4.07))
        fill1Path.addCurve(to: CGPoint(x: 150.91, y: 2.97), controlPoint1: CGPoint(x: 149.58, y: 3.94), controlPoint2: CGPoint(x: 150.11, y: 3.15))
        fill1Path.addCurve(to: CGPoint(x: 153.68, y: 3.37), controlPoint1: CGPoint(x: 151.69, y: 2.78), controlPoint2: CGPoint(x: 152.74, y: 3.21))
        fill1Path.addCurve(to: CGPoint(x: 157.45, y: 2.4), controlPoint1: CGPoint(x: 154.44, y: 1.76), controlPoint2: CGPoint(x: 156.15, y: 1.31))
        fill1Path.addCurve(to: CGPoint(x: 158.52, y: 3.81), controlPoint1: CGPoint(x: 157.92, y: 2.8), controlPoint2: CGPoint(x: 158.19, y: 3.33))
        fill1Path.addCurve(to: CGPoint(x: 159.83, y: 5.79), controlPoint1: CGPoint(x: 158.97, y: 4.47), controlPoint2: CGPoint(x: 159.4, y: 5.13))
        fill1Path.addCurve(to: CGPoint(x: 160.13, y: 4.04), controlPoint1: CGPoint(x: 160.12, y: 5.13), controlPoint2: CGPoint(x: 160.1, y: 4.58))
        fill1Path.addCurve(to: CGPoint(x: 163.61, y: 2.4), controlPoint1: CGPoint(x: 160.21, y: 2.07), controlPoint2: CGPoint(x: 161.13, y: 1.65))
        fill1Path.addCurve(to: CGPoint(x: 165.08, y: 2.44), controlPoint1: CGPoint(x: 164.05, y: 2.53), controlPoint2: CGPoint(x: 164.77, y: 2.61))
        fill1Path.addCurve(to: CGPoint(x: 167.85, y: 3.15), controlPoint1: CGPoint(x: 166.58, y: 1.65), controlPoint2: CGPoint(x: 167.31, y: 2.21))
        fill1Path.addCurve(to: CGPoint(x: 169.18, y: 5.68), controlPoint1: CGPoint(x: 168.33, y: 4), controlPoint2: CGPoint(x: 168.75, y: 4.87))
        fill1Path.addCurve(to: CGPoint(x: 171.98, y: 1.15), controlPoint1: CGPoint(x: 169.54, y: 1.87), controlPoint2: CGPoint(x: 169.54, y: 1.87))
        fill1Path.addCurve(to: CGPoint(x: 174.99, y: 4.22), controlPoint1: CGPoint(x: 172.92, y: 2.1), controlPoint2: CGPoint(x: 173.9, y: 3.1))
        fill1Path.addCurve(to: CGPoint(x: 175, y: 2.85), controlPoint1: CGPoint(x: 174.99, y: 3.66), controlPoint2: CGPoint(x: 174.97, y: 3.25))
        fill1Path.addCurve(to: CGPoint(x: 177, y: 1.15), controlPoint1: CGPoint(x: 175.07, y: 1.93), controlPoint2: CGPoint(x: 175.7, y: 1.31))
        fill1Path.addCurve(to: CGPoint(x: 179.37, y: 2.3), controlPoint1: CGPoint(x: 178.29, y: 0.98), controlPoint2: CGPoint(x: 178.88, y: 1.6))
        fill1Path.addCurve(to: CGPoint(x: 180.65, y: 4.01), controlPoint1: CGPoint(x: 179.72, y: 2.79), controlPoint2: CGPoint(x: 180.09, y: 3.27))
        fill1Path.addCurve(to: CGPoint(x: 181.13, y: 2.54), controlPoint1: CGPoint(x: 180.87, y: 3.32), controlPoint2: CGPoint(x: 180.98, y: 2.93))
        fill1Path.addCurve(to: CGPoint(x: 183.83, y: 1.76), controlPoint1: CGPoint(x: 181.59, y: 1.42), controlPoint2: CGPoint(x: 182.51, y: 1.12))
        fill1Path.addCurve(to: CGPoint(x: 185.15, y: 2.99), controlPoint1: CGPoint(x: 184.41, y: 2.04), controlPoint2: CGPoint(x: 184.87, y: 2.53))
        fill1Path.addCurve(to: CGPoint(x: 186.39, y: 5.61), controlPoint1: CGPoint(x: 185.68, y: 3.91), controlPoint2: CGPoint(x: 186.05, y: 4.88))
        fill1Path.addCurve(to: CGPoint(x: 190.53, y: 3.82), controlPoint1: CGPoint(x: 187.83, y: 4.99), controlPoint2: CGPoint(x: 189.17, y: 4.39))
        fill1Path.addCurve(to: CGPoint(x: 194.74, y: 4.61), controlPoint1: CGPoint(x: 192.34, y: 3.05), controlPoint2: CGPoint(x: 192.71, y: 3.13))
        fill1Path.addCurve(to: CGPoint(x: 208.33, y: 3.9), controlPoint1: CGPoint(x: 196.86, y: 2.76), controlPoint2: CGPoint(x: 202.22, y: 2.96))
        fill1Path.addCurve(to: CGPoint(x: 208.91, y: 3.27), controlPoint1: CGPoint(x: 208.51, y: 3.71), controlPoint2: CGPoint(x: 208.64, y: 3.42))
        fill1Path.addCurve(to: CGPoint(x: 211.6, y: 2), controlPoint1: CGPoint(x: 209.77, y: 2.8), controlPoint2: CGPoint(x: 210.62, y: 2.17))
        fill1Path.addCurve(to: CGPoint(x: 213.5, y: 3.41), controlPoint1: CGPoint(x: 212.96, y: 1.76), controlPoint2: CGPoint(x: 213.04, y: 2.76))
        fill1Path.addCurve(to: CGPoint(x: 215.98, y: 4.19), controlPoint1: CGPoint(x: 213.96, y: 4.07), controlPoint2: CGPoint(x: 214.71, y: 4.73))
        fill1Path.addCurve(to: CGPoint(x: 219.7, y: 5.09), controlPoint1: CGPoint(x: 217.69, y: 3.47), controlPoint2: CGPoint(x: 218.78, y: 4.11))
        fill1Path.addCurve(to: CGPoint(x: 225.52, y: 5.2), controlPoint1: CGPoint(x: 221.82, y: 2.96), controlPoint2: CGPoint(x: 222.58, y: 2.97))
        fill1Path.addCurve(to: CGPoint(x: 225.2, y: 3.15), controlPoint1: CGPoint(x: 225.37, y: 4.41), controlPoint2: CGPoint(x: 225.02, y: 3.74))
        fill1Path.addCurve(to: CGPoint(x: 226.62, y: 1.59), controlPoint1: CGPoint(x: 225.38, y: 2.57), controlPoint2: CGPoint(x: 225.93, y: 1.84))
        fill1Path.addCurve(to: CGPoint(x: 228.89, y: 2.04), controlPoint1: CGPoint(x: 227.15, y: 1.4), controlPoint2: CGPoint(x: 228.22, y: 1.75))
        fill1Path.addCurve(to: CGPoint(x: 230.29, y: 3.17), controlPoint1: CGPoint(x: 229.49, y: 2.3), controlPoint2: CGPoint(x: 229.87, y: 2.81))
        fill1Path.addCurve(to: CGPoint(x: 235.35, y: 4.61), controlPoint1: CGPoint(x: 233.48, y: 2.48), controlPoint2: CGPoint(x: 233.99, y: 2.63))
        fill1Path.addCurve(to: CGPoint(x: 236.56, y: 6.5), controlPoint1: CGPoint(x: 235.81, y: 5.29), controlPoint2: CGPoint(x: 236.23, y: 5.99))
        fill1Path.addCurve(to: CGPoint(x: 238.42, y: 4.42), controlPoint1: CGPoint(x: 237.2, y: 5.73), controlPoint2: CGPoint(x: 237.57, y: 4.74))
        fill1Path.addCurve(to: CGPoint(x: 241.57, y: 4.67), controlPoint1: CGPoint(x: 239.2, y: 4.12), controlPoint2: CGPoint(x: 240.51, y: 4.56))
        fill1Path.addCurve(to: CGPoint(x: 243.85, y: 3.57), controlPoint1: CGPoint(x: 242.22, y: 4.34), controlPoint2: CGPoint(x: 243.01, y: 3.6))
        fill1Path.addCurve(to: CGPoint(x: 247.94, y: 2.88), controlPoint1: CGPoint(x: 245.32, y: 3.53), controlPoint2: CGPoint(x: 246.72, y: 3.83))
        fill1Path.addCurve(to: CGPoint(x: 249.87, y: 3.29), controlPoint1: CGPoint(x: 248.15, y: 2.72), controlPoint2: CGPoint(x: 249.4, y: 2.98))
        fill1Path.addCurve(to: CGPoint(x: 252.01, y: 5.29), controlPoint1: CGPoint(x: 250.66, y: 3.81), controlPoint2: CGPoint(x: 251.22, y: 4.52))
        fill1Path.addCurve(to: CGPoint(x: 254.99, y: 3.42), controlPoint1: CGPoint(x: 253.05, y: 4.62), controlPoint2: CGPoint(x: 253.95, y: 3.95))
        fill1Path.addCurve(to: CGPoint(x: 257.18, y: 2.88), controlPoint1: CGPoint(x: 255.62, y: 3.11), controlPoint2: CGPoint(x: 256.64, y: 2.72))
        fill1Path.addCurve(to: CGPoint(x: 262.53, y: 4.88), controlPoint1: CGPoint(x: 259.04, y: 3.43), controlPoint2: CGPoint(x: 260.77, y: 4.2))
        fill1Path.addCurve(to: CGPoint(x: 263.25, y: 3.05), controlPoint1: CGPoint(x: 262.76, y: 4.3), controlPoint2: CGPoint(x: 262.9, y: 3.64))
        fill1Path.addCurve(to: CGPoint(x: 266.73, y: 2.74), controlPoint1: CGPoint(x: 263.99, y: 1.8), controlPoint2: CGPoint(x: 265.62, y: 1.66))
        fill1Path.addCurve(to: CGPoint(x: 268.15, y: 4.46), controlPoint1: CGPoint(x: 267.31, y: 3.31), controlPoint2: CGPoint(x: 267.75, y: 3.96))
        fill1Path.addCurve(to: CGPoint(x: 270.95, y: 3.66), controlPoint1: CGPoint(x: 269.15, y: 4.15), controlPoint2: CGPoint(x: 270.11, y: 3.58))
        fill1Path.addCurve(to: CGPoint(x: 273.51, y: 4.84), controlPoint1: CGPoint(x: 271.85, y: 3.74), controlPoint2: CGPoint(x: 272.66, y: 4.42))
        fill1Path.addCurve(to: CGPoint(x: 277.52, y: 3.93), controlPoint1: CGPoint(x: 274.44, y: 3.86), controlPoint2: CGPoint(x: 275.82, y: 3.51))
        fill1Path.addCurve(to: CGPoint(x: 278.57, y: 2), controlPoint1: CGPoint(x: 277.94, y: 3.17), controlPoint2: CGPoint(x: 278.27, y: 2.56))
        fill1Path.addCurve(to: CGPoint(x: 283.22, y: 4.37), controlPoint1: CGPoint(x: 281.55, y: 1.79), controlPoint2: CGPoint(x: 281.55, y: 1.79))
        fill1Path.addCurve(to: CGPoint(x: 287.76, y: 4.45), controlPoint1: CGPoint(x: 284.79, y: 2.97), controlPoint2: CGPoint(x: 286.31, y: 3.46))
        fill1Path.addCurve(to: CGPoint(x: 293.95, y: 8.21), controlPoint1: CGPoint(x: 292.71, y: 2.88), controlPoint2: CGPoint(x: 292.36, y: 6.16))
        fill1Path.addCurve(to: CGPoint(x: 294.12, y: 6.89), controlPoint1: CGPoint(x: 294.05, y: 7.49), controlPoint2: CGPoint(x: 294.11, y: 7.19))
        fill1Path.addCurve(to: CGPoint(x: 294.22, y: 4.04), controlPoint1: CGPoint(x: 294.16, y: 5.94), controlPoint2: CGPoint(x: 294.08, y: 4.99))
        fill1Path.addCurve(to: CGPoint(x: 296.51, y: 2.55), controlPoint1: CGPoint(x: 294.35, y: 3.12), controlPoint2: CGPoint(x: 295.18, y: 2.66))
        fill1Path.addCurve(to: CGPoint(x: 298.76, y: 3.63), controlPoint1: CGPoint(x: 297.76, y: 2.45), controlPoint2: CGPoint(x: 298.41, y: 2.74))
        fill1Path.addCurve(to: CGPoint(x: 300.17, y: 5.82), controlPoint1: CGPoint(x: 299.04, y: 4.36), controlPoint2: CGPoint(x: 299.64, y: 5.02))
        fill1Path.addCurve(to: CGPoint(x: 300.38, y: 4.89), controlPoint1: CGPoint(x: 300.26, y: 5.42), controlPoint2: CGPoint(x: 300.29, y: 5.15))
        fill1Path.addCurve(to: CGPoint(x: 302.85, y: 3.2), controlPoint1: CGPoint(x: 300.72, y: 3.96), controlPoint2: CGPoint(x: 301.48, y: 3.19))
        fill1Path.addCurve(to: CGPoint(x: 305.72, y: 4.83), controlPoint1: CGPoint(x: 304.22, y: 3.22), controlPoint2: CGPoint(x: 305.33, y: 3.7))
        fill1Path.addCurve(to: CGPoint(x: 307.22, y: 7.74), controlPoint1: CGPoint(x: 306.02, y: 5.7), controlPoint2: CGPoint(x: 306.58, y: 6.52))
        fill1Path.addCurve(to: CGPoint(x: 307.23, y: 5.33), controlPoint1: CGPoint(x: 307.22, y: 6.68), controlPoint2: CGPoint(x: 307.16, y: 6))
        fill1Path.addCurve(to: CGPoint(x: 311.23, y: 2.76), controlPoint1: CGPoint(x: 307.44, y: 3.03), controlPoint2: CGPoint(x: 307.94, y: 2.72))
        fill1Path.addLine(to: CGPoint(x: 311.19, y: 2.73))
        fill1Path.addCurve(to: CGPoint(x: 311.31, y: 11.45), controlPoint1: CGPoint(x: 311.24, y: 5.64), controlPoint2: CGPoint(x: 311.33, y: 8.55))
        fill1Path.addCurve(to: CGPoint(x: 307.65, y: 15.02), controlPoint1: CGPoint(x: 311.3, y: 14.06), controlPoint2: CGPoint(x: 311.17, y: 14.13))
        fill1Path.addLine(to: CGPoint(x: 307.42, y: 15.05))
        fill1Path.addLine(to: CGPoint(x: 307.19, y: 15))
        fill1Path.addCurve(to: CGPoint(x: 304.53, y: 12.79), controlPoint1: CGPoint(x: 306.3, y: 14.26), controlPoint2: CGPoint(x: 305.41, y: 13.53))
        fill1Path.addCurve(to: CGPoint(x: 299.05, y: 12.85), controlPoint1: CGPoint(x: 302.14, y: 14.19), controlPoint2: CGPoint(x: 302.1, y: 14.19))
        fill1Path.addCurve(to: CGPoint(x: 297.58, y: 15.73), controlPoint1: CGPoint(x: 298.56, y: 13.8), controlPoint2: CGPoint(x: 298.07, y: 14.77))
        fill1Path.addCurve(to: CGPoint(x: 294.09, y: 15.73), controlPoint1: CGPoint(x: 296.41, y: 15.73), controlPoint2: CGPoint(x: 295.25, y: 15.73))
        fill1Path.addCurve(to: CGPoint(x: 291.92, y: 12.93), controlPoint1: CGPoint(x: 293.29, y: 14.7), controlPoint2: CGPoint(x: 292.49, y: 13.67))
        fill1Path.addCurve(to: CGPoint(x: 282.8, y: 12.31), controlPoint1: CGPoint(x: 288.49, y: 13.38), controlPoint2: CGPoint(x: 285.51, y: 14.15))
        fill1Path.addCurve(to: CGPoint(x: 277.07, y: 12.91), controlPoint1: CGPoint(x: 280.78, y: 14.79), controlPoint2: CGPoint(x: 279.45, y: 14.94))
        fill1Path.addCurve(to: CGPoint(x: 272.9, y: 11.73), controlPoint1: CGPoint(x: 275.87, y: 11.88), controlPoint2: CGPoint(x: 274.33, y: 12))
        fill1Path.addCurve(to: CGPoint(x: 272.71, y: 12.03), controlPoint1: CGPoint(x: 272.78, y: 11.92), controlPoint2: CGPoint(x: 272.7, y: 11.98))
        fill1Path.addCurve(to: CGPoint(x: 272.92, y: 12.39), controlPoint1: CGPoint(x: 272.76, y: 12.15), controlPoint2: CGPoint(x: 272.84, y: 12.27))
        fill1Path.addCurve(to: CGPoint(x: 272.15, y: 14.3), controlPoint1: CGPoint(x: 273.53, y: 13.37), controlPoint2: CGPoint(x: 273.29, y: 13.96))
        fill1Path.addCurve(to: CGPoint(x: 269.59, y: 13.25), controlPoint1: CGPoint(x: 271.13, y: 14.61), controlPoint2: CGPoint(x: 269.84, y: 14.12))
        fill1Path.addCurve(to: CGPoint(x: 268.33, y: 11.62), controlPoint1: CGPoint(x: 269.39, y: 12.54), controlPoint2: CGPoint(x: 269.96, y: 11.53))
        fill1Path.addCurve(to: CGPoint(x: 266.7, y: 13.26), controlPoint1: CGPoint(x: 267.74, y: 12.25), controlPoint2: CGPoint(x: 267.37, y: 13.11))
        fill1Path.addCurve(to: CGPoint(x: 262.72, y: 13.33), controlPoint1: CGPoint(x: 265.52, y: 13.51), controlPoint2: CGPoint(x: 264.15, y: 13.33))
        fill1Path.addCurve(to: CGPoint(x: 256.41, y: 12.84), controlPoint1: CGPoint(x: 260.78, y: 14.82), controlPoint2: CGPoint(x: 259.48, y: 14.72))
        fill1Path.addCurve(to: CGPoint(x: 253.74, y: 13.12), controlPoint1: CGPoint(x: 255.42, y: 12.96), controlPoint2: CGPoint(x: 254.47, y: 13.29))
        fill1Path.addCurve(to: CGPoint(x: 251.59, y: 12.04), controlPoint1: CGPoint(x: 252.82, y: 12.92), controlPoint2: CGPoint(x: 252.09, y: 12.31))
        fill1Path.addCurve(to: CGPoint(x: 248.75, y: 12.56), controlPoint1: CGPoint(x: 250.45, y: 12.26), controlPoint2: CGPoint(x: 249.52, y: 12.68))
        fill1Path.addCurve(to: CGPoint(x: 244.28, y: 13.22), controlPoint1: CGPoint(x: 246.95, y: 12.27), controlPoint2: CGPoint(x: 245.45, y: 12.53))
        fill1Path.addCurve(to: CGPoint(x: 241.24, y: 12.69), controlPoint1: CGPoint(x: 243.08, y: 12.99), controlPoint2: CGPoint(x: 241.68, y: 12.43))
        fill1Path.addCurve(to: CGPoint(x: 236.5, y: 12.54), controlPoint1: CGPoint(x: 239.45, y: 13.77), controlPoint2: CGPoint(x: 237.98, y: 13.36))
        fill1Path.addCurve(to: CGPoint(x: 230.59, y: 12.47), controlPoint1: CGPoint(x: 233.86, y: 14.2), controlPoint2: CGPoint(x: 233.86, y: 14.2))
        fill1Path.addCurve(to: CGPoint(x: 225.86, y: 12.58), controlPoint1: CGPoint(x: 229.07, y: 13.43), controlPoint2: CGPoint(x: 227.38, y: 13.75))
        fill1Path.addCurve(to: CGPoint(x: 218.83, y: 14.57), controlPoint1: CGPoint(x: 223.39, y: 13.28), controlPoint2: CGPoint(x: 221.11, y: 13.93))
        fill1Path.addCurve(to: CGPoint(x: 211.74, y: 13.43), controlPoint1: CGPoint(x: 216.61, y: 13.6), controlPoint2: CGPoint(x: 213.81, y: 14.62))
        fill1Path.addCurve(to: CGPoint(x: 205.61, y: 13.81), controlPoint1: CGPoint(x: 209.09, y: 14.92), controlPoint2: CGPoint(x: 208.28, y: 15.02))
        fill1Path.addCurve(to: CGPoint(x: 202.87, y: 13.83), controlPoint1: CGPoint(x: 204.54, y: 13.33), controlPoint2: CGPoint(x: 203.89, y: 13.23))
        fill1Path.addCurve(to: CGPoint(x: 200.83, y: 13.98), controlPoint1: CGPoint(x: 202.42, y: 14.1), controlPoint2: CGPoint(x: 201.19, y: 14.21))
        fill1Path.addCurve(to: CGPoint(x: 195.81, y: 13.99), controlPoint1: CGPoint(x: 199.08, y: 12.87), controlPoint2: CGPoint(x: 197.35, y: 13.49))
        fill1Path.addCurve(to: CGPoint(x: 191.54, y: 14), controlPoint1: CGPoint(x: 194.27, y: 14.49), controlPoint2: CGPoint(x: 192.85, y: 15.2))
        fill1Path.addCurve(to: CGPoint(x: 186.99, y: 13.08), controlPoint1: CGPoint(x: 190.27, y: 12.83), controlPoint2: CGPoint(x: 188.13, y: 14.36))
        fill1Path.addCurve(to: CGPoint(x: 185.57, y: 11.83), controlPoint1: CGPoint(x: 186.6, y: 12.63), controlPoint2: CGPoint(x: 186.06, y: 12.24))
        fill1Path.addCurve(to: CGPoint(x: 184.16, y: 10.76), controlPoint1: CGPoint(x: 185.15, y: 11.49), controlPoint2: CGPoint(x: 184.71, y: 11.18))
        fill1Path.addCurve(to: CGPoint(x: 183.38, y: 11.45), controlPoint1: CGPoint(x: 183.8, y: 11.07), controlPoint2: CGPoint(x: 183.39, y: 11.25))
        fill1Path.addCurve(to: CGPoint(x: 183.53, y: 13.05), controlPoint1: CGPoint(x: 183.34, y: 11.98), controlPoint2: CGPoint(x: 183.55, y: 12.51))
        fill1Path.addCurve(to: CGPoint(x: 179.68, y: 14.52), controlPoint1: CGPoint(x: 183.44, y: 14.78), controlPoint2: CGPoint(x: 181.78, y: 15.39))
        fill1Path.addCurve(to: CGPoint(x: 176.48, y: 13.33), controlPoint1: CGPoint(x: 178.64, y: 14.09), controlPoint2: CGPoint(x: 177.49, y: 13.8))
        fill1Path.addCurve(to: CGPoint(x: 175.1, y: 12.17), controlPoint1: CGPoint(x: 175.9, y: 13.06), controlPoint2: CGPoint(x: 175.39, y: 12.62))
        fill1Path.addCurve(to: CGPoint(x: 174.82, y: 10.42), controlPoint1: CGPoint(x: 174.84, y: 11.78), controlPoint2: CGPoint(x: 174.94, y: 11.28))
        fill1Path.addCurve(to: CGPoint(x: 173.99, y: 12.58), controlPoint1: CGPoint(x: 174.44, y: 11.43), controlPoint2: CGPoint(x: 174.27, y: 12.02))
        fill1Path.addCurve(to: CGPoint(x: 169, y: 13.35), controlPoint1: CGPoint(x: 173.06, y: 14.46), controlPoint2: CGPoint(x: 171, y: 14.77))
        fill1Path.addCurve(to: CGPoint(x: 168.05, y: 12.67), controlPoint1: CGPoint(x: 168.68, y: 13.12), controlPoint2: CGPoint(x: 168.32, y: 12.65))
        fill1Path.addCurve(to: CGPoint(x: 161.56, y: 15.17), controlPoint1: CGPoint(x: 165.74, y: 12.89), controlPoint2: CGPoint(x: 163.96, y: 14.68))
        fill1Path.addCurve(to: CGPoint(x: 159.37, y: 14.94), controlPoint1: CGPoint(x: 160.91, y: 15.3), controlPoint2: CGPoint(x: 160.1, y: 15.02))
        fill1Path.addCurve(to: CGPoint(x: 155.64, y: 16.01), controlPoint1: CGPoint(x: 158.18, y: 15.47), controlPoint2: CGPoint(x: 156.91, y: 15.74))
        fill1Path.addCurve(to: CGPoint(x: 154.1, y: 12.95), controlPoint1: CGPoint(x: 155.13, y: 16.12), controlPoint2: CGPoint(x: 154.49, y: 12.72))
        fill1Path.addCurve(to: CGPoint(x: 150.22, y: 12.85), controlPoint1: CGPoint(x: 152.5, y: 13.87), controlPoint2: CGPoint(x: 151.15, y: 13.28))
        fill1Path.addCurve(to: CGPoint(x: 146.36, y: 13.39), controlPoint1: CGPoint(x: 148.67, y: 13.07), controlPoint2: CGPoint(x: 147.51, y: 13.22))
        fill1Path.addCurve(to: CGPoint(x: 144.04, y: 13.83), controlPoint1: CGPoint(x: 145.57, y: 13.52), controlPoint2: CGPoint(x: 144.7, y: 13.55))
        fill1Path.addCurve(to: CGPoint(x: 138.21, y: 13.22), controlPoint1: CGPoint(x: 141.31, y: 15), controlPoint2: CGPoint(x: 140.24, y: 14.92))
        fill1Path.addCurve(to: CGPoint(x: 137.06, y: 12.16), controlPoint1: CGPoint(x: 137.87, y: 12.93), controlPoint2: CGPoint(x: 137.55, y: 12.62))
        fill1Path.addCurve(to: CGPoint(x: 136.9, y: 13.19), controlPoint1: CGPoint(x: 136.98, y: 12.66), controlPoint2: CGPoint(x: 136.91, y: 12.92))
        fill1Path.addCurve(to: CGPoint(x: 134.33, y: 15.34), controlPoint1: CGPoint(x: 136.87, y: 14.42), controlPoint2: CGPoint(x: 135.75, y: 15.05))
        fill1Path.addCurve(to: CGPoint(x: 131.22, y: 14.29), controlPoint1: CGPoint(x: 132.99, y: 15.62), controlPoint2: CGPoint(x: 132.07, y: 15))
        fill1Path.addCurve(to: CGPoint(x: 128.61, y: 12.55), controlPoint1: CGPoint(x: 130.45, y: 13.64), controlPoint2: CGPoint(x: 129.47, y: 13.12))
        fill1Path.addCurve(to: CGPoint(x: 122.3, y: 12.51), controlPoint1: CGPoint(x: 126.34, y: 13.94), controlPoint2: CGPoint(x: 124.25, y: 13.68))
        fill1Path.addCurve(to: CGPoint(x: 115.89, y: 12.59), controlPoint1: CGPoint(x: 119.25, y: 14.06), controlPoint2: CGPoint(x: 119.09, y: 14.06))
        fill1Path.addCurve(to: CGPoint(x: 114.05, y: 13.32), controlPoint1: CGPoint(x: 115.29, y: 12.83), controlPoint2: CGPoint(x: 114.65, y: 13.08))
        fill1Path.addCurve(to: CGPoint(x: 111.53, y: 12.33), controlPoint1: CGPoint(x: 113.13, y: 12.96), controlPoint2: CGPoint(x: 112.33, y: 12.65))
        fill1Path.addCurve(to: CGPoint(x: 105.27, y: 13.28), controlPoint1: CGPoint(x: 109.62, y: 15.18), controlPoint2: CGPoint(x: 108.4, y: 15.26))
        fill1Path.addCurve(to: CGPoint(x: 100.61, y: 13.47), controlPoint1: CGPoint(x: 104.03, y: 12.5), controlPoint2: CGPoint(x: 102.24, y: 13.59))
        fill1Path.addCurve(to: CGPoint(x: 95.4, y: 14.35), controlPoint1: CGPoint(x: 98.92, y: 13.35), controlPoint2: CGPoint(x: 96.9, y: 12.98))
        fill1Path.addCurve(to: CGPoint(x: 92.08, y: 14.19), controlPoint1: CGPoint(x: 94.53, y: 15.14), controlPoint2: CGPoint(x: 93.19, y: 14.78))
        fill1Path.addCurve(to: CGPoint(x: 88.68, y: 13.16), controlPoint1: CGPoint(x: 90.06, y: 13.13), controlPoint2: CGPoint(x: 89.72, y: 11.48))
        fill1Path.addCurve(to: CGPoint(x: 84.44, y: 15.82), controlPoint1: CGPoint(x: 87.82, y: 14.55), controlPoint2: CGPoint(x: 86.7, y: 15.63))
        fill1Path.addLine(to: CGPoint(x: 84.48, y: 15.84))
        fill1Path.addCurve(to: CGPoint(x: 81.42, y: 14.26), controlPoint1: CGPoint(x: 83.46, y: 15.28), controlPoint2: CGPoint(x: 82.46, y: 14.28))
        fill1Path.addCurve(to: CGPoint(x: 77.12, y: 12.62), controlPoint1: CGPoint(x: 79.45, y: 14.21), controlPoint2: CGPoint(x: 78.38, y: 13.35))
        fill1Path.addCurve(to: CGPoint(x: 71.63, y: 12.99), controlPoint1: CGPoint(x: 74.56, y: 14.46), controlPoint2: CGPoint(x: 74.7, y: 14.29))
        fill1Path.addCurve(to: CGPoint(x: 66.37, y: 12.49), controlPoint1: CGPoint(x: 70.2, y: 12.38), controlPoint2: CGPoint(x: 67.83, y: 12.07))
        fill1Path.addCurve(to: CGPoint(x: 61.38, y: 12.28), controlPoint1: CGPoint(x: 64.47, y: 13.04), controlPoint2: CGPoint(x: 63.02, y: 12.99))
        fill1Path.addCurve(to: CGPoint(x: 59.93, y: 14.43), controlPoint1: CGPoint(x: 60.9, y: 12.98), controlPoint2: CGPoint(x: 60.5, y: 13.58))
        fill1Path.addCurve(to: CGPoint(x: 56.25, y: 13.72), controlPoint1: CGPoint(x: 58.66, y: 14.2), controlPoint2: CGPoint(x: 57.35, y: 14.11))
        fill1Path.addCurve(to: CGPoint(x: 50.56, y: 13.52), controlPoint1: CGPoint(x: 54.34, y: 13.06), controlPoint2: CGPoint(x: 52.56, y: 13.05))
        fill1Path.addCurve(to: CGPoint(x: 42.47, y: 13.5), controlPoint1: CGPoint(x: 47.77, y: 14.18), controlPoint2: CGPoint(x: 44.88, y: 15.45))
        fill1Path.addCurve(to: CGPoint(x: 39.34, y: 14.06), controlPoint1: CGPoint(x: 41.22, y: 13.75), controlPoint2: CGPoint(x: 40.24, y: 14.13))
        fill1Path.addCurve(to: CGPoint(x: 36.71, y: 13.15), controlPoint1: CGPoint(x: 38.4, y: 13.98), controlPoint2: CGPoint(x: 37.54, y: 13.45))
        fill1Path.addCurve(to: CGPoint(x: 31.17, y: 12.94), controlPoint1: CGPoint(x: 34.27, y: 14.42), controlPoint2: CGPoint(x: 34.27, y: 14.42))
        fill1Path.addCurve(to: CGPoint(x: 26.62, y: 12.5), controlPoint1: CGPoint(x: 29.64, y: 13.58), controlPoint2: CGPoint(x: 28.07, y: 13.56))
        fill1Path.addCurve(to: CGPoint(x: 21.98, y: 13.46), controlPoint1: CGPoint(x: 25.31, y: 13.73), controlPoint2: CGPoint(x: 23.95, y: 14.52))
        fill1Path.addCurve(to: CGPoint(x: 21.17, y: 13.45), controlPoint1: CGPoint(x: 21.79, y: 13.36), controlPoint2: CGPoint(x: 21.34, y: 13.35))
        fill1Path.addCurve(to: CGPoint(x: 17.14, y: 13.01), controlPoint1: CGPoint(x: 19.61, y: 14.31), controlPoint2: CGPoint(x: 18.36, y: 13.47))
        fill1Path.addCurve(to: CGPoint(x: 10.95, y: 12.58), controlPoint1: CGPoint(x: 14.51, y: 14.86), controlPoint2: CGPoint(x: 12.82, y: 14.49))
        fill1Path.addCurve(to: CGPoint(x: 10.08, y: 13.01), controlPoint1: CGPoint(x: 10.66, y: 12.73), controlPoint2: CGPoint(x: 10.39, y: 12.9))
        fill1Path.addCurve(to: CGPoint(x: 3.57, y: 10.35), controlPoint1: CGPoint(x: 6.69, y: 14.17), controlPoint2: CGPoint(x: 3.71, y: 12.96))
        fill1Path.addCurve(to: CGPoint(x: 3.5, y: 6.69), controlPoint1: CGPoint(x: 3.51, y: 9.13), controlPoint2: CGPoint(x: 3.28, y: 7.89))
        fill1Path.addCurve(to: CGPoint(x: 7.13, y: 3.08), controlPoint1: CGPoint(x: 3.79, y: 5.09), controlPoint2: CGPoint(x: 3.87, y: 3.23))
        fill1Path.addCurve(to: CGPoint(x: 7.63, y: 2.91), controlPoint1: CGPoint(x: 7.3, y: 3.07), controlPoint2: CGPoint(x: 7.53, y: 3))
        fill1Path.addCurve(to: CGPoint(x: 12.36, y: 3.03), controlPoint1: CGPoint(x: 9.3, y: 1.34), controlPoint2: CGPoint(x: 10.88, y: 2.1))
        fill1Path.addCurve(to: CGPoint(x: 17.11, y: 3.61), controlPoint1: CGPoint(x: 14.77, y: 2.17), controlPoint2: CGPoint(x: 14.77, y: 2.17))
        fill1Path.addCurve(to: CGPoint(x: 20.93, y: 4.16), controlPoint1: CGPoint(x: 18.5, y: 3.13), controlPoint2: CGPoint(x: 19.9, y: 2.95))
        fill1Path.addCurve(to: CGPoint(x: 23.15, y: 1.87), controlPoint1: CGPoint(x: 21.76, y: 3.41), controlPoint2: CGPoint(x: 21.01, y: 2.01))
        fill1Path.addCurve(to: CGPoint(x: 25.87, y: 3.21), controlPoint1: CGPoint(x: 24.88, y: 1.76), controlPoint2: CGPoint(x: 25.4, y: 2.59))
        fill1Path.addCurve(to: CGPoint(x: 28.63, y: 2.35), controlPoint1: CGPoint(x: 26.86, y: 2.88), controlPoint2: CGPoint(x: 27.83, y: 2.25))
        fill1Path.addCurve(to: CGPoint(x: 31.63, y: 3.7), controlPoint1: CGPoint(x: 29.66, y: 2.48), controlPoint2: CGPoint(x: 30.56, y: 3.18))
        fill1Path.addCurve(to: CGPoint(x: 35.74, y: 4.89), controlPoint1: CGPoint(x: 34.21, y: 2.81), controlPoint2: CGPoint(x: 34.41, y: 2.87))
        fill1Path.addCurve(to: CGPoint(x: 37.06, y: 6.39), controlPoint1: CGPoint(x: 36.06, y: 5.37), controlPoint2: CGPoint(x: 36.53, y: 5.79))
        fill1Path.addCurve(to: CGPoint(x: 38.75, y: 3.5), controlPoint1: CGPoint(x: 37.21, y: 5.16), controlPoint2: CGPoint(x: 36.78, y: 3.93))
        fill1Path.addCurve(to: CGPoint(x: 41.91, y: 5.17), controlPoint1: CGPoint(x: 40.67, y: 3.08), controlPoint2: CGPoint(x: 41.14, y: 4.3))
        fill1Path.addCurve(to: CGPoint(x: 45.45, y: 3.45), controlPoint1: CGPoint(x: 43.08, y: 3.75), controlPoint2: CGPoint(x: 43.09, y: 3.78))
        fill1Path.addCurve(to: CGPoint(x: 46.89, y: 2.92), controlPoint1: CGPoint(x: 45.96, y: 3.38), controlPoint2: CGPoint(x: 46.43, y: 3.12))
        fill1Path.addCurve(to: CGPoint(x: 50.65, y: 3.69), controlPoint1: CGPoint(x: 48.87, y: 2.05), controlPoint2: CGPoint(x: 49.57, y: 2.19))
        fill1Path.addCurve(to: CGPoint(x: 51.06, y: 4.44), controlPoint1: CGPoint(x: 50.85, y: 3.97), controlPoint2: CGPoint(x: 50.97, y: 4.28))
        fill1Path.addCurve(to: CGPoint(x: 53.48, y: 3.62), controlPoint1: CGPoint(x: 51.91, y: 4.13), controlPoint2: CGPoint(x: 52.71, y: 3.59))
        fill1Path.addCurve(to: CGPoint(x: 55.97, y: 4.52), controlPoint1: CGPoint(x: 54.33, y: 3.65), controlPoint2: CGPoint(x: 55.15, y: 4.2))
        fill1Path.addCurve(to: CGPoint(x: 61.02, y: 4.78), controlPoint1: CGPoint(x: 57.98, y: 2.53), controlPoint2: CGPoint(x: 59.52, y: 2.62))
        fill1Path.addCurve(to: CGPoint(x: 62.77, y: 6.95), controlPoint1: CGPoint(x: 61.45, y: 5.41), controlPoint2: CGPoint(x: 62, y: 6.01))
        fill1Path.addCurve(to: CGPoint(x: 62.77, y: 4.13), controlPoint1: CGPoint(x: 62.77, y: 5.74), controlPoint2: CGPoint(x: 62.77, y: 4.94))
        fill1Path.addCurve(to: CGPoint(x: 64.95, y: 2.74), controlPoint1: CGPoint(x: 62.78, y: 3.09), controlPoint2: CGPoint(x: 63.57, y: 2.65))
        fill1Path.addCurve(to: CGPoint(x: 66.74, y: 3.04), controlPoint1: CGPoint(x: 65.59, y: 2.78), controlPoint2: CGPoint(x: 66.22, y: 2.95))
        fill1Path.addCurve(to: CGPoint(x: 69.39, y: 1.76), controlPoint1: CGPoint(x: 67.55, y: 2.65), controlPoint2: CGPoint(x: 68.31, y: 2.29))
        fill1Path.addCurve(to: CGPoint(x: 72.46, y: 5.26), controlPoint1: CGPoint(x: 70.49, y: 3.02), controlPoint2: CGPoint(x: 71.47, y: 4.12))
        fill1Path.addCurve(to: CGPoint(x: 72.48, y: 3.55), controlPoint1: CGPoint(x: 72.46, y: 4.71), controlPoint2: CGPoint(x: 72.38, y: 4.12))
        fill1Path.addCurve(to: CGPoint(x: 76.1, y: 2.03), controlPoint1: CGPoint(x: 72.74, y: 2.03), controlPoint2: CGPoint(x: 74.17, y: 1.43))
        fill1Path.addCurve(to: CGPoint(x: 77.44, y: 2.8), controlPoint1: CGPoint(x: 76.55, y: 2.17), controlPoint2: CGPoint(x: 76.9, y: 2.48))
        fill1Path.addCurve(to: CGPoint(x: 78.25, y: 1.8), controlPoint1: CGPoint(x: 77.79, y: 2.36), controlPoint2: CGPoint(x: 77.97, y: 2.05))
        fill1Path.addCurve(to: CGPoint(x: 82.18, y: 1.85), controlPoint1: CGPoint(x: 79.46, y: 0.7), controlPoint2: CGPoint(x: 81.12, y: 0.71))
        fill1Path.addCurve(to: CGPoint(x: 83.27, y: 3.48), controlPoint1: CGPoint(x: 82.65, y: 2.35), controlPoint2: CGPoint(x: 83.04, y: 2.9))
        fill1Path.addCurve(to: CGPoint(x: 84.61, y: 7.39), controlPoint1: CGPoint(x: 83.78, y: 4.77), controlPoint2: CGPoint(x: 84.17, y: 6.09))
        fill1Path.addCurve(to: CGPoint(x: 85.54, y: 5.64), controlPoint1: CGPoint(x: 85.21, y: 6.8), controlPoint2: CGPoint(x: 85.57, y: 6.22))
        fill1Path.addCurve(to: CGPoint(x: 89.78, y: 1.09), controlPoint1: CGPoint(x: 85.41, y: 3.36), controlPoint2: CGPoint(x: 86.7, y: 1.81))
        fill1Path.close()
        
        fill1Path.fill()
       
    }
    func setUpRWLayer() {
        rwLayer.path = fill1Path.cgPath
        rwLayer.fillColor = rwColor.cgColor
        rwLayer.fillRule = kCAFillRuleNonZero
        rwLayer.lineCap = kCALineCapButt
        rwLayer.lineDashPattern = nil
        rwLayer.lineDashPhase = 5.0
        rwLayer.lineJoin = kCALineJoinMiter
        rwLayer.lineWidth = 7.0
        rwLayer.miterLimit = 10.0
        // rwLayer.strokeColor = rwColor.cgColor
        let transition = CATransition()
        transition.duration = 10
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)//kCAMediaTimingFunctionEaseInEaseOut)
        transition.startProgress = 0
       
        loadview.layer.add(transition, forKey: kCATransition)
       
        loader_image.sendSubview(toBack: loadview)
        main_loadingView.addSubview(loader_image)
        
        
       
}
    func time()
    {
        self .stopTimerTest()
    }
    
    func navigate() {
        
//        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
//        if (self.user == nil) {
//            self.user = self.pool?.currentUser()
//        }
//        self.refresh()

        let details = UserDefaults(suiteName: appGroupName)!.object(forKey: "user_details")
    
        if details == nil {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginDashboard") as? LoginSignupDashboardVC {
                
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else {
            //go_btn.sendActions(for: .touchUpInside)
            self.performSegue(withIdentifier: "gotoHomeSegue", sender: nil)
        }
        
        
    }

    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.go_btn.sendActions(for: .touchUpInside)

            })
            return nil
        }
    }

}
