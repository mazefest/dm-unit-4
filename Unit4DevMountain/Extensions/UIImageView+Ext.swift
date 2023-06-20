//
//  UIImageView+Ext.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/18/23.
//

import Foundation
import UIKit

extension UIImageView {
    func load(yelp imageUrl: String) {
        DispatchQueue.global().async { [weak self] in
            guard let urlString = URL(string: imageUrl) else { return }
            if let data = try? Data(contentsOf: urlString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
