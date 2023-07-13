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
    var errorHappen: ((_ error: String) -> Void)?
    let gameService: GameService
    var alert: AlertManager?

    init(gameService: GameService) {
        self.gameService = gameService
        alert = AlertManager(viewModel: self)
    }

    func searchGames(title: String,searchResult: [Game], nextPage: String, controller: UIViewController, error: String){

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
                Logger.log(.warning, error.localizedDescription)
                alert?.showAlertMessage(title: "Accident ⛔️ ", message: "Nous n'avons pas trouvé votre jeu, veuillez saisir un nouveau nom")
            }
        }
    }

    //load the next page of games data
    func loadMoreData(page: String, searchGames: [Game]) {
        var gamesSearch = searchGames
        GameService.shared.getDataFromUrl(next: page) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let games):
                guard let gamesResult = games.results else { return }
                guard games.next != nil else { return }
                gamesSearch.append(contentsOf: gamesResult)
            case .failure(let error):
                fatalError("Nous n'avons pas réussi à trouver de nouvelles pages. \(error.description)")
            }
        }
    }
}
