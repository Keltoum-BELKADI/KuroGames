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
    @IBOutlet private var topBar: UIView?
    @IBOutlet private var infoPlatformsBTN: UIButton?

    @IBAction func addFavoriteAction(_ sender: Any) {
        guard let thisGame = game else { return }
        gameCardViewModel.alreadySaveInFavorite(game: thisGame)
    }

    @IBAction func addWishlist(_ sender: Any) {
        guard let thisGame = game else { return }
        gameCardViewModel.alreadySaveInWishList(game: thisGame)
    }

    @IBAction func popViewAction(_ sender: Any) {
        performSegue(withIdentifier: "PopView", sender: game)
    }
    
    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 270, height: 270)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = .zero
        return layout
    }()
    let nibRegistrationID = "ScreenshotViewCell"
    var game: Game?
    var wishlistGame: WishlistGame?
    var favoriteGame: KuroGame?
    var screenshots = [String]()
    var gameCardViewModel = GameCardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopView", let next = segue.destination as? PlatformsViewController {
            next.game = sender as? Game
        }
    }

    func setupUI() {
        gameCardViewModel.delegate = self 
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
        guard let bar = topBar else { return }
        guard let infoBTN = infoPlatformsBTN else { return }

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        let nibCell = UINib(nibName: nibRegistrationID, bundle: nil)
        //set collection images
        screenshotsCollectionView.register(nibCell, forCellWithReuseIdentifier: nibRegistrationID)
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.collectionViewLayout = layout
        container.layer.cornerRadius = 10
        bar.layer.cornerRadius = bar.frame.height / 2
        //setup Navigation Bar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true

        //set infoBTN
        infoBTN.layer.cornerRadius = infoBTN.frame.height / 2
        infoBTN.setUpShadow(color: UIColor.black.cgColor, cell: infoBTN, width: 3, height: 3)

        //Assign game's values
        gameTitle.text = gameInfo.name
        gameEditor.text = gameInfo.released
        gameCover.downloaded(from: gameCoverUrl)
        blurCover.downloaded(from: gameCoverUrl)
        screenshots = gameCardViewModel.listOfScreenshots(game: gameInfo, images: self.screenshots)

        guard let wishGame = wishlistGame else { return }
        if wishGame == wishGame {
        gameTitle.text = wishGame.name
        gameEditor.text = wishGame.release_date
        guard let image = wishGame.backgroundImage else { return }
        gameCover.cacheImage(urlString: String(decoding: image, as: UTF8.self))
        blurCover.cacheImage(urlString: String(decoding: image, as: UTF8.self))
        screenshotsCollectionView.isHidden = true
        }
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

extension GameCardViewController: PopupAlertDelegate {
    func apiCallFailed(state: Bool) {
    }

    func popupAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))

        self.present(alertController, animated: true, completion: nil)
    }
}
