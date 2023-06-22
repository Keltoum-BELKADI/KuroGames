//
//  ViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 29/05/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private var homeBTN: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let button = homeBTN else { return }
        button.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }


}

