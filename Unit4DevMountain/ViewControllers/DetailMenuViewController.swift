//
//  DetailMenuViewController.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/18/23.
//

import UIKit

class DetailMenuViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var businesssNameLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    @IBOutlet weak var priceAndCategoryLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var business: Business?
    var delegate: DetailMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let business = business else { return }
        detailImageView.load(yelp: business.imageURL ?? "")
        businesssNameLabel.text = business.name
        businessRatingLabel.text = String(business.rating)
        priceAndCategoryLabel.text = "\(business.price ?? "") \(business.categories.first?.title ?? "")"
        isOpenLabel.text = "Open Now"
        styleDismissButton()
    }
    
    func businessIsOpen(_ isOpen: Bool) -> String {
        return isOpen ? "Open" : "Closed"
    }
    
    func styleDismissButton() {
        dismissButton.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)), for: .normal)
        dismissButton.backgroundColor = UIColor(named: "Accent")
    }
    
    // MARK: Intents
    @IBAction func onAddCartButtonTapped(_ sender: Any) {
        delegate?.onAddToCartTapped()
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
