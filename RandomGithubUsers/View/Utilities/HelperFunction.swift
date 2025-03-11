//
//  HelperFunction.swift
//  RandomGithubUsers
//
//  Created by fajar on 10/03/25.
//

import Foundation
import UIKit

extension UIImageView{
    func setupCircleImageView(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UITableView{
    func scrollToFirstItem(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
