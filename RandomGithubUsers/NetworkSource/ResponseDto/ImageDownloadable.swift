//
//  ImageDownloadable.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation
import UIKit

protocol ImageDownloadable:AnyObject{
    var image:UIImage?{
        get set
    }
    
    var state:DownloadState{
        get set
    }
}
