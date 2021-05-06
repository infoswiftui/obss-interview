//
//  MovieListCell.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import UIKit

class MovieListCell: UICollectionViewCell {
  
  @IBOutlet weak var starImageView: UIImageView!
  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  let starImage = "star"
  let starFillImage = "star.fill"
  
  var movie: Movie? {
    didSet {
      starImageView.image = UIImage(systemName: movie!.starred ?? false ? starFillImage : starImage)
      
      titleLabel.text = movie?.title
      if let path = movie?.posterPath {
        let url = IMAGE_URL + "w400" + path
        ImageDownloader.downloadImageWithUrl(imageUrl: url, cacheKey: path) { (image) in
          DispatchQueue.main.async {
            if image != nil {
              self.movieImageView.image = image
            } else {
              self.movieImageView.image = UIImage(named: "cinema")
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
    
    starImageView.image = nil
    movieImageView.image = nil
    titleLabel.text = nil
  }
}
