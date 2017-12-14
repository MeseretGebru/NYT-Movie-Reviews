//
//  MoviesViewController+Extension.swift
//  NYT Movie Reviews
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let name = movies[indexPath.row].displayName ?? movies[indexPath.row].byline {
            self.loadCriticComments(from: name)
        }
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Movie Cell", for: indexPath) as? MovieTableViewCell {
            let movie = movies[indexPath.row]
            cell.criticNameLabel.text = movie.displayName ?? movie.byline
            if let multimedia = movie.multimedia {
                if let src = multimedia.resource {
                    if let imageStr = src.src {
                        cell.spiner.isHidden = false
                        MovieAPIClient.manager.getImage(from: imageStr, completionHandler: {cell.criticImage.image = $0}, errorHandler: {print($0)})
                        cell.spiner.isHidden = true
                        cell.setNeedsLayout()
                    }
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let movie = movies[indexPath.row]
//        KeyedArchiverClient.manager.add(card: card)
//        let alertVC = UIAlertController(title: "Added", message: "Added to favorites", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        present(alertVC, animated: true, completion: nil)
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Movie Cell", for: indexPath) as? MoviesCollectionViewCell else {
            //TO DO (Handle this failure)
            return UICollectionViewCell()
        }
        
        let comment = comments[indexPath.row]
        if let multimedia = comment.multimedia {
            if let src = multimedia.src {
                MovieAPIClient.manager.getImage(from: src, completionHandler: {cell.commentImage.image = $0}, errorHandler: {print($0)})
            }
        }
        
        return cell
    }
}
