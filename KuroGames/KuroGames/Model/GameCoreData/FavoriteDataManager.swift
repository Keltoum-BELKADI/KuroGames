//
//  CoreDataManager.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import Foundation
import CoreData

class FavoriteDataManager {
    //MARK: Property
    let managedObjectContext: NSManagedObjectContext
   
    //MARK: Iniialization
    init(managedObjectContext: NSManagedObjectContext = CoreDataFavoriteStack.favoriteShared.mainContext ) {
        self.managedObjectContext = managedObjectContext
    }
    //MARK: Methods
    //MARK: add game to Data Base
    func addFavoriteGame(game: Game) {
        let context = CoreDataFavoriteStack.favoriteShared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "KuroGame", into: context) as? KuroGame else { return }
        let platformsList = game.createSlugList(for: game.platforms)
        guard let rating = game.rating else { return }
        entity.name = game.name
        entity.rating = rating
        entity.release_date = game.released
        entity.backgroundImage = game.backgroundImage?.data(using: .utf8)
        entity.platform = platformsList
  
        CoreDataFavoriteStack.favoriteShared.saveContext()
    }

    //MARK: fetch Data to a array
    //add Data for Favorite to a array
    func fetchGames(mygames: [KuroGame]) -> [KuroGame] {
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        request.returnsObjectsAsFaults = false 
        do {
            var mygamesList = mygames
            mygamesList = try managedObjectContext.fetch(request)
            return mygamesList
        } catch {
            return []
        }
    }

    //MARK: remove Data to a array
    //remove game in a list of games
    func removeGameInArray(row: Int, array: [KuroGame]) {
        managedObjectContext.delete(array[row])
        do {
            try managedObjectContext.save()
        } catch {
            Logger.log(.debug, "Couldn't remove \(error.localizedDescription)")
        }
    }
    //remove a game from Core Data Base 
    func removeGame(name: String) {
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let game = try? managedObjectContext.fetch(request) else { return }
        game.forEach { game in
            managedObjectContext.delete(game)
        }
        do {
            try managedObjectContext.save()
        } catch {
            Logger.log(.debug, "Couldn't remove \(error.localizedDescription)")
        }
    }

    //MARK: check Data already exist
    //check if already added
    func checkGameIsAlreadySaved(with name: String?) -> Bool {
        guard let name = name else { return false }
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let gamesList = try? managedObjectContext.fetch(request) else { return false }
        return !gamesList.isEmpty
    }

    //MARK: filter by platform
    //filter games by platform 
    func fetchGamesByPlatform(listOfGames: [KuroGame], platform: String) -> [KuroGame] {
        var gamesList = listOfGames
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        gamesList = try! managedObjectContext.fetch(request)
        let platformGames = gamesList.filter { $0.platform?.range(of: platform) != nil}
        return platformGames
    }
}
