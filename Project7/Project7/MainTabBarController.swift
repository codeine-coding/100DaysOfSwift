//
//  MainTabBarController.swift
//  Project7
//
//  Created by Allen Whearry on 3/31/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    fileprivate func setupView() {
        let recentPetitions = UINavigationController(rootViewController: ViewController())
        recentPetitions.title = "Recent"
        recentPetitions.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.mostRecent, tag: 0)

        let popularPetitions = UINavigationController(rootViewController: ViewController())
        popularPetitions.title = "Popular"
        popularPetitions.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)


        self.viewControllers = [ recentPetitions, popularPetitions ]
        self.selectedIndex = 0
    }

}
