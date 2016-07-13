//
//  NavagationCotrollerDelegate.swift
//  CircleTransition
//
//  Created by LiQuan on 16/7/13.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

import UIKit

class NavagationCotrollerDelegate: NSObject , UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleTransitionAnimator()
    }

}
