//
//  WishlistDataManager.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 18/07/2023.
//

import Foundation
import CoreData

class WishlistDataManager {
    //MARK: Property
    let managedObjectContext: NSManagedObjectContext

    //MARK: Iniialization
    init(managedObjectContext: NSManagedObjectContext = CoreDataStackWishlist.wishListShared.mainContext) {
        self.managedObjectContext = managedObjectContext
    }

        //MARK: add game to Data Base
    func addWishlistGame(game: Game) {
        let context = CoreDataStackWishlist.wishListShared.wishListPersistentContainer.viewContext
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "WishlistGame", into: context) as? WishlistGame else { return }
        let platformsList = game.createSlugList(for: game.platforms)
        guard let rating = game.rating else { return }
        entity.name = game.name
        entity.rating = rating
        entity.release_date = game.released
        entity.backgroundImage = game.backgroundImage?.data(using: .utf8)
        entity.platform = platformsList

        CoreDataStackWishlist.wishListShared.saveContext(context: context)
    }

    //MARK: fetch Data to a array
    //add Data for WishList to a array
    func fetchWishlist(mygames: [WishlistGame]) -> [WishlistGame] {
        let request: NSFetchRequest<WishlistGame> = WishlistGame.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            var myWishList = mygames
            myWishList = try managedObjectContext.fetch(request)
            return myWishList
        } catch {
            return []
        }
    }

    //MARK: remove Data to a array
    //remove game in a list of games
    func removeGameInArray(row: Int, array: [WishlistGame]) {
        managedObjectContext.delete(array[row])
        do {
            try managedObjectContext.save()
        } catch {
            Logger.log(.debug, "Couldn't remove \(error.localizedDescription)")
        }
    }
    //remove a game from Core Data Base
    func removeGame(name: String) {
        let request: NSFetchRequest<WishlistGame> = WishlistGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let game = try? managedObjectContext.fetch(request) else { return }
        game.forEach { game in
            managedObjectContext.delete(game)
        }
        do {
            try managedObjectContext.save()
        } catch {
            Logger.log(.debug,"Couldn't remove \(error.localizedDescription)")
        }
    }

    //MARK: check Data already exist
    //check if already added
    func checkGameIsAlreadySaved(with name: String?) -> Bool {
        guard let name = name else { return false }
        let request: NSFetchRequest<WishlistGame> = WishlistGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let gamesList = try? managedObjectContext.fetch(request) else { return false }
        return !gamesList.isEmpty
    }

    //MARK: filter by platform
    //filter games by platform
    func fetchGamesByPlatform(listOfGames: [WishlistGame], platform: String) -> [WishlistGame] {
        var gamesList = listOfGames
        let request: NSFetchRequest<WishlistGame> = WishlistGame.fetchRequest()
        gamesList = try! managedObjectContext.fetch(request)
        let platformGames = gamesList.filter { $0.platform?.range(of: platform) != nil}
        return platformGames
    }
}

