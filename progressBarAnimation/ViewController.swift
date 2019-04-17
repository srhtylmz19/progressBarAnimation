//
//  ViewController.swift
//  CircularLoaderLBTA
//
//  Created by Brian Voong on 12/8/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/battery-hub.appspot.com/o/Ekran%20Resmi%202019-04-17%2010.47.11.png?alt=media&token=d49e07e9-646f-4686-a8c1-6e94f91124d8"
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    let shapeLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = UIColor.rgb(r: 234, g: 46, b: 111).cgColor
        layer.lineWidth = 15
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.strokeEnd = 0
        layer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        return layer
    }()
    let trackLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = UIColor.rgb(r: 56, g: 25, b: 49).cgColor
        layer.lineWidth = 20
        layer.fillColor = UIColor.rgb(r: 21, g: 22, b: 33).cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        return layer
    }()
    
    let shadowAnimation : CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        return animation
    }()
    
    let pulsatingLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 15
        layer.fillColor = UIColor.rgb(r: 86, g: 30, b: 63).cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.backgroundColor
        
        setupAddView()
        setupAnchor()
        setupShadowAnimation()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    fileprivate func setupAddView(){
        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(percentageLabel)

    }
    fileprivate  func setupAnchor() {
        trackLayer.position = view.center
        shapeLayer.position = view.center
        pulsatingLayer.position = view.center
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 150)
        percentageLabel.center = view.center
    }
    
    fileprivate func setupShadowAnimation(){
        pulsatingLayer.add(shadowAnimation, forKey: "pulsing")
    }
    
    fileprivate func beginDownloadingFile() {
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        changePercentageLabelText(percentage: percentage)
    }
    
    fileprivate func changePercentageLabelText(percentage: CGFloat){
        DispatchQueue.main.async {
            let mutableAttributedString = NSMutableAttributedString()
            var myAttrString2 = NSAttributedString()
            
            let myString = "\(Int(percentage * 100))% \n"
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 24.0)! ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            if percentage == 1.0 {
                let myString2 = "Download Completed.."
                let myAttribute2 = [ NSAttributedString.Key.font: UIFont(name: "Georgia", size: 10.0)! ]
                myAttrString2 = NSAttributedString(string: myString2, attributes: myAttribute2)
            }else {
                let myString2 = "downloading.."
                let myAttribute2 = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 10.0)! ]
                myAttrString2 = NSAttributedString(string: myString2, attributes: myAttribute2)
            }
            mutableAttributedString.append(myAttrString)
            mutableAttributedString.append(myAttrString2)
            
            self.percentageLabel.attributedText = mutableAttributedString
            
        }
    }
    
    //MARK : URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }

    @objc private func handleTap() {
        beginDownloadingFile()
    }
    
}
















