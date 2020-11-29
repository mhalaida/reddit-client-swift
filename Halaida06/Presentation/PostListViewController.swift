//
//  PostListViewController.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 28.11.2020.
//

import UIKit

let resSavedToDb = Notification.Name("RedditRequest")

class PostListViewController: UITableViewController {

    // MARK: - Data
    private var posts = [RedditPost]();
    private var showSaved = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(triggerPostListUpdate), name: resSavedToDb, object: nil);
        UseCase.requestPosts(subreddit: "pics", listingType: "top", limit: 3);
        
        navigationItem.title = "r/pics"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: #selector(toggleFilter))
        navigationItem.rightBarButtonItem?.tintColor = UIColor .systemOrange;
        
    }
    
    @objc
    func toggleFilter() {
        self.showSaved = !self.showSaved;
        if self.showSaved {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "archivebox.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "archivebox")
        }
    }
    
    @objc
    func triggerPostListUpdate() {
        updatePostList();
    }
    
    func updatePostList() {
        posts = UseCase.fetchAllPosts();
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as! PostTableViewCell

        // Configure the cell...
        cell.configure(for: self.posts[indexPath.row])
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
