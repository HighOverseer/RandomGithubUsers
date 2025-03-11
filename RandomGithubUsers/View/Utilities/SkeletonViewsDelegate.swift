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
    
    var allViews:[UIView]{
        get
    }
}

extension SkeletonViewsDelegate{
    func setAllViewSkeletonable(_ isSkeletonable:Bool){
        allViews.forEach{ view in
            view.isSkeletonable = isSkeletonable
        }
    }
    
    func showSkeletons(){
        allViews.forEach{ view in
            view.showAnimatedGradientSkeleton()
        }
    }
    
    func hideSkeletons(){
        allViews.forEach{ view in
            view.hideSkeleton()
            view.stopSkeletonAnimation()
            
        }
    }
}
