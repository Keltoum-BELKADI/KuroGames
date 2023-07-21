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
    var nextGames: ((_ games: [Game]) -> Void)?
    var page: ((_ nextPage: String) -> Void)?
    var errorHappen: ((_ error: String) -> Void)?
    let gameService: GameService
    var delegate: PopupAlertDelegate?

    init(gameService: GameService) {
        self.gameService = gameService
    }

    func searchGames(title: String, searchResult: [Game], nextPage: String, controller: UIViewController, error: String){

        if title.isEmpty {
            Logger.log(.info, "titre vide ou trop court")
            delegate?.popupAlert(title: "Pas si vite...", message: "Vous devez saisir un nom pour effectuer une recherche")
        }

        GameService.shared.fetchSearchGames(search: title) { [weak self] result in

            guard let self = self else { return }
                switch result {
                case .success(let games):
                    guard let results = games.results,
                          let next = games.next else {
                        delegate?.apiCallFailed(state: true)
                        Logger.log(.error, "Request Failed")
                        return
                    }
                    
                    guard let games = self.listOfGames, let nextResults = self.page else { return }
                    games(results)
                    nextResults(next)
                    
                case .failure(let error):
                    guard let callFailed = self.errorHappen else { return }
                    callFailed(error.localizedDescription)
                }
        }
    }

    //load the next page of games data
    func loadMoreData(page: String, searchGames: [Game]) {
        GameService.shared.getDataFromUrl(next: page) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let games):
                guard let results = games.results,
                      let next = games.next else {
                    self?.delegate?.apiCallFailed(state: true)
                    Logger.log(.error, "Request Failed")
                    return
                }

                guard let games = self?.nextGames, let nextResults = self?.page else { return }
                games(results)
                nextResults(next)
            case .failure(let error):
                fatalError("Nous n'avons pas réussi à trouver de nouvelles pages. \(error.description)")
            }
        }
    }
}
