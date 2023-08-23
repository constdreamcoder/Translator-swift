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
            title: "번역",
            image: UIImage(named: "translateTabBarIcon"),
            selectedImage: UIImage(named: "translateTabBarIcon")// TODO: - 대표 색깔을 채워서 표시하기
        )
        favouriteVC.tabBarItem = UITabBarItem(
            title: "즐겨찾기",
            image: UIImage(named: "favouriteTabBarIcon"),
            selectedImage: UIImage(named: "favouriteTabBarIcon") // TODO: - 대표 색깔을 채워서 표시하기
        )
        
        viewControllers = [translateVC, favouriteVC]
        
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
