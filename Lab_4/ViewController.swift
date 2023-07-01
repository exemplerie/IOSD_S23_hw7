//
//  ViewController.swift
//  Lab_4
//
//  Created by Валерия Харина on 28.06.2023.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    var data: [Character] = [
        Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", gender: .male, location: "Citadel of Ricks", image: "1.jpeg"),
        Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", gender: .male, location: "Citadel of Ricks", image: "2.jpeg"),
        Character(id: 3, name: "Summer Smith", status: .alive, species: "Human", gender: .female, location: "Earth (Replacement Dimension)", image: "3.jpeg"),
        Character(id: 4, name: "Beth Smith", status: .alive, species: "Human (possible Clone)", gender: .female, location: "Earth (Replacement Dimension)", image: "4.jpeg"),
        Character(id: 5, name: "Jerry Smith", status: .alive, species: "Human", gender: .male, location: "Earth (Replacement Dimension)", image: "5.jpeg"),
        Character(id: 24, name: "Armagheadon", status: .alive, species: "Alien", gender: .male, location: "Signus 5 Expanse", image: "24.jpeg"),
        Character(id: 207, name: "Loggins", status: .alive, species: "Alien", gender: .male, location: "Interdimensional Cable", image: "207.jpeg"),
        Character(id: 555, name: "Randotron", status: .dead, species: "Robot", gender: .genderless, location: "Heistotron Base", image: "555.jpeg"),
        Character(id: 304, name: "Scary Brandon", status: .alive, species: "Mythological Creature", gender: .male, location: "Mr. Goldenfold's dream", image: "304.jpeg"),
        Character(id: 44, name: "Body Guard Morty", status: .dead, species: "Human", gender: .male, location: "Citadel of Ricks", image: "44.jpeg"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else {return}
        
        detailViewController.delegate = self
        
        present(detailViewController, animated: true)
        detailViewController.data = data[indexPath.row]
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RickAndMortyCell") as? CustomTableViewCell
        else {return UITableViewCell() }
        
        let cellData = data[indexPath.row]
        cell.setUpData(cellData)
        return cell
    }

}

extension ViewController: DetailViewControllerDelegate {
    
    func changeLocation(with id: Int, value: String) {
        if let index = data.firstIndex(where: {$0.id == id}) {
            data[index].location = value
            table.reloadData()
        }
        dismiss(animated: true)
    }
    
    func changeSpecies(with id: Int, value: String) {
        if let index = data.firstIndex(where: {$0.id == id}) {
            data[index].species = value
            table.reloadData()
        }
        dismiss(animated: true)
    }
}
