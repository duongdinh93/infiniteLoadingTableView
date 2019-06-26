//
//  TabbarController.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    /// Singleton
    static let shared = TabbarController()
    
    private var viewModel: TabbarViewModelProtocol = TabbarViewModel()
}

// MARK: - Life Cycle
extension TabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponents()
    }
}

// MARK: - Inits
extension TabbarController {
    
    func initComponents() {
        viewControllers = viewModel.getTabbarViewControllers()
    }
}
