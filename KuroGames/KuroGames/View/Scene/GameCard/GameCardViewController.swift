//
//  GameCardViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 08/06/2023.
//

import UIKit

class GameCardViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var editorLabel: UILabel?
    @IBOutlet private var gameImage: UIImageView?
    @IBOutlet private var addFavoriteBTN: UIButton?
    @IBOutlet private var addWishListBTN: UIButton?
    @IBOutlet private var screenshortCollectionView: UICollectionView?
    @IBOutlet private var infoContainer: UIView?

    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 270, height: 170)
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        return layout
    }()
    let nibRegistrationID = "ScreenshotViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        guard let screenshots = screenshortCollectionView else { return }
        guard let container = infoContainer else { return }
        guard let gamerCover = gameImage else { return }
        guard let wishBTN = addWishListBTN else { return }
        guard let favBTN = addFavoriteBTN else { return }
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        let nibCell = UINib(nibName: nibRegistrationID, bundle: nil)
        screenshots.register(nibCell, forCellWithReuseIdentifier: nibRegistrationID)
        screenshots.dataSource = self
        screenshots.delegate = self
        screenshots.collectionViewLayout = layout
        container.layer.cornerRadius = 10

        for element in [gamerCover, favBTN, wishBTN] {
            element.layer.cornerRadius = 5
        }
    }
}

extension GameCardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotViewCell", for: indexPath) as! ScreenshotViewCell
        return cell
    }
}

//extension GameCardViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat = 25
//            let collectionViewSize = collectionView.frame.size.width - padding
//            return CGSize(width: collectionViewSize/2, height: 150)
//    }
//}
