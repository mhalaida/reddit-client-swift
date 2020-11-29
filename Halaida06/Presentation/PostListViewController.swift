//
//  PostListViewController.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 28.11.2020.
//

import UIKit

let resSavedToDb = Notification.Name("RedditRequest")
private let toPostDetailsIdentifier = "toPostDetails"

class PostListViewController: UITableViewController {
    
    // MARK: - Data
    private var posts = [RedditPost]();
    private var showSaved = false;
    private var postForSegue = RedditPost(id: nil, author: nil, domain: nil, created_utc: nil, title: nil, url: nil, ups: nil, downs: nil, num_comments: nil, isSaved: false, permalink: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(triggerPostListUpdate), name: resSavedToDb, object: nil);
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
            updatePostListSaved();
        } else {
            updatePostListFresh();
        }
    }
    
    //fill table with fresh posts
    func updatePostListFresh() {
        posts = UseCase.fetchAllPostsFresh();
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //fill table with saved posts
    func updatePostListSaved() {
        posts = UseCase.fetchAllPostsSaved();
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
//        let saveGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSaveDoubleTap));
//        saveGestureRecognizer.numberOfTapsRequired = 2;
//        cell.postImageView.addGestureRecognizer(saveGestureRecognizer);
//        cell.postImageView.isUserInteractionEnabled = true;
        return cell
    }
    
//    @objc
//    func handleSaveDoubleTap() {
//        print("SRAKA")
//    }
    
    //cell selection handler
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.performSegue(withIdentifier: toPostDetailsIdentifier, sender: self.posts[indexPath.row])
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
        present(ac, animated: true)
    }
    
    func passInfo(id: String) {
        if let postIndex = posts.firstIndex(where: {$0.id == id}) {
            self.postForSegue = self.posts[postIndex];
            self.performSegue(withIdentifier: toPostDetailsIdentifier, sender: nil)
        }
    }
    
}
