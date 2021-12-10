//
//  MovieTableViewCell.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/29/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var tituloMovie: UILabel!
    @IBOutlet var yearMovie: UILabel!
    @IBOutlet var imagenMovie: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell",
                     bundle: nil)
    }

    func configure(with model: Movie) {
        self.tituloMovie.text = model.title
        self.yearMovie.text = model.release_date
        let url = model.backdropURL
        if let data = try? Data(contentsOf: URL(string: (url).absoluteString)!) {
            self.imagenMovie.image = UIImage(data: data)
        }
    }
}
