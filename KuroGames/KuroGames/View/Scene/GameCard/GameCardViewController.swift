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
    @IBOutlet private var blurBackGround: UIImageView?
    @IBOutlet private var infoContainer: UIView?

    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 270, height: 170)
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        return layout
    }()
    let nibRegistrationID = "ScreenshotViewCell"
    var game: Game?
    var screenshots = [String]()
    var gameCardViewModel = GameCardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        guard let screenshotsCollectionView = screenshortCollectionView else { return }
        guard let container = infoContainer else { return }
        guard let gameCover = gameImage else { return }
        guard let blurCover = blurBackGround else { return }
        guard let gameTitle = nameLabel else { return }
        guard let gameEditor = editorLabel else { return }
        guard let wishBTN = addWishListBTN else { return }
        guard let favBTN = addFavoriteBTN else { return }
        guard let gameInfo = game else { return }
        guard let gameCoverUrl = gameInfo.backgroundImage else { return }
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        let nibCell = UINib(nibName: nibRegistrationID, bundle: nil)
        screenshotsCollectionView.register(nibCell, forCellWithReuseIdentifier: nibRegistrationID)
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.collectionViewLayout = layout
        container.layer.cornerRadius = 10

        //setup Navigation Bar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true

        //Assign game's values
        gameTitle.text = gameInfo.name
        gameEditor.text = gameInfo.released
        gameCover.downloaded(from: gameCoverUrl)
        blurCover.downloaded(from: gameCoverUrl)
        screenshots = gameCardViewModel.listOfScreenshots(game: gameInfo, images: self.screenshots)

        for element in [gameCover, favBTN, wishBTN] {
            element.layer.cornerRadius = 5
        }
    }
}

extension GameCardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let screenshots = game?.short_screenshots else { return 0 }
        return screenshots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let screenshots = game?.short_screenshots else { return UICollectionViewCell()}
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotViewCell", for: indexPath) as? ScreenshotViewCell else { return UICollectionViewCell() }
        cell.setup(screenshot: screenshots[indexPath.row])
        return cell
    }
}
