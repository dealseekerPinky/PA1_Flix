ro//
//  NowPlayingViewController.swift
//  week1-Assignment-Flix-Demo
//
//  Created by Pinky Kohsuwan on 2/1/18.
//  Copyright © 2018 Pinky Kohsuwan. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var movies: [[String : Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.rowHeight = 200
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
                self.tableView.reloadData()
                }
                // Get the posts and store in posts property
                
                // Reload the table view
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
        
        return cell
    }
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
