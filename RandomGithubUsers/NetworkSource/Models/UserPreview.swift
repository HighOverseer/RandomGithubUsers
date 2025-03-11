//
//  UserPreview.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation
import UIKit

class UserPreview: ImageDownloadable{
    let username:String
    let imageUrl:URL
    let githubUrl:String
    
    var image:UIImage?
    var state:DownloadState = .new
    
    init(username: String, imageUrl: URL, githubUrl: String) {
        self.username = username
        self.imageUrl = imageUrl
        self.githubUrl = githubUrl
    }
}
