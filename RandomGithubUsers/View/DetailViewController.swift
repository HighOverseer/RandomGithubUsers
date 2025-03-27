//
//  DetailViewController.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import UIKit

class DetailViewController: UIViewController, SkeletonViewsDelegate {

    
    weak var delegate:DetailControllerDelegate?
    
    static let segueIdentifier = "moveToDetail"

    @IBOutlet weak var userBiography: UILabel!
    @IBOutlet weak var userRepoCount: UILabel!
    @IBOutlet weak var userInfoTwo: UILabel!
    @IBOutlet weak var userInfoOne: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFollowingCount: UILabel!
    @IBOutlet weak var userFollowerCount: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var infoRepository: UILabel!
    
    private var userProfileUrl:URL?
    
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
    }
    

    @IBAction func goToProfile(_ sender: UIBarButtonItem) {
        if let url = self.userProfileUrl, UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    private func initView(){
        userInfoOne.text = ""
        userInfoTwo.text = ""
    
        adjustAllSkletonabUIleLabelsSize()
        setAllViewsSkeletonable(true)
        
        userImageView.setupCircleImageView()
        getUserDetail()
    }
    
    private func adjustAllSkletonabUIleLabelsSize(){
        allCandidateSkeletonViews.filter{view in
            view != userImageView
        }.forEach { view in
            if let label = (view as? UILabel) {
                label.font = label.font.withSize(
                    infoRepository.font.pointSize
                )
            }
        }
    }

    
    var allCandidateSkeletonViews: [UIView]{
        return [
            userBiography,
            userRepoCount,
            userInfoOne,
            userInfoTwo,
            userName,
            userFollowingCount,
            userFollowerCount,
            userImageView,
        ]
    }
    
    private func getUserDetail(){
        guard let _username = username else{
            return
        }
        self.showSkeletons()
        let networkService = NetworkService()
        Task{
            let (message, userDetail) = await networkService.getUserDetail(username: _username)
            
            guard let detail = userDetail else{
                DispatchQueue.main.async {
                    if let _message = message{
                        self.delegate?.didSendMessageBack(_message)
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                }
                return
            }
            
            userProfileUrl = detail.profileUrl
            
            let imageDownloader = ImageDownloader()
            imageDownloader.startDownloadImage(
                imageDownloadable: detail as ImageDownloadable,
                imageURL: detail.imageUrl,
                onCompletion: {
                    DispatchQueue.main.async {
                        self.userImageView.image = detail.image
                    }
            })
            
            DispatchQueue.main.async{
                self.hideSkeletons()
                
                self.title = detail.username
                self.userRepoCount.text = String(detail.repoCount)
                self.userFollowerCount.text = String(detail.followerCount)
                self.userFollowingCount.text = String(detail.followingCount)
                self.userName.text = detail.name
                self.userInfoOne.text = detail.userInfoOne
                self.userInfoTwo.text = detail.userInfoTwo
                self.userBiography.text = detail.userBiography
                
                
            }
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
