//
//  PostListTableViewController.swift
//  RedditAPI
//
//  Created by Dominique Strachan on 1/11/23.
//

import UIKit

class PostListTableViewController: UITableViewController {

    //MARK: Outlets
    @IBOutlet weak var searchbar: UISearchBar!
    
    //MARK: Properties
    var posts: [Post] = []
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //granting access on this VC for search bar methods
        searchbar.delegate = self

    }
    
    //MARK: Helper Methods

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //guarding to make sure have cell if not return blank table view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
                //posts property is empty array
        let post = posts[indexPath.row]
        
        //.post is post property in custom cell table view
        cell.post = post
        
        return cell
    }

} //end of class

//extension PostListTableViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        // Pull text off the search bar
//        guard let searchTerm = searchBar.text,
//              !searchTerm.isEmpty else { return }
//
//        PostController.fetchPostWith(searchTerm: searchTerm) { [weak self] (result) in
//
//            // Return to main thread after a fetch
//            DispatchQueue.main.async {
//                switch result {
//
//                case .success(let posts):
//                    self?.posts = posts
//                    self?.tableView.reloadData()
//
//
//                case .failure(let error):
//                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
//                }
//            }
//        }
//    }
//}

extension PostListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }

        PostController.fetchPostWith(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.tableView.reloadData()

                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
} //end of extension

