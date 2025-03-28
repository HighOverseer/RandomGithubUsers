import UIKit

class UserTableViewCell: UITableViewCell, SkeletonViewsDelegate {
    static let identifier = "userTableViewCell"
    static let nibName = "UserTableViewCell"

    @IBOutlet var githubUrlText: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameText: UILabel!
    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        usernameText.text = ""
        githubUrlText.text = ""
        userImageView.setupCircleImageView()

        setAllViewsSkeletonable(true)
        imageLoadingIndicator.isHidden = true

        let backgroundView = UIView()
        backgroundView.backgroundColor = .green80

        selectedBackgroundView = backgroundView
    }

    var allSkeletonViewCandidates: [UIView] {
        return [
            githubUrlText,
            userImageView,
            usernameText,
        ]
    }
}
