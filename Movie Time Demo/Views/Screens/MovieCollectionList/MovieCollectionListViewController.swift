//
//  MovieCollectionList.swift
//  Movie Time Demo
//
//  Created by Mark Anthony Degamo on 13/08/2019.
//  Copyright © 2019 Mark Anthony Degamo. All rights reserved.
//

import UIKit

class MovieCollectionListViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel = MovieCollectionListViewModel()
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mainCollectionView: MovieCollectionCollectionView! {
        didSet {
            mainCollectionView.renderDelegate = self
        }
    }
    
    
    // MARK: Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiver = segue.destination as? MovieHeroViewController,
            let data = sender as? MovieResponseModel {
            receiver.viewModel.data = data
        }
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewController()
        refreshCollectionView()
        setupNotificationObservers()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainCollectionView.reloadData()
    }
    
}


extension MovieCollectionListViewController {
    
    // MARK: Setup & Initialization
    
    func initViewController() {
        self.navigationItem.title = viewModel.data.collectionName
        mainCollectionView.actionsDelegate = self
    }
    
    func setupNotificationObservers() {
        let center = NotificationCenter.default
        
        center.addObserver(
            self,
            selector: #selector(didReceiveUpdateFavorites(notification:)),
            name: Notification.Name(rawValue: ObserverNotificationKeys.didUpdateFavoritesKey),
            object: nil)
    }
    
    
    // MARK: Methods
    
    @objc func didReceiveUpdateFavorites(notification: NSNotification) {
        if viewModel.data.collectionName != R.string.localizable.favorites() {
            return
        }
        
        if viewModel.hasFavorites {
            viewModel.refreshDataFromFavorites()
            refreshCollectionView()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func refreshCollectionView() {
        mainCollectionView.data = viewModel.data.movies
        mainCollectionView.reloadData()
    }
    
}


extension MovieCollectionListViewController: MovieCollectionActionsDelegate {

    func didSelectMovie(movie: MovieResponseModel) {
        performSegue(withIdentifier: R.segue.movieCollectionListViewController.movieCollectionToMovieHeroSegueIdentifier.identifier, sender: movie)
    }

}


extension MovieCollectionListViewController: MovieCollectionRenderDelegate {
    
    func didRenderThumb(cell: MovieThumbsCollectionViewCell, movie: MovieResponseModel) {
        loadThumbImage(cell: cell, movie: movie)
    }
    
}
