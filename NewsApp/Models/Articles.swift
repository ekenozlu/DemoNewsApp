//
//  Articles.swift
//  NewsApp
//
//  Created by Eken Özlü on 5.06.2023.
//

import Foundation

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
