//
//  MovieListViewController.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import UIKit

class MovieListViewController: UICollectionViewController {
  
  private let reuseIdentifier = "MovieListCell"
  let gridFlowLayout = GridFlowLayout()
  let listFlowLayout = ListFlowLayout()
  let listImage = "list.bullet"
  let gridImage = "square.grid.2x2"
  
  var isGridFlowLayoutActive: Bool = true

  @IBOutlet weak var layoutButton: UIBarButtonItem!
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  var viewModel: MovieListViewModel = MovieListViewModel()

  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDefaultUI()
    bindViewModels()
    viewModel.fetchMovies(with: viewModel.nextPage)
  }
  
  func setDefaultUI() {
    self.title = "Movie List"
    
    self.collectionView!.register(MovieListCell.nibForCell(), forCellWithReuseIdentifier: MovieListCell.reuseIdentifier())
    collectionView.collectionViewLayout = gridFlowLayout
    navigationItem.searchController = searchController
  }
  
  func bindViewModels() {
    viewModel.updateMovieList = updateMovieList()
  }
  
  // MARK: - ViewModel Callback
  final func updateMovieList() -> (_ moviesData: [Movie]) -> Void {
    return { [weak self] (moviesData) in
      guard let _self = self else { return }
      DispatchQueue.main.async {
        _self.collectionView.reloadData()
      }
    }
  }
  
  // MARK: - Button Actions
  @IBAction func layoutButtonDidTap(_ sender: UIBarButtonItem) {
    if isGridFlowLayoutActive {
      isGridFlowLayoutActive = false
      changeLayout(layout: listFlowLayout)
      layoutButton.image = UIImage(systemName: listImage)
    } else {
      isGridFlowLayoutActive = true
      changeLayout(layout: gridFlowLayout)
      layoutButton.image = UIImage(systemName: gridImage)
    }
  }
  
  // MARK: - UI Helper
  func changeLayout(layout: UICollectionViewFlowLayout) {
    UIView.animate(withDuration: 0.2) { () -> Void in
      self.collectionView.collectionViewLayout.invalidateLayout()
      self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
  }
  
  lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.definesPresentationContext = true
    searchController.searchBar.placeholder = "Type something here to search"
    return searchController
  }()
  
  // MARK: UICollectionViewDataSource
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.movies(isFiltering).count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieListCell
    
    let movie = viewModel.movies(isFiltering)[indexPath.row]
    cell.movie = movie
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let moviesInfo = viewModel.moviesData else { return }
    if indexPath.row == viewModel.movieList.count - 4 {
      if moviesInfo.totalResults! > viewModel.movieList.count {
        if (moviesInfo.page! + 1) < moviesInfo.totalPages! {
          viewModel.nextPage = (moviesInfo.page! + 1)
          viewModel.fetchMovies(with: viewModel.nextPage)
        }
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = viewModel.movies(isFiltering)[indexPath.row]
    let vc = MovieDetailViewController(movie: movie)
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }
}


// MARK: - MovieDetailDelegate
extension MovieListViewController: MovieDetailDelegate {
  func star(for id: Int, starred: Bool) {
    if let index = viewModel.movieList.firstIndex(where: { $0.id! == id}) {
      viewModel.movieList[index].starred = starred
      if isFiltering {
        if let index = viewModel.filteredMovieList.firstIndex(where: { $0.id! == id}) {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
          }
        }
      } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
      }
    }
  }
}


// MARK: - UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let keywoard = searchController.searchBar.text else {return}
    
      viewModel.filteredMovieList = viewModel.movieList.filter({ (movie) -> Bool in
        if isSearchBarEmpty {
          return false
        } else {
          guard let title = movie.title else {return false}
          return title.localizedCaseInsensitiveContains(keywoard)
        }
      })
      collectionView.reloadData()
  }
}
