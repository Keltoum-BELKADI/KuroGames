//
//  Items.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import Foundation
// MARK: - ItemsList
struct ItemsList: Decodable {
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}
// MARK: - Item
struct Item: Decodable {
    let ean: String?
    let title: String?
    let description: String?
    let elid: String?
    
    enum CodingKeys: String, CodingKey {
        case ean = "ean"
        case title = "title"
        case description = "description"
        case elid = "elid"
    }
}
