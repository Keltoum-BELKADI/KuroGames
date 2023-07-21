//
//  UIViewController+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 20/02/2022.
//

import UIKit
import CoreData

protocol PopupAlertDelegate {
    func popupAlert(title: String, message: String)
    func apiCallFailed(state: Bool)
}

