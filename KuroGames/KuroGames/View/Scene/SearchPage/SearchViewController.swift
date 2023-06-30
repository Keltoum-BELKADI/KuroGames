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

    //MARK: Properties
    private var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()
    private let nibRegistrationID = "GameCollectionViewCell"
    private var gameTitle = ""
    private var nextPage: String = ""
    var searchGames: [Game] = [] {
        didSet {
            DispatchQueue.main.async {
                self.resultCollectionVIew?.reloadData()
            }
        }
    }
    let searchViewModel = SearchViewModel(gameService: GameService(session: URLSession(configuration: .default)))

    @IBAction func searchGame(_ sender: Any) {
        guard let textField = searchField else { return }
        textField.resignFirstResponder()
        fetchDataGames()
    }
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

        DispatchQueue.main.async {
            self.searchViewModel.listOfGames = { [weak self] games in
                self?.searchGames = games
            }

            self.searchViewModel.page = { [weak self] page in
                self?.nextPage = page 
            }
        }
    }
    
    private func fetchDataGames () {
        guard let textField = searchField else { return }
        guard resultCollectionVIew != nil else { return }
        guard let title = textField.text, !title.isEmpty, title.count > 3 else {
            Logger.log(.info, "Pas trouvé")
            return
        }
        searchViewModel.searchGames(title: title, mutating: searchGames, nextPage: nextPage, controller: self)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchGames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        cell.setupUI(game: searchGames[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GameCard", sender: searchGames[indexPath.row])
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: 150)
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textField = searchField else { return false }
        textField.resignFirstResponder()
        //appeler depuis le ViewModel
        fetchDataGames()
        return true
    }
}
