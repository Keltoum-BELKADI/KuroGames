//
//  CoreDataManager.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    //MARK: Property
    let managedObjectContext: NSManagedObjectContext
   
    //MARK: Iniialization
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.managedObjectContext = managedObjectContext
    }
    //MARK: Methods
    //add game to Data Base
    func addGame(game: Game) {
        
        let platformsList = game.createSlugList(for: game.platforms)
        let entity = KuroGame(context: managedObjectContext)
        guard let rating = game.rating else { return }
        entity.name = game.name
        entity.rating = rating
        entity.release_date = game.released
        entity.backgroundImage = game.backgroundImage?.data(using: .utf8)
        entity.platform = platformsList
  
        CoreDataStack.shared.saveContext()
    }
    
    
    //add Data to a array
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
    //remove game in a list of games
    func removeGameInArray(row: Int, array: [KuroGame]) {
        managedObjectContext.delete(array[row])
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove \(error.localizedDescription)")
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
            debugPrint("Couldn't remove \(error.localizedDescription)")
        }
    }
    
    //check if already added
    func checkGameIsAlreadySaved(with name: String?) -> Bool {
        guard let name = name else { return false }
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let gamesList = try? managedObjectContext.fetch(request) else { return false }
        return !gamesList.isEmpty
    }
    
    //filter games by platform 
    func fetchGamesByPlatform(listOfGames: [KuroGame], platform: String) -> [KuroGame] {
        var gamesList = listOfGames
        let request: NSFetchRequest<KuroGame> = KuroGame.fetchRequest()
        gamesList = try! managedObjectContext.fetch(request)
        let platformGames = gamesList.filter { $0.platform?.range(of: platform) != nil}
        return platformGames
    }
    
}
