//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Eken Özlü on 29.05.2023.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    let searchVC = UISearchController(searchResultsController: nil)
    
    var searchNewsArray = [Articles]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.isEmpty){
            APICaller.shared.search(with: searchText) { result in
                switch result {
                case .success(let articles):
                    self.searchNewsArray = articles
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchNewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        newsCell.titleLabel?.text = searchNewsArray[indexPath.row].title
        newsCell.descriptionLabel?.text = searchNewsArray[indexPath.row].description ?? "No Description"
        newsCell.authorLabel?.text = searchNewsArray[indexPath.row].author ?? "No Author"
        newsCell.publishedAtLabel?.text = searchNewsArray[indexPath.row].publishedAt ?? "No Date"
        if searchNewsArray[indexPath.row].urlToImage != nil {
            newsCell.cellImageView?.load(url: URL(string: searchNewsArray[indexPath.row].urlToImage!)!)
        }
        else {
            newsCell.cellImageView?.image = UIImage(systemName: "photo")
            newsCell.cellImageView?.contentMode = .center
        }
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedURL = URL(string: searchNewsArray[indexPath.row].url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: selectedURL)
        self.present(vc, animated: true)
    }

}
