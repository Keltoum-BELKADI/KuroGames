//
//  PlatformsViewController.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 21/07/2023.
//
import UIKit

class PlatformsViewController: UITableViewController {
    //MARK: Properties
    var game: Game?
    private var plateformNames = ""
    private var plateformArray = [String]()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .pageSheet
        tableView.delegate = self
        tableView.dataSource = self
        setup()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plateformArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Futura", size: 30)
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = plateformArray[indexPath.row]
        return cell
    }

    func setup() {
        if #available(iOS 15.0, *) {
            let sheet = self.sheetPresentationController
            sheet?.detents = [.medium()]
        }
        guard let gameInfo = game else { return }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        plateformNames = gameInfo.createNameList(for: gameInfo.platforms)
        plateformArray = plateformNames.split(separator: ",").map { String($0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)) }
        tableView.backgroundColor = .white
    }
}
