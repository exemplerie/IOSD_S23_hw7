//
//  UIImageView+Extensions.swift
//  Lab_4
//
//  Created by Валерия Харина on 06.07.2023.
//

import Foundation
import UIKit


extension UIImageView {
    
    func download(from url: URL, mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  let mineType = response?.mimeType,
                  mineType.hasPrefix("image"),
                  let data = data,
                  let image = UIImage(data: data)
            else {return}
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func download(from link: String, contentMode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {return}
        download(from: url, mode: contentMode)
    }
}
