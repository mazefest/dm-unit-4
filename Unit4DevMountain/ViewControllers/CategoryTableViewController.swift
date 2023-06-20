//
//  CategoryTableViewController.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/19/23.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    var category: Category?
    var businesses: [Business] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let category = category else { return }
        NetworkController.shared.fetchBusiness(type: category.title) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    print("\(data.businesses.count)")
                    self.businesses = data.businesses
                    self.tableView.reloadData()
                }
            case .failure(_):
                break;
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catSuggestionCell", for: indexPath)
        if businesses.isEmpty { return UITableViewCell() }
        let business = businesses[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = business.name
        content.textProperties.color = .label
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        content.textToSecondaryTextVerticalPadding = 4
        
        content.secondaryText = "\(business.rating)"
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        content.image = UIImage(named: category?.imageName ?? "")
        content.imageProperties.maximumSize =  CGSize(width: 50, height: 50)
        content.imageToTextPadding = 16
        
        cell.contentConfiguration = content
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? DetailMenuViewController,
                  let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let business = businesses[indexPath.row]
            destinationVC.business = business
        }
    }

}
