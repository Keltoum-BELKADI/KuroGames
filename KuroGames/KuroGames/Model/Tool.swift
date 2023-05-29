//
//  Tool.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import Foundation
import UIKit
import CoreData

class Tool {
    //MARK: properties
    static let shared = Tool()
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    //MARK: Methods
    func getDoubleToString(number : Double?)-> (String) {
        //convert a Int? to String
        // unwrapped the optional with a guard let syntax
        guard let fullNumber = number  else { return "N/A"}
        let numberValue = Int(fullNumber)
        //convert a Int? to String
        let ID = String(numberValue)
        
        return ID
    }
    //
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
