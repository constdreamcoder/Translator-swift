//
//  TabBarViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let translateVC = UINavigationController(rootViewController: TranslateViewController())
        let favouriteVC = UINavigationController(rootViewController: FavouriteViewController())
       
        translateVC.tabBarItem = UITabBarItem(
            title: "Translation".localized,
            image: UIImage(named: "translateTabBarIcon"),
            selectedImage: UIImage(named: "translateTabBarIcon")// TODO: - 대표 색깔을 채워서 표시하기
        )
        favouriteVC.tabBarItem = UITabBarItem(
            title: "Saved".localized,
            image: UIImage(named: "favouriteTabBarIcon"),
            selectedImage: UIImage(named: "favouriteTabBarIcon") // TODO: - 대표 색깔을 채워서 표시하기
        )
        
        viewControllers = [translateVC, favouriteVC]
        
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
