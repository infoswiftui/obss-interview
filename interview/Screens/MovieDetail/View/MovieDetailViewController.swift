//
//  MovieDetailViewController.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import UIKit

protocol MovieDetailDelegate: AnyObject {
    func star(for id: Int, starred: Bool)
}

class MovieDetailViewController: UITableViewController {
    
    private let reuseIdentifier = "MovieDetailCell"
    let starImage = "star"
    let starFillImage = "star.fill"
    
    weak var delegate: MovieDetailDelegate?
    
    var movie: Movie
    var starred: Bool
    
    init(movie: Movie) {
        self.movie = movie
      self.starred = movie.starred ?? false
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie Detail"
        
        tableView.register(MovieDetailCell.nibForCell(), forCellReuseIdentifier: MovieDetailCell.reuseIdentifier())
        tableView.separatorStyle = .none
        
      let image = UIImage(systemName: movie.starred ?? false ? starFillImage : starImage)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action:  #selector(starButtonTapped))
    }
    
    @objc func starButtonTapped() {
        
      delegate?.star(for: movie.id!, starred: !(movie.starred ?? false))
        
        starred = starred ? false : true
        let image = UIImage(systemName: starred ? starFillImage : starImage)
        navigationItem.rightBarButtonItem?.image = image
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieDetailCell
        cell.movie = movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
