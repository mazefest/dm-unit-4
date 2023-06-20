//
//  UIView+Ext.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/18/23.
//

import Foundation
import UIKit

extension UIView {
    
    func shake() {
        let translateRight = CGAffineTransform(translationX: 4.0, y: 0)
        let translateLeft = CGAffineTransform(translationX: -4.0, y: 0)
        
        self.transform = translateRight
        
        UIView.animate(withDuration: 0.07, delay: 0.01, options: [.autoreverse, .repeat]) {
            
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                self.transform = translateLeft
            }
        } completion: { _ in
            self.transform = CGAffineTransform.identity
        }
    }
    
}
