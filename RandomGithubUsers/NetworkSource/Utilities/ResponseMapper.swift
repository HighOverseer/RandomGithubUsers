//
//  ResponseMapper.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation

class ResponseMapper{
    static let shared = ResponseMapper()
    
    private init(){}
    
    func mapUserPreviewResponse(response:UserPreviewResponse) -> UserPreview{
        let imageUrl = URL(string: response.imageURL)!
        return UserPreview(username: response.username, imageUrl: imageUrl, githubUrl: response.githubURL)
    }
    
    func mapUserDetailResponse(response:UserDetailResponse) -> UserDetail{
        let imageUrl = URL(string: response.imageUrl)!
        let profileUrl = URL(string: response.profileUrl)!
        
        let userInformations = [response.company, response.location, response.email, response.blog]
        
        var userInfoOne:String = ""
        var userInfoTwo:String = ""
        
        for info in userInformations{
            guard let _info = info else{
                continue
            }
            
            if userInfoOne.isEmpty {
                userInfoOne = _info
            }else {
                userInfoTwo = _info
            }
        }
        
        
        return UserDetail(username: response.username, name: response.name ?? "-", imageUrl: imageUrl, repoCount: response.repoCount, followerCount: response.followersCount, followingCount: response.followingCount, userInfoOne: userInfoOne, userInfoTwo: userInfoTwo,  profileUrl: profileUrl,  userBiography: response.bio ?? "-")
        
    }
    
}
