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

     func searchGames(title: String,searchResult: [Game], nextPage: String, controller: UIViewController){

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

    //load the next page of games data
    func loadMoreData(nextPage: String, gamesSearch: [Game]) {
        var gamus = gamesSearch
        GameService.shared.getDataFromUrl(next: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                guard let gamesResult = games.results else { return }
                guard let next = games.next else { return }
                gamus.append(contentsOf: gamesResult)
            case .failure(let error):
                fatalError("Nous n'avons pas réussi à trouver de nouvelles pages. \(error.description)")
            }
        }
    }
}
