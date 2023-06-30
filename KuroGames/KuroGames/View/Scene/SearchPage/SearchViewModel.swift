//
//  SearchViewModel.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 27/06/2023.
//

import Foundation
import UIKit

class SearchViewModel {
    var listOfGames: ((_ games: [Game]) -> Void)?
    var page: ((_ nextPage: String) -> Void)?
    let gameService: GameService

    init(gameService: GameService) {
        self.gameService = gameService
    }

     func searchGames(title: String, mutating searchResult: [Game], nextPage: String, controller: UIViewController){

        GameService.shared.fetchSearchGames(search: title) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                guard let results = games.results,
                      let next = games.next else { return }
                DispatchQueue.main.async {
                    guard let games = self.listOfGames, let nextResults = self.page else { return }
                    games(results)
                    nextResults(next)
                }
            case .failure(let error):
                Logger.log(.info, error.localizedDescription + "\n nous n'avons pas trouver votre jeu, veuillez saisir un autre nom.")
            }
        }
    }
}
