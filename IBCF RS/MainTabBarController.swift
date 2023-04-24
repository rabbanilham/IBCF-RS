//
//  MainTabBarController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 29/03/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        setupView()
    }
}

private extension MainTabBarController {
    func makeUI() {
        
    }
    
    func setupView() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let courseListViewController = CourseListViewController(style: .insetGrouped)
        courseListViewController.tabBarItem = UITabBarItem(
            title: "Mata Kuliah",
            image: UIImage(systemName: "list.clipboard"),
            selectedImage: UIImage(systemName: "list.clipboard.fill")
        )
        
        let settingsViewController = SettingsViewController(style: .insetGrouped)
        settingsViewController.tabBarItem = UITabBarItem(
            title: "Pengaturan",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        let viewControllers: [UINavigationController] = [
            homeViewController,
            courseListViewController,
            settingsViewController
        ].map {
            let navigationController = UINavigationController(rootViewController: $0)
            return navigationController
        }
        
        self.viewControllers = viewControllers
    }
}
