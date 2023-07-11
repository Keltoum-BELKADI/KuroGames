//
//  GameCardViewModel.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 11/07/2023.
//

import Foundation

class GameCardViewModel{

    func listOfScreenshots(game: Game, images: [String]) -> [String] {
        var list = images
        game.short_screenshots?.forEach({ image in
            guard let screenshot = image.image else { return }
            if screenshot != game.short_screenshots?.last?.image {
                list.append(screenshot)
            } else {
                list.append(screenshot)
            }
        })
        return list
    }
}
