//
//  MyLibraryElements.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import Foundation
//MARK: Class to create an object to manage background image and list of games in Library 
class MyLibraryElements {
    var image: String
    var myGames: [KuroGame]
    
    init(background: String, games: [KuroGame]) {
        self.image = background
        self.myGames = games
    }
}
