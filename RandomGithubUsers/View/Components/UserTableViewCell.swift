//
//  UserTableViewCell.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import UIKit

class UserTableViewCell: UITableViewCell, SkeletonViewsDelegate{
    
    
    static let identifier = "userTableViewCell"
    static let nibName = "UserTableViewCell"
    
    
    @IBOutlet weak var githubUrlText: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameText.text = ""
        githubUrlText.text = ""
        userImageView.setupCircleImageView()
        
        setAllViewsSkeletonable(true)
        imageLoadingIndicator.isHidden = true
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .green80
        selectedBackgroundView = backgroundView
    }
    
    var allCandidateSkeletonViews: [UIView]{
        return [
            githubUrlText,
            userImageView,
            usernameText
        ]
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
