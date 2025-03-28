import SkeletonView
import UIKit

class ViewController: UIViewController, DetailControllerDelegate {
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var refreshButton: UIButton!

    private var userPreviews = [UserPreview]()
    private let imageDownloader = ImageDownloader()
    private let networkService = NetworkService()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initView()
    }

    private func initView() {
        guard userPreviews.count == 0 else {
            return
        }

        userTableView.isSkeletonable = true
        userTableView.isUserInteractionDisabledWhenSkeletonIsActive = false
        getUserPreviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNibs()
        userTableView.dataSource = self
        userTableView.delegate = self
    }

    private func registerNibs() {
        userTableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        userTableView.register(UINib(nibName: SkeletonTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: SkeletonTableViewCell.identifier)
    }

    private func getUserPreviews() {
        refreshButton.isEnabled = false
        userTableView.showAnimatedGradientSkeleton()

        if userPreviews.count > 0 {
            userTableView.scrollToFirstItem()
        }

        Task {
            let (message, newUserPreviews) = await networkService.getListUserRandom()
            userPreviews = newUserPreviews
            DispatchQueue.main.async {
                self.userTableView.hideSkeleton()
                self.userTableView.stopSkeletonAnimation()

                self.userTableView.reloadData()
                self.refreshButton.isEnabled = true

                if let _message = message {
                    self.showToast(message: _message)
                }
            }
        }
    }

    func didSendMessageBack(_ data: String) {
        showToast(message: data)
    }

    @IBAction func refreshUserPreviews(_: UIButton) {
        getUserPreviews()
    }
}

extension ViewController: SkeletonTableViewDataSource {
    static let defaultSkeletonNumber = 10

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return userPreviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell {
            let userPreview = userPreviews[indexPath.row]

            setCellContents(cell, userPreview, indexPath, tableView)

            return cell

        } else {
            return UITableViewCell()
        }
    }

    private func setCellContents(_ cell: UserTableViewCell, _ userPreview: UserPreview, _ indexPath: IndexPath, _ tableView: UITableView) {
        cell.userImageView.image = nil

        cell.usernameText.text = userPreview.username
        cell.githubUrlText.text = userPreview.githubUrl
        cell.userImageView.image = userPreview.image

        if userPreview.state == .new {
            cell.imageLoadingIndicator.isHidden = false
            cell.imageLoadingIndicator.startAnimating()
            imageDownloader.startDownloadImage(
                imageDownloadable: userPreview as ImageDownloadable,
                imageURL: userPreview.imageUrl,
                onCompletion: {
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    }
                }
            )
        } else {
            cell.imageLoadingIndicator.stopAnimating()
            cell.imageLoadingIndicator.isHidden = true
        }
    }

    func collectionSkeletonView(_: UITableView, cellIdentifierForRowAt _: IndexPath) -> ReusableCellIdentifier {
        return SkeletonTableViewCell.identifier
    }

    func collectionSkeletonView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return ViewController.defaultSkeletonNumber
    }

    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt _: IndexPath) -> UITableViewCell? {
        if let cell = skeletonView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier) as? SkeletonTableViewCell {
            cell.showSkeletons()

            return cell

        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: DetailViewController.segueIdentifier, sender: userPreviews[indexPath.row].username)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == DetailViewController.segueIdentifier else { return }

        guard let detailViewController = segue.destination as? DetailViewController else {
            return
        }

        detailViewController.username = sender as? String
        detailViewController.delegate = self
    }
}
