//
//  PostListViewController.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 28.11.2020.
//

import UIKit

let freshPostsSaved = Notification.Name("freshPostsSaved")
let freshCommentsSaved = Notification.Name("freshCommentsSaved")
private let toPostDetailsIdentifier = "toPostDetails"

class PostListViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Data
    private var posts = [RedditPost]();
    private var postsUnfiltered = [RedditPost]();
    private var showSaved = false;
    private var postSearchController = UISearchController();
    private var postForSegue = RedditPost(id: nil, author: nil, domain: nil, created_utc: nil, title: nil, url: nil, ups: nil, downs: nil, num_comments: nil, isSaved: false, permalink: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(triggerPostListUpdate), name: freshPostsSaved, object: nil);
        UseCase.requestPosts(subreddit: "pics", listingType: "top", limit: 150);
        
        navigationItem.title = "r/pics"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: #selector(toggleFilter))
        navigationItem.rightBarButtonItem?.tintColor = UIColor .systemOrange;
    }
    
    //toggle between saved/fresh posts
    @objc
    func toggleFilter() {
        self.showSaved = !self.showSaved;
        triggerPostListUpdate();
        if self.showSaved {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "archivebox.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "archivebox")
        }
    }
    
    //trigger table update
    @objc
    func triggerPostListUpdate() {
        if self.showSaved {
            postSearchController = ({
                let postSC = UISearchController(searchResultsController: nil)
                postSC.searchResultsUpdater = self
                postSC.obscuresBackgroundDuringPresentation = false;
                postSC.searchBar.sizeToFit()
                tableView.tableHeaderView = postSC.searchBar
                return postSC
            })()
            updatePostListSaved();
        } else {
            DispatchQueue.main.async {
                self.tableView.tableHeaderView = nil;
            }
            updatePostListFresh();
        }
    }
    
    //fill table with fresh posts
    func updatePostListFresh() {
        posts = UseCase.fetchAllPostsFresh();
        postsUnfiltered = posts;
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //fill table with saved posts
    func updatePostListSaved() {
        posts = UseCase.fetchAllPostsSaved();
        postsUnfiltered = posts;
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text! != "") {
            self.posts = self.postsUnfiltered.filter { $0.title!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        } else {
            self.posts = self.postsUnfiltered;
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    //sections count (N/A to our usecase, therefore 1)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //rows count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    //tojvo?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as! PostTableViewCell
        cell.postInfoDelegate = self;
        cell.configure(for: self.posts[indexPath.row]);
        return cell
    }
    
    //cell selection handler
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //segue handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PostDetailsViewController {
            if let postDetails = segue.destination as? PostDetailsViewController {
                postDetails.savePostInfo(postOrigin: self.postForSegue);
            } else {
                print(">>Segue issue")
            }
        }
    }
    
}

extension PostListViewController: PostInfoDelegate {
    
    func sharePost(permalink: String) {
        let postURL = [URL(string: permalink)!]
        let ac = UIActivityViewController(activityItems: postURL, applicationActivities: nil)
        //        present(ac, animated: true)
        if self.postSearchController.isActive {
            self.postSearchController.present(ac, animated: true, completion: nil)
        } else {
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func passInfo(id: String) {
        if let postIndex = posts.firstIndex(where: {$0.id == id}) {
            self.postForSegue = self.posts[postIndex];
            self.performSegue(withIdentifier: toPostDetailsIdentifier, sender: nil)
        }
    }
    
}
