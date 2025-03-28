import UIKit

class AboutViewController: UIViewController {
    @IBOutlet var aboutImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutImageView.setupCircleImageView()
    }
}
