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

    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()
    let nibRegistrationID = "GameCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        let nibCell = UINib(nibName: nibRegistrationID, bundle: nil)
        resultCollectionVIew?.register(nibCell, forCellWithReuseIdentifier: nibRegistrationID)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GameCard", sender: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: 150)
    }
}
