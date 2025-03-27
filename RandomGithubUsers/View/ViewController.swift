//
//  ViewController.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import UIKit
import SkeletonView

class ViewController: UIViewController, DetailControllerDelegate {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var userPreviews = [UserPreview]()
    private let imageDownloader = ImageDownloader()
    private let networkService = NetworkService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
    }
    
    private func initView(){
        guard userPreviews.count == 0 else{
            return
        }
        
        userTableView.isSkeletonable = true
        userTableView.isUserInteractionDisabledWhenSkeletonIsActive = false
        getUserPreviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerNibs()
        userTableView.dataSource = self
        userTableView.delegate = self
    }
    
    private func registerNibs(){
        userTableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        userTableView.register(UINib(nibName: SkeletonTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        
    }
    
    private func getUserPreviews() {
        refreshButton.isEnabled = false
        userTableView.showAnimatedGradientSkeleton()
        
        if userPreviews.count > 0{
            userTableView.scrollToFirstItem()
        }
        
        Task{
            let (message, newUserPreviews) = await networkService.getListUserRandom()
            userPreviews = newUserPreviews
            DispatchQueue.main.async {
                self.userTableView.hideSkeleton()
                self.userTableView.stopSkeletonAnimation()
                
                self.userTableView.reloadData()
                self.refreshButton.isEnabled = true
                
                if let _message = message{
                    self.showToast(message: _message)
                }
            }
            
        }
    }
    
    func didSendMessageBack(_ data: String) {
        self.showToast(message: data)
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
        return SkeletonTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.defaultSkeletonNumber
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        if let cell = skeletonView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier) as? SkeletonTableViewCell{
            
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
        detailViewController.delegate = self
        
    }
}

