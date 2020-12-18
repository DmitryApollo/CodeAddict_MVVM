//
//  MainNavigationController.swift
//  CodeAddict
//
//  Created by Дмитрий on 10/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}
