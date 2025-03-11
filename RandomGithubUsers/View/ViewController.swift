//
//  ViewController.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import UIKit
import SkeletonView

class ViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var userPreviews = [UserPreview]()
    private let imageDownloader = ImageDownloader()
    private let networkService = NetworkService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard userPreviews.count == 0 else{
            return
        }
        
        userTableView.isSkeletonable = true
        getUserPreviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userTableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        
        userTableView.dataSource = self
        userTableView.delegate = self
    }
    
    func getUserPreviews() {
        refreshButton.isEnabled = false
        userTableView.showAnimatedGradientSkeleton()
        
        if userPreviews.count > 0{
            userTableView.scrollToFirstItem()
        }
        
        Task{
            userPreviews = await networkService.getListUserRandom()
            DispatchQueue.main.async {
                self.userTableView.stopSkeletonAnimation()
                self.userTableView.hideSkeleton()
                self.userTableView.reloadData()
                self.refreshButton.isEnabled = true
            }
            
        }
    }
    
    

    
    @IBAction func refreshUserPreviews(_ sender: UIButton) {
        getUserPreviews()
    }
    
}



extension ViewController: SkeletonTableViewDataSource{
    static let defaultSkeletonNumber = 10
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPreviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell{
            let userPreview = userPreviews[indexPath.row]

            cell.hideSkeletons()
            //for avoiding image flashing due to cell reuse
            cell.userImageView.image = nil
            
            cell.usernameText.text = userPreview.username
            cell.githubUrlText.text = userPreview.githubUrl
            cell.userImageView.image = userPreview.image
            
            if userPreview.state == .new{
                cell.imageLoadingIndicator.isHidden = false
                cell.imageLoadingIndicator.startAnimating()
                imageDownloader.startDownloadImage(
                    imageDownloadable: userPreview as ImageDownloadable,
                    imageURL: userPreview.imageUrl,
                    onCompletion: {
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
            
                    }
                )
            }else{
                cell.imageLoadingIndicator.stopAnimating()
                cell.imageLoadingIndicator.isHidden = true
            }
            
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return UserTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.defaultSkeletonNumber
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        if let cell = skeletonView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell{
            
            cell.imageLoadingIndicator.isHidden = true
            cell.showSkeletons()

            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    
  
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: DetailViewController.segueIdentifier, sender: userPreviews[indexPath.row].username)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == DetailViewController.segueIdentifier else { return }
        
        guard let detailViewController = segue.destination as? DetailViewController else{
            return
        }
        
        detailViewController.username = sender as? String
        
    }
}

