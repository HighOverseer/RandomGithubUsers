//
//  AboutViewController.swift
//  RandomGithubUsers
//
//  Created by fajar on 10/03/25.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aboutImageView.setupCircleImageView()
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
