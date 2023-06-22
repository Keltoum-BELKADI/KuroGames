//
//  GameCollectionViewCell.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 22/06/2023.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var backgroundImage: UIImageView?
    @IBOutlet private var gameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI() {
        guard let image = backgroundImage else { return }
        image.layer.cornerRadius = 5
    }

}
