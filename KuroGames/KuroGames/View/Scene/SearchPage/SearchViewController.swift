//
//  SearchViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 08/06/2023.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: IBoutlets
    @IBOutlet private var searchHomeImage: UIImageView?
    @IBOutlet private var searchContainer: UIView?
    @IBOutlet private var searchField: UITextField?
    @IBOutlet private var searchButton: UIButton?
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
    private var errorText: String = ""


    var searchGames: [Game] = [] {
        didSet {
            DispatchQueue.main.async {
                self.resultCollectionVIew?.reloadData()
            }
        }
    }
    var nextGames = [Game]()
    private let searchViewModel = SearchViewModel(gameService: GameService(session: URLSession(configuration: .default)))

    @IBAction func searchGame(_ sender: Any) {
        guard let textField = searchField else { return }
        textField.resignFirstResponder()
        fetchDataGames()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //send data to the next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameCard", let next = segue.destination as? GameCardViewController {
            next.game = sender as? Game
        }
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
        textField.delegate = self
        searchViewModel.delegate = self
        result.collectionViewLayout = layout
        homeImage.layer.cornerRadius = 10
        container.layer.cornerRadius = 10
        textField.textColor = .white
        textField.returnKeyType = .done
        textField.placeholder = "Précisez le jeu"

        self.searchViewModel.listOfGames = { [weak self] games in
            self?.searchGames = games
            Logger.log(.info, "Apicall succeed")
        }

        self.searchViewModel.page = { [weak self] page in
            self?.nextPage = page
        }

        self.searchViewModel.errorHappen = { [weak self] error in
            self?.errorText = error
        }
    }
    
    private func fetchDataGames () {
        guard let textField = searchField else { return }
        guard resultCollectionVIew != nil else { return }

        guard let title = textField.text else { return }

        searchViewModel.searchGames(title: title, searchResult: searchGames, nextPage: nextPage, controller: self, error: errorText)
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

    //Charger la prochaine page de résultats lorsque l'utilisateur atteint la fin
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            // Vérifiez si la dernière cellule est affichée
            if indexPath.row == searchGames.count - 1 {
                    searchViewModel.loadMoreData(page: nextPage, searchGames: searchGames)
                self.searchViewModel.nextGames = { [weak self] games in
                    guard let self = self else { return }
                    self.nextGames = games
                    self.searchGames.append(contentsOf: nextGames)
                    self.resultCollectionVIew?.reloadData()
                    Logger.log(.info, "LoadMore succeed")
                }
            }
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = searchField else { return }
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = searchField else { return }
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor

    }
}

extension SearchViewController: PopupAlertDelegate {
    func apiCallFailed(state: Bool) {
        if state {
            popupAlert(title: "Accident ⛔️", message: "Votre recherche n'a pas abouti, veuillez le nom entier ou vérifier l'orthographe.")
        }
    }

    func popupAlert(title: String, message: String) {
        guard let textField = self.searchField else { return }
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.red.cgColor

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}
