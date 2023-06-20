//
//  HomeViewController.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/17/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var orderNowView: UIView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var orderButton: IRButton!
    
    var suggestedBusinesses: [Business] = []
    var tally: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        
        NetworkController.shared.fetchBusiness(type: "pizza") { result in
            switch result {
            case .success(let data):
                self.suggestedBusinesses = data.businesses
                DispatchQueue.main.async {
                    self.suggestionsCollectionView.reloadData()
                }
            case .failure(_):
                break;
            }
        }
        
        
        orderButton.setTitle("No Orders", for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tally != 0 {
            orderButton.setTitle("\(tally) orders", for: .normal)
        }
    }
    
    @IBAction func onOrderButtonTapped(_ sender: Any) {
        if tally == 0 {
            DispatchQueue.main.async {
                self.driverImage.shake()
            }
        } else {
            DispatchQueue.main.async {
                self.animateOffScreen(imageView: self.driverImage) { _ in
                    self.tally = 0
                    self.orderButton.setTitle("No Orders", for: .normal)
                }
            }
        }
    }
    
    func animateOffScreen(imageView: UIImageView, completion: @escaping (Bool) -> ()) {
        let originalCenter = imageView.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                imageView.center.x -= 80.0
                imageView.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: -.pi / 80)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                imageView.center.x -= 100.0
                imageView.center.y += 50.0
                imageView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                imageView.transform = .identity
                imageView.center = CGPoint(x:  900.0, y: 100.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                imageView.center = originalCenter
                imageView.alpha = 1.0
            }
            
        }, completion: completion)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toCategoryList" {
            guard let destinationVC = segue.destination as? CategoryTableViewController,
                  let cell = sender as? CategoryCollectionViewCell,
                  let indexPath = self.categoryCollectionView.indexPath(for: cell) else { return }
            
            let category = CategoryOptions.categories[indexPath.row]
            destinationVC.category = category
            
        }
        
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? DetailMenuViewController,
                  let cell = sender as? SuggestedCollectionViewCell,
                  let indexPath = self.suggestionsCollectionView.indexPath(for: cell) else { return }
            
            let businessDetails = self.suggestedBusinesses[indexPath.row]
            
            destinationVC.business = businessDetails
            destinationVC.delegate = self
        }
    }
    
}

extension HomeViewController: DetailMenuViewControllerDelegate {
    func onAddToCartTapped() {
        tally += 1
        DispatchQueue.main.async {
            self.orderButton.setTitle("Order Now \(self.tally)", for: .normal)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return CategoryOptions.categories.count
        } else {
            return suggestedBusinesses.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            let category = CategoryOptions.categories[indexPath.row]
            categoryCell.category = category
            
            return categoryCell

        } else {
            guard let cell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let business = suggestedBusinesses[indexPath.row]
            cell.businessNameLabel.text = business.name
            cell.priceLabel.text = business.price
            cell.ratingLabel.text = String(business.rating)
            cell.locationLabel.text = "\(business.location?.city ?? ""), \(business.location?.state ?? "")"
            cell.businessImage.load(yelp: business.imageURL ?? "")
            return cell
        }
    }
}
