import UIKit

protocol ImageDownloadable: AnyObject {
    var image: UIImage? {
        get set
    }

    var state: DownloadState {
        get set
    }
}
