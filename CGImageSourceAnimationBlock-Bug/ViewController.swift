//
//  ViewController.swift
//  CGImageSourceAnimationBlock-Bug
//
//  Created by Jesse Halley on 21/11/20.
//

import ImageIO
import UIKit

final class ViewController: UIViewController {
    let singleFrameGIFURL = Bundle.main.url(forResource: "SingleFrameGIF", withExtension: "gif")!
    let animatedGIFURL = Bundle.main.url(forResource: "AnimatedGIF", withExtension: "gif")!

    lazy var imageView = UIImageView()
    lazy var segmentedControl = UISegmentedControl(items: ["No Animation", "Single Frame GIF", "Animated GIF"])
    
    private var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addAction(segmentedControlChanged, for: .primaryActionTriggered)
        navigationItem.titleView = segmentedControl
        navigationItem.largeTitleDisplayMode = .never

        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(contentsOfFile: self.singleFrameGIFURL.path)!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    var segmentedControlChanged: UIAction {
        UIAction { [unowned self] (action) in
            self.flag += 1
            let segmentedControl = action.sender as! UISegmentedControl
            if segmentedControl.selectedSegmentIndex == 0 {
                self.imageView.image = UIImage(contentsOfFile: self.singleFrameGIFURL.path)!
            } else {
                let url = segmentedControl.selectedSegmentIndex == 1 ? self.singleFrameGIFURL : self.animatedGIFURL
                
                let options = [
                            kCGImageAnimationStartIndex: 0 as CFNumber,
                            kCGImageAnimationLoopCount: kCFNumberPositiveInfinity
                        ] as CFDictionary
                
                let rawStatus = CGAnimateImageAtURLWithBlock(url as CFURL, options) { [weak self, flag] (_, frame, stop) in
                    guard let self = self, self.flag == flag else {
                        stop.pointee = true
                        print("Stopping animation")
                        return
                    }
                    self.imageView.image = UIImage(cgImage: frame)
                }
                
                switch CGImageAnimationStatus(rawValue: rawStatus)! {
                case .parameterError: print("🔴 Error: parameterError")
                case .corruptInputImage: print("🔴 Error: corruptInputImage")
                case .unsupportedFormat: print("🔴 Error: unsupportedFormat")
                case .incompleteInputImage: print("🔴 Error: incompleteInputImage")
                case .allocationFailure: print("🔴 Error: allocationFailure")
                @unknown default: break
                }
            }
        }
    }
}
