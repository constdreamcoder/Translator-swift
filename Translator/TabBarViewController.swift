//
//  TabBarViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let translateVC = UINavigationController(rootViewController: TranslateViewController())
        let favouriteVC = UINavigationController(rootViewController: FavouriteViewController())
       
        translateVC.tabBarItem = UITabBarItem(
            title: "Translate",
            image: UIImage(named: "translateTabBarIcon"),
            selectedImage: UIImage(named: "translateTabBarIcon")// todo: 대표 색깔을 채워서 표시하기
        )
        favouriteVC.tabBarItem = UITabBarItem(
            title: "Favourite",
            image: UIImage(named: "favouriteTabBarIcon"),
            selectedImage: UIImage(named: "favouriteTabBarIcon") // todo: 대표 색깔을 채워서 표시하기
        )
        
        viewControllers = [translateVC, favouriteVC]
    }
    
    
    
    
}
