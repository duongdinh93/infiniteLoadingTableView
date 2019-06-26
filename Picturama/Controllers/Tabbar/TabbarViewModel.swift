//
//  TabbarViewModel.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import Foundation
import UIKit

/// Defines modules of tabbar
enum TabbarModule: CaseIterable {
    case picture
    case video
    case saved
}

protocol TabbarViewModelProtocol {
    
    func titleForModule( _ module: TabbarModule) -> String
    
    func getTabbarViewControllers() -> [UIViewController]
}

class TabbarViewModel: TabbarViewModelProtocol {
    
    private var tabbarViewControllers = [UIViewController]()
    
    func titleForModule(_ module: TabbarModule) -> String {
        switch module {
        case .picture:
            return "Pictures"
        case .video:
            return "Videos"
        case .saved:
            return "Saved"
        }
    }
    
    private func viewController(for module: TabbarModule) -> UIViewController {
        switch module {
        case .picture:
            return UINavigationController(rootViewController: ListPictureViewController())
        case .video:
            return UINavigationController(rootViewController: ListVideosViewController())
        case .saved:
            return UINavigationController(rootViewController: SavedContentViewController())
        }
    }
    
    func getTabbarViewControllers() -> [UIViewController] {
        guard tabbarViewControllers.isEmpty else {
            return tabbarViewControllers
        }
        
        TabbarModule.allCases.forEach { (module) in
            let viewController = self.viewController(for: module)
            viewController.title = self.titleForModule(module)
            tabbarViewControllers.append(viewController)
        }
        
        return tabbarViewControllers
    }
}
