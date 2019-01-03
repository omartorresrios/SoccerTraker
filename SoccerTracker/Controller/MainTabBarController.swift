//
//  MainTabBarController.swift
//  SoccerTracker
//
//  Created by Omar Torres on 1/2/19.
//  Copyright © 2019 OmarTorres. All rights reserved.
//

import UIKit
import Floaty

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedViewController = viewControllers?[0]
    }
}
