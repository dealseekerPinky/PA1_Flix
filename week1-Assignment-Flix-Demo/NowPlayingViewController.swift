//
//  NowPlayingViewController.swift
//  week1-Assignment-Flix-Demo
//
//  Created by Pinky Kohsuwan on 2/1/18.
//  Copyright © 2018 Pinky Kohsuwan. All rights reserved.
//

import UIKit
import AlamofireImage


class NowPlayingViewController: UIViewController , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var movies: [[String : Any]] = []
    var refreshControl: UIRefreshControl!

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = false
        self.tableView.isHidden = true
        activityIndicator.startAnimating()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (NowPlayingViewController.didPullToRefresh(_:)), for: . valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchMovies()

    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl)
    {
        fetchMovies()
    }
    
    func fetchMovies(){
        // Network request

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        let task = session.dataTask(with: request)
        { (data, response, error) in
            // this will run when network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                }
            
            // tell the refreshControl to stop spining
            self.refreshControl.endRefreshing()

            }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text =  title
        cell.overviewLabel.text = overview
       
        if let posterPath = movie["poster_path"] as? String {
            let BaseURLString = "https://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: BaseURLString + posterPath)
            cell.posterImageView.af_setImage(withURL: posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterImageView.image = nil
        }
        
        return cell
    }
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
