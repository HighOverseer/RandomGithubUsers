//
//  SkeletonVisibilityDelegate.swift
//  RandomGithubUsers
//
//  Created by fajar on 10/03/25.
//

import Foundation
import UIKit

protocol SkeletonViewsDelegate{
    func setAllViewsSkeletonable(_ isSkeletonable:Bool)
    
    func showSkeletons()
    
    func hideSkeletons()
    
    var allCandidateSkeletonViews:[UIView]{
        get
    }
}

extension SkeletonViewsDelegate{
    func setAllViewsSkeletonable(_ isSkeletonable:Bool){
        allCandidateSkeletonViews.forEach{ view in
            view.isSkeletonable = isSkeletonable
        }
    }
    
    func showSkeletons(){
        allCandidateSkeletonViews.forEach{ view in
            view.showAnimatedGradientSkeleton()
        }
    }
    
    func hideSkeletons(){
        allCandidateSkeletonViews.forEach{ view in
            view.hideSkeleton()
            view.stopSkeletonAnimation()
            
        }
    }
}
