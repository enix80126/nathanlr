//
//  ViewController.swift
//  pockiiau
//
//  Created by samiiau on 2/27/23.
//  Copyright © 2023 samiiau. All rights reserved.
//

import UIKit

@objc class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = JailbreakViewController()
        let secondVC = OptionsViewController()

        firstVC.tabBarItem = UITabBarItem(title: "越狱", image: UIImage(systemName: "sparkles"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "选项", image: UIImage(systemName: "gear"), tag: 1)

        setViewControllers([firstVC, secondVC], animated: false)

        selectedIndex = 0
        
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        titleLabel.text = appName
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//
//        let versionLabel = UILabel()
//        versionLabel.translatesAutoresizingMaskIntoConstraints = false
//        versionLabel.text = "(16.0 - 16.6.1)"
//        versionLabel.font = UIFont.systemFont(ofSize: 10)
//        versionLabel.textColor = UIColor.secondaryLabel.withAlphaComponent(0.5)
//
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, versionLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 4
//
//        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: stackView)]
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)

        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: titleLabel)]

        
    }
    
}
