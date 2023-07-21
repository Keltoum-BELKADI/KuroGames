//
//  GameCardViewModel.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 11/07/2023.
//

import Foundation
import CoreData

class GameCardViewModel{
    //Core Data Managers
    let wishListDataManager =  WishlistDataManager(managedObjectContext: CoreDataStackWishlist.wishListShared.mainContext)
    let favoriteDataManager =  FavoriteDataManager(managedObjectContext: CoreDataFavoriteStack.favoriteShared.mainContext)
    var delegate: PopupAlertDelegate?

    init() {
    }

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

    func saveInWishlist(game: Game){
        wishListDataManager.addWishlistGame(game: game)
        delegate?.popupAlert(title: "Bravo", message: "Le jeu vidéo a bien été enregistré dans ta wishlist.")
    }

    func saveInFavorite(game: Game){
        favoriteDataManager.addFavoriteGame(game: game)
        delegate?.popupAlert(title: "Bravo", message: "Le jeu vidéo a bien été enregistré dans tes favoris.")
    }

    func alreadySaveInWishList(game : Game) {
        print(wishListDataManager.checkGameIsAlreadySaved(with: game.name))
        if wishListDataManager.checkGameIsAlreadySaved(with: game.name) {
            delegate?.popupAlert(title: "Oups", message: "Tu as déja rajouté ce jeu à ta liste")
        } else {
            saveInWishlist(game: game)
        }
    }

    func alreadySaveInFavorite(game : Game) {
        print(favoriteDataManager.checkGameIsAlreadySaved(with: game.name))
        if favoriteDataManager.checkGameIsAlreadySaved(with: game.name) {
            delegate?.popupAlert(title: "Oups", message: "Tu as déja rajouté ce jeu à ta liste")
        } else {
            saveInFavorite(game: game)
        }
    }
}
