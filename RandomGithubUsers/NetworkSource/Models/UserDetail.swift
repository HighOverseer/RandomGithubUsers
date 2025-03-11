//
//  UserDetail.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation
import UIKit

class UserDetail: ImageDownloadable{
    let username:String
    let name:String
    let imageUrl:URL
    let repoCount:Int
    let followerCount:Int
    let followingCount:Int
    let userInfoOne:String
    let userInfoTwo:String
    let userBiography:String
    let profileUrl:URL
    
    var image:UIImage?
    var state:DownloadState = .new
    
    init(username: String, name: String, imageUrl: URL, repoCount: Int, followerCount: Int, followingCount: Int, userInfoOne: String, userInfoTwo: String, profileUrl:URL, userBiography:String) {
        self.username = username
        self.name = name
        self.imageUrl = imageUrl
        self.repoCount = repoCount
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.userInfoOne = userInfoOne
        self.userInfoTwo = userInfoTwo
        self.profileUrl = profileUrl
        self.userBiography = userBiography
        
    }
}
