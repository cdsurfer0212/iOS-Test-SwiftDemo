//
//  CountLabel.swift
//  SwiftDemo
//
//  Created by Sean Zeng on 7/2/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit

class CountLabel: UILabel {

    var displayLink: CADisplayLink?
    var duration: Float?
    var originalText: String?
    var originalTextFormat: String?
    var startTime: Double?
    var targetNumber: Int?
    
    typealias progressClosure = (CountLabel, Double) -> Void
    //var progressBlock: progressClosure = { countLabel, progress in
    //}
    var progressBlock: progressClosure?

    func countToNumber(targetNumber: Int, duration: Float, progressBlock: (progressClosure)? = nil) {
        self.duration = duration
        self.targetNumber = targetNumber
        self.progressBlock = progressBlock!
        
        displayLink?.invalidate()
        displayLink = CADisplayLink.init(target: self, selector: #selector(self.updateText))
        displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)

        originalText = (text != nil) ? text : attributedText!.string
        let numberInOriginalText: String = originalText!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        originalTextFormat = originalText?.stringByReplacingOccurrencesOfString(numberInOriginalText, withString: "%.0f")
        
        startTime = CACurrentMediaTime()
    }
    
    func updateText(displayLink: CADisplayLink) {
        var progress = (displayLink.timestamp - startTime!) / Double(duration!)
        
        if (displayLink.timestamp >= startTime! + Double(duration!)) {
            displayLink.invalidate()
            progress = 1.0;
        }
        
        let newNumber = Double(originalText!)! + (Double(targetNumber!) - Double(originalText!)!) * progress
        self.text = String(format: originalTextFormat!, newNumber)
        self.sizeToFit()

        if (progressBlock != nil) {
            progressBlock!(self, progress)
        }
    }
}
