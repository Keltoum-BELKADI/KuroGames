//
//  CoreDataStackWishlist.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 20/07/2023.
//
import Foundation
import CoreData

class CoreDataStackWishlist {

    //MARK: property
    // Conteneur persistant pour "WishListGames"
    var wishListPersistentContainer: NSPersistentContainer

    //MARK: Singleton property
    static let wishListShared =  CoreDataStackWishlist(modelName: "KuroGames")

    //MARK: Iniialization
    init(modelName: String) {
        wishListPersistentContainer = NSPersistentContainer(name: modelName)
        wishListPersistentContainer.loadPersistentStores { (storeDescription, error) in
            guard let unwrappedError = error else { return }
            fatalError("Unsolved error \(unwrappedError.localizedDescription)")
        }
    }
    var mainContext: NSManagedObjectContext {
        return wishListPersistentContainer.viewContext
    }

    //MARK: Method to save
    func saveContext(context: NSManagedObjectContext) {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Erreur lors de l'enregistrement du contexte \(nserror), \(nserror.userInfo)")
                }
            }
        }
}
