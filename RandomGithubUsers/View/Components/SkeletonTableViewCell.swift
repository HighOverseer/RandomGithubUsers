import UIKit

class SkeletonTableViewCell: UITableViewCell, SkeletonViewsDelegate {
    @IBOutlet var skeletonGithubUrl: UILabel!
    @IBOutlet var skeletonUsername: UILabel!
    @IBOutlet var skeletonImageView: UIImageView!

    static let nibName = "SkeletonTableViewCell"
    static let identifier = "skeletonTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonImageView.setupCircleImageView()
        setAllViewsSkeletonable(true)
    }

    var allSkeletonViewCandidates: [UIView] {
        return [
            skeletonImageView,
            skeletonUsername,
            skeletonGithubUrl,
        ]
    }
}
