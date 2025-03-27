//
//  SkeletonTableViewCell.swift
//  RandomGithubUsers
//
//  Created by fajar on 11/03/25.
//

import UIKit

class SkeletonTableViewCell: UITableViewCell, SkeletonViewsDelegate{

   
    @IBOutlet weak var skeletonGithubUrl: UILabel!
    @IBOutlet weak var skeletonUsername: UILabel!
    @IBOutlet weak var skeletonImageView: UIImageView!
    
    static let nibName = "SkeletonTableViewCell"
    static let identifier = "skeletonTableViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        skeletonImageView.setupCircleImageView()
        setAllViewsSkeletonable(true)
    }
    
    var allCandidateSkeletonViews: [UIView]{
        return [
            skeletonImageView,
            skeletonUsername,
            skeletonGithubUrl
        ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
