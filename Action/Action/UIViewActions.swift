//
//  UIViewAction.swift
//  Treasure
//
//  Created by Apple on 2017/3/23.
//  Copyright © 2017年 YDS. All rights reserved.
//

import UIKit
import CoreGraphics
extension UIView {

    /// Translate Action
    ///
    /// - Parameters:
    ///   - duration: duration
    ///   - x: x offset
    ///   - y: y offset
    /// - Returns: UIView translate action
    func translate(duration:TimeInterval,x:CGFloat,y:CGFloat)->Action {
        return .custom({[unowned self] action in
 
            UIView.animate(withDuration: duration, animations: {
                self.frame.origin.x += x
                self.frame.origin.y += y
            }, completion: { (finished) in
                action.finish()
            })
        })
    }
    
    
    /// Rotate Action
    ///
    /// - Parameters:
    ///   - duration: duration
    ///   - angle: angle
    /// - Returns: UIView rotate action
    func rotate(duration:TimeInterval,angle:CGFloat)->Action {
        return .custom({[unowned self] action in
            let result = self.transform.rotated(by: angle)
            UIView.animate(withDuration: duration, animations: {
                self.transform = result
            }, completion: { (finished) in
                self.transform = result
                action.finish()
            })
        })
    }
    
    /// Scale Action
    ///
    /// - Parameters:
    ///   - duration: duration
    ///   - x: x offset
    ///   - y: y offset
    /// - Returns: UIView scale action
    func scale(duration:TimeInterval,x:CGFloat,y:CGFloat)->Action {
        return .custom({[unowned self] action in
            UIView.animate(withDuration: duration, animations: {
                self.frame.size = CGSize(width: self.frame.size.width*x, height: self.frame.size.height*y)
            }, completion: { (finished) in
                action.finish()
            })
        })
    }
}
