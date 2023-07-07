//
//  ViewController.swift
//  Lab_4
//
//  Created by Валерия Харина on 28.06.2023.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for id in 1...10 {
            loadCharacter(ID: id)
        }
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else {return}
        
        detailViewController.delegate = self
        
        present(detailViewController, animated: true)
        detailViewController.data = characters[indexPath.row]
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RickAndMortyCell") as? CustomTableViewCell
        else {return UITableViewCell() }
        
        let cellData = characters[indexPath.row]
        cell.setUpData(cellData)
        return cell
    }
    
    private let manager: NetworkManagerProtocol = NetworkManager()
    private var characters: [CharacterResponseModel] = []
    
    private func loadCharacter(ID: Int) {
        manager.fetchCharacter(ID: ID, completion: { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let characterResponse):
                weakSelf.characters.append(characterResponse)
                weakSelf.table.reloadData()
            case let .failure(error):
                print(error)
            }
        })
        
    }
}

extension ViewController: DetailViewControllerDelegate {
    
    func changeLocation(with id: Int, value: String) {
        if let index = characters.firstIndex(where: {$0.id == id}) {
            characters[index].location.name = value
            table.reloadData()
        }
        dismiss(animated: true)
    }
    
    func changeSpecies(with id: Int, value: String) {
        if let index = characters.firstIndex(where: {$0.id == id}) {
            characters[index].species = value
            table.reloadData()
        }
        dismiss(animated: true)
    }
}
