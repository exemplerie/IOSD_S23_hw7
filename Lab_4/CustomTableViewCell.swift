//
//  CustomTableViewCell.swift
//  Lab_4
//
//  Created by Валерия Харина on 28.06.2023.
//

import UIKit


struct Character {
    enum Status {
        case alive
        case dead
        case unknown
    }
    
    enum Gender {
        case female
        case male
        case genderless
        case unknown
    }
    
    let id: Int
    let name: String
    let status: Status
    var species: String
    let gender: Gender
    var location: String
    let image: String
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var location: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData(_ data: CharacterResponseModel) {
        iconImageView.download(from: data.image)
        name.text = data.name
        species.text = data.species
        location.text = data.location.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        name.text = nil
        species.text = nil
        location.text = nil
    }

}
