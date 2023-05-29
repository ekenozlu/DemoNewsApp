//
//  APICaller.swift
//  NewsApp
//
//  Created by Eken Özlü on 29.05.2023.
//

import Foundation
import UIKit

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let generalURL           = "https://newsapi.org/v2/"
        static var sortParameter        = "sortedBy=popularity&"
        static var countryParameter     = "country=us"
        static var categoryParameter    = "category=sport&"
        static var pageSizeParameter    = "pageSize=100&"
        static var apiKey               = "apiKey=75d49b8f9121404c9ffd1843321413f4"
        static let topHeadlinesURL      = generalURL + "top-headlines?" + apiKey + "&" + countryParameter
        static let searchURL            = generalURL + "everything?" + apiKey
    }
    
    private init() {}
    
    public func getTopHeadlines(completion: @escaping (Result<[Articles],Error>) -> Void){
        guard let url = URL(string: Constants.topHeadlinesURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getCategoryHeadlines(with category:String,completion: @escaping (Result<[Articles],Error>) -> Void){
        let urlString = Constants.topHeadlinesURL + "&category=" + category
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Articles],Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchURL + "&q=" + query
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


//Model

struct NewsCategory {
    let categoryApiLabel : String
    let categoryText : String
    let categoryImage : UIImage
}

struct APIResponse: Codable {
    let totalResponse : Int?
    let articles : [Articles]
}

struct Articles: Codable {
    let source : Source
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
}

struct Source : Codable {
    let name : String
}


//https://newsapi.org/v2/top-headlines?apiKey=75d49b8f9121404c9ffd1843321413f4
