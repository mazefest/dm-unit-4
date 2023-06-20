//
//  CategoryCollectionViewCell.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/17/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let category = category else { return }
        categoryLabel.text = category.title
        categoryImage.image = UIImage(named: category.imageName)
    }
}
