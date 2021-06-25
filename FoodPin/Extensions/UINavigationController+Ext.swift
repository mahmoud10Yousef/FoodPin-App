//
//  UINavigationController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/2/21.
//

import UIKit

extension UINavigationController{
    
    open override var childForStatusBarStyle: UIViewController?{ return topViewController }
}
