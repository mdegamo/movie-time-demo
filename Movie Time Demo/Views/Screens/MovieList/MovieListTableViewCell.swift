//
//  MovieListTableViewCell.swift
//  Movie Time Demo
//
//  Created by Mark Anthony Degamo on 12/08/2019.
//  Copyright © 2019 Mark Anthony Degamo. All rights reserved.
//

import UIKit


protocol MovieListTableViewCellActionsDelegate {
    func didEmitViewAllAction(moviesCollection: MoviesCollectionDisplayModel)
    func didSelectMovie(movie: MovieResponseModel)
}


class MovieListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var data: MoviesCollectionDisplayModel! {
        didSet {
            sectionTitleLabel.text = data.collectionName
            thumbsCollectionView.data = data.movies
            thumbsCollectionView.reloadData()
        }
    }
    
    var actionsDelegate: MovieListTableViewCellActionsDelegate?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var sectionTitleLabel: UILabel! {
        didSet {
            sectionTitleLabel.font = .boldSystemFont(ofSize: 18)
        }
    }
    
    @IBOutlet weak var viewAllButton: UIButton! {
        didSet {
            viewAllButton.setTitle(R.string.localizable.viewAll(), for: .normal)
            viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
    }
    
    @IBOutlet weak var thumbsCollectionView: MovieListThumbsCollectionView! {
        didSet {
            thumbsCollectionView.actionsDelegate = self
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func didTapViewAllButton(_ sender: Any) {
        actionsDelegate?.didEmitViewAllAction(moviesCollection: data)
    }
    
}


extension MovieListTableViewCell: MovieListThumbsActionsDelegate {
    
    func didSelectMovie(movie: MovieResponseModel) {
        actionsDelegate?.didSelectMovie(movie: movie)
    }
    
}
