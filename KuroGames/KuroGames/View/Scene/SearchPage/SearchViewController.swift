//
//  SearchViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 08/06/2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private var searchHomeImage: UIImageView?
    @IBOutlet private var searchContainer: UIView?
    @IBOutlet private var searchField: UITextField?
    @IBOutlet private var searchButton: UIButton?
    @IBOutlet private var newEnterGame: UIButton?
    @IBOutlet private var resultCollectionVIew: UICollectionView?

    var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 270, height: 170)
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {

        guard let result = resultCollectionVIew else { return }
        guard let homeImage = searchHomeImage else { return }
        guard let container = searchContainer else { return }
        guard let textField = searchField else { return }
        result.dataSource = self
        result.delegate = self
        result.collectionViewLayout = layout
        homeImage.layer.cornerRadius = 10
        container.layer.cornerRadius = 10
        textField.textColor = .white
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "game", for: indexPath) as! GameCollectionViewCell
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/3, height: 115)
    }
}
