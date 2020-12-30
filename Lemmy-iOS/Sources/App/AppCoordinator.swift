//
//  AppCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    let window: UIWindow
    
    private let userAccountService = UserAccountService()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        
        if LemmyShareData.shared.isLoggedIn {
            let myCoordinator = LemmyTabBarCoordinator()

            // store child coordinator
            self.store(coordinator: myCoordinator)
            myCoordinator.start()

            window.rootViewController = myCoordinator.rootViewController
        } else {
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))

            // store child coordinator
            self.store(coordinator: myCoordinator)
            myCoordinator.start()
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)
            
            window.rootViewController = myCoordinator.router.navigationController
        }
        
        window.makeKeyAndVisible()
    }
}
