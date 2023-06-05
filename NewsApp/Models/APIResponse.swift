//
//  APIResponse.swift
//  NewsApp
//
//  Created by Eken Özlü on 5.06.2023.
//

import Foundation

struct APIResponse: Codable {
    let totalResponse : Int?
    let articles : [Articles]
}
