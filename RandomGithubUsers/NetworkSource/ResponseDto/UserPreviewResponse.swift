//
//  UserPreviewResponse.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation

struct UserPreviewResponse:Codable{
    let username:String
    let imageURL:String
    let githubURL:String
    
    enum CodingKeys: String, CodingKey{
        case username = "login"
        case imageURL = "avatar_url"
        case githubURL = "html_url"
    }
}
