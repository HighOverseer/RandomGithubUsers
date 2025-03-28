import UIKit

class DetailViewController: UIViewController, SkeletonViewsDelegate {
    weak var delegate: DetailControllerDelegate?

    static let segueIdentifier = "moveToDetail"

    @IBOutlet var userBiography: UILabel!
    @IBOutlet var userRepoCount: UILabel!
    @IBOutlet var userInfoTwo: UILabel!
    @IBOutlet var userInfoOne: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userFollowingCount: UILabel!
    @IBOutlet var userFollowerCount: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var infoRepository: UILabel!

    private var userProfileUrl: URL?

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    @IBAction func goToProfile(_: UIBarButtonItem) {
        if let url = userProfileUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func initView() {
        userInfoOne.text = ""
        userInfoTwo.text = ""

        adjustAllSkletonabUIleLabelsSize()
        setAllViewsSkeletonable(true)

        userImageView.setupCircleImageView()
        getUserDetail()
    }

    private func adjustAllSkletonabUIleLabelsSize() {
        allSkeletonViewCandidates.filter { view in
            view != userImageView
        }.forEach { view in
            if let label = (view as? UILabel) {
                label.font = label.font.withSize(
                    infoRepository.font.pointSize
                )
            }
        }
    }

    var allSkeletonViewCandidates: [UIView] {
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

    private func getUserDetail() {
        guard let _username = username else {
            return
        }
        showSkeletons()
        let networkService = NetworkService()
        Task {
            let (message, userDetail) = await networkService.getUserDetail(username: _username)

            guard let detail = userDetail else {
                DispatchQueue.main.async {
                    if let _message = message {
                        self.delegate?.didSendMessageBack(_message)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }

            setDetailContents(detail: detail)
        }
    }

    private func setDetailContents(detail: UserDetail) {
        userProfileUrl = detail.profileUrl

        let imageDownloader = ImageDownloader()
        imageDownloader.startDownloadImage(
            imageDownloadable: detail as ImageDownloadable,
            imageURL: detail.imageUrl,
            onCompletion: {
                DispatchQueue.main.async {
                    self.userImageView.image = detail.image
                }
            }
        )

        DispatchQueue.main.async {
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
