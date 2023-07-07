//
//  DetailViewController.swift
//  Lab_4
//
//  Created by Валерия Харина on 29.06.2023.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func changeSpecies(with id: Int, value: String)
    func changeLocation(with id: Int, value: String)
}

final class DetailViewController: UIViewController {
    var data: CharacterResponseModel? {
        didSet {
            guard let data else {return}
            setUpData(data)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var location: UILabel!
    
    var delegate: DetailViewControllerDelegate?
    

    private func setUpData(_ data: CharacterResponseModel) {
        imageView.download(from: data.image)
        id.text = String(data.id)
        name.text = data.name
        status.text = data.status
        species.text = data.species
        gender.text = data.gender
        location.text = data.location.name
    }
    
    
    
    @IBAction func speciesButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter new value", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Species"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default) { [self] _ in
            if let newValue = alert.textFields?.first?.text {
                guard let data else {return}
                delegate?.changeSpecies(with: data.id, value: newValue)
                        }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter new value", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Location"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default) { [self] _ in
            if let newValue = alert.textFields?.first?.text {
                guard let data else {return}
                delegate?.changeLocation(with: data.id, value: newValue)
                        }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    
}
