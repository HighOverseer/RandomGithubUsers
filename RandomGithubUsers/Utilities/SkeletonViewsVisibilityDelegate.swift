//
//  SkeletonVisibilityDelegate.swift
//  RandomGithubUsers
//
//  Created by fajar on 10/03/25.
//

import Foundation
import UIKit

protocol SkeletonViewsVisibilityDelegate{
    func showSkeletons()
    
    func hideSkeletons()
    
    var allViews:[UIView]{
        get
    }
}

extension SkeletonViewsVisibilityDelegate{
    func showSkeletons(){
        allViews.forEach{ view in
            view.showAnimatedGradientSkeleton()
        }
    }
    
    func hideSkeletons(){
        allViews.forEach{ view in
            view.stopSkeletonAnimation()
            view.hideSkeleton()
        }
    }
}
