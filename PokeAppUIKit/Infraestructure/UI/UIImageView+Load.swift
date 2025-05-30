//
//  UIImageView+Load.swift
//  PokeAppUIKit
//
//  Created by Macky on 30/05/25.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}


