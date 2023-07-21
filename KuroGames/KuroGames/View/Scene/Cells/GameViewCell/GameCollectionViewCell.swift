//
//  GameCollectionViewCell.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 22/06/2023.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImage: UIImageView?
    @IBOutlet weak var gameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(game: Game) {
        guard let image = backgroundImage else { return }
        guard let gameLabel = gameLabel else { return }
        guard let backImage = game.backgroundImage else { return }
        gameLabel.text = game.name
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.darkGray.cgColor
        image.cacheImage(urlString: backImage)
        image.contentMode = .scaleToFill

    }

    func setupUI(game: WishlistGame) {
        guard let image = backgroundImage else { return }
        guard let gameLabel = gameLabel else { return }
        gameLabel.text = game.name
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.darkGray.cgColor
        image.contentMode = .scaleToFill
    }

    func setupUI(game: KuroGame) {
        guard let image = backgroundImage else { return }
        guard let gameLabel = gameLabel else { return }
        gameLabel.text = game.name
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.darkGray.cgColor
        image.contentMode = .scaleToFill

    }

}
