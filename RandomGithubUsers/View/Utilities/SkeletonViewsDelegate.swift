import UIKit

protocol SkeletonViewsDelegate {
    func setAllViewsSkeletonable(_ isSkeletonable: Bool)

    func showSkeletons()

    func hideSkeletons()

    var allSkeletonViewCandidates: [UIView] {
        get
    }
}

extension SkeletonViewsDelegate {
    func setAllViewsSkeletonable(_ isSkeletonable: Bool) {
        for view in allSkeletonViewCandidates {
            view.isSkeletonable = isSkeletonable
        }
    }

    func showSkeletons() {
        for view in allSkeletonViewCandidates {
            view.showAnimatedGradientSkeleton()
        }
    }

    func hideSkeletons() {
        for view in allSkeletonViewCandidates {
            view.hideSkeleton()
            view.stopSkeletonAnimation()
        }
    }
}
