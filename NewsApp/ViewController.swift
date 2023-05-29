//
//  ViewController.swift
//  NewsApp
//
//  Created by Eken Özlü on 29.05.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    
    var categoryArray : [NewsCategory] = [
        .init(categoryApiLabel: "business", categoryText: "Business", categoryImage: UIImage(systemName: "briefcase.fill")!),
        .init(categoryApiLabel: "entertainment", categoryText: "Entertainment", categoryImage: UIImage(systemName: "theatermasks.fill")!),
        .init(categoryApiLabel: "general", categoryText: "General", categoryImage: UIImage(systemName: "globe")!),
        .init(categoryApiLabel: "health", categoryText: "Health", categoryImage: UIImage(systemName: "heart.text.square")!),
        .init(categoryApiLabel: "science", categoryText: "Science", categoryImage: UIImage(systemName: "atom")!),
        .init(categoryApiLabel: "sports", categoryText: "Sport", categoryImage: UIImage(systemName: "soccerball.inverse")!),
        .init(categoryApiLabel: "technology", categoryText: "Technology", categoryImage: UIImage(systemName: "cpu")!),
    ]
    
    var newsArray = [Articles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular News"

        APICaller.shared.getTopHeadlines { result in
            switch result {
            case .success(let articles):
                self.newsArray = articles
                
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.isEmpty){
            APICaller.shared.search(with: searchText) { result in
                switch result {
                case .success(let articles):
                    self.newsArray = articles
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        categoryCell.categoryImageView.image = categoryArray[indexPath.row].categoryImage
        categoryCell.categoryLabel.text = categoryArray[indexPath.row].categoryText
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        APICaller.shared.getCategoryHeadlines(with: categoryArray[indexPath.row].categoryApiLabel) { result in
            switch result {
            case .success(let articles):
                self.newsArray = articles
                
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        newsCell.titleLabel?.text = newsArray[indexPath.row].title
        newsCell.descriptionLabel?.text = newsArray[indexPath.row].description ?? "No Description"
        newsCell.authorLabel?.text = newsArray[indexPath.row].author ?? "No Author"
        newsCell.publishedAtLabel?.text = newsArray[indexPath.row].publishedAt ?? "No Date"
        if newsArray[indexPath.row].urlToImage != nil {
            newsCell.cellImageView?.load(url: URL(string: newsArray[indexPath.row].urlToImage!)!)
        }
        else {
            newsCell.cellImageView?.image = UIImage(systemName: "photo")
            newsCell.cellImageView?.contentMode = .center
        }
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedURL = URL(string: newsArray[indexPath.row].url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: selectedURL)
        self.present(vc, animated: true)
    }
 
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

