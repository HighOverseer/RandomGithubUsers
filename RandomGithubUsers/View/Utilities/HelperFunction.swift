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
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        let toastView = UILabel(frame: CGRect(x: 20, y: self.view.frame.height - 120, width: self.view.frame.width - 40, height: 50))
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.text = message
        toastView.alpha = 0.0
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        
        self.view.addSubview(toastView)

        UIView.animate(withDuration: 0.5, animations: {
            toastView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}


extension UITableView{
    func scrollToFirstItem(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
