//
//  WishViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 08/06/2023.
//

import UIKit
import CoreData

class WishViewController: UIViewController {

    @IBOutlet private var searchBar: UISearchBar?
    @IBOutlet private var filter: UISegmentedControl?
    @IBOutlet private var settingBTN: UIButton?
    @IBOutlet private var wishListCollection: UICollectionView?

    //MARK: Properties
    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()
    private let nibRegistrationID = "GameCollectionViewCell"
    private var wishGames = [WishlistGame]()
    private let wishCoreManager = WishlistDataManager(managedObjectContext: CoreDataStackWishlist.wishListShared.mainContext)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(wishGames)
        // Do any additional setup after loading the view.
    }

    func setupUI(){

        guard let wishListView = wishListCollection else { return }
        wishGames = wishCoreManager.fetchWishlist(mygames: wishGames)
        let nibCell = UINib(nibName: nibRegistrationID, bundle: nil)
        wishListView.delegate = self
        wishListView.dataSource = self
        wishListView.collectionViewLayout = layout
        wishListView.register(nibCell, forCellWithReuseIdentifier: nibRegistrationID)
    }

}

extension WishViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishGames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        cell.setupUI(game: wishGames[indexPath.row])
        guard let dataImage =  wishGames[indexPath.row].backgroundImage else { return UICollectionViewCell() }
        cell.backgroundImage?.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WishListCard", sender: wishGames[indexPath.row])
    }
}
extension WishViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 180)
    }
}

