//
//  ImageDownloader.swift
//  RandomGithubUsers
//
//  Created by fajar on 09/03/25.
//

import Foundation
import UIKit

class ImageDownloader{
    
    func startDownloadImage(imageDownloadable: ImageDownloadable, imageURL: URL, onCompletion: @escaping () -> Void){
        guard imageDownloadable.state == .new else {
            return
        }
        
        Task{
            do{
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                imageDownloadable.image = UIImage(data: data)
                imageDownloadable.state = .downloaded
                onCompletion()
            }catch{
                imageDownloadable.state = .failed
                imageDownloadable.image = nil
            }
        }

    }
}
