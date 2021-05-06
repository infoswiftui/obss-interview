//
//  MovieDetailCell.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import UIKit

class MovieDetailCell: UITableViewCell {
  
  @IBOutlet weak var movieImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var voteLabel: UILabel!
  
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      descLabel.text = movie?.overview
      voteLabel.text = String(movie?.voteCount ?? 0)
      if let path = movie?.posterPath {
        let url = IMAGE_URL + "w400" + path
        ImageDownloader.downloadImageWithUrl(imageUrl: url, cacheKey: path) { (image) in
          DispatchQueue.main.async {
            if image != nil {
              self.movieImage.image = image
            } else {
              self.movieImage.image = UIImage(named: "cinema")
            }
          }
        }
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  static func nibForCell() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  static func reuseIdentifier() -> String {
    return String(describing: self)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
}
