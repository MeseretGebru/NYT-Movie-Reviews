//
//  ViewController.swift
//  NYT Movie Reviews
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [Movie]() {
        didSet {
            self.movieTableView.reloadData()
        }
    }
    
    var comments = [Movie]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieTableView.delegate = self
        self.movieTableView.dataSource =  self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadMoviesData()
    }
    
    func loadMoviesData() {
        let urlStr = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key="
        
        MovieAPIClient.manager.getMovies(from: urlStr,completionHandler: {self.movies = $0}, errorHandler: {print($0)})
    }
    
    func loadCriticComments(from user: String) {
        let strUser = user.replacingOccurrences(of: " ", with: "+")
        let urlStr = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?reviewer=\(strUser)&api-key="
        MovieAPIClient.manager.getMovies(from: urlStr,completionHandler: {self.comments = $0}, errorHandler: {print($0)})
    }
}

