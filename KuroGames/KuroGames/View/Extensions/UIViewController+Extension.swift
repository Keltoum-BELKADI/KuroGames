//
//  UIViewController+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 20/02/2022.
//

import UIKit
import CoreData

class AlertView{
    
    //MARK: Pop-Up Alert 
    func showAlertMessage(title: String, message: String, controller: UIViewController) {
          let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true)
      }
    
    func showAlertMessageBeforeToDismiss(title: String, message: String, controller: UIViewController) {
          let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { UIAlertAction in
            controller.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true)
      }
    
    func errorAlert(_ message: String, _ controller: UIViewController) {
        let c = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        c.addAction(ok)
        controller.present(c, animated: true, completion: nil)
    }
}


