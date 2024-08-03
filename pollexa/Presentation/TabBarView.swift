//
//  TabBarView.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation
import UIKit
import SnapKit

class TabBarView: UITabBarController{
  
  override func viewDidLoad() {
         super.viewDidLoad()
    tabBar.backgroundColor = UIColor(named: "MainBackgroundColor")

         // Tab bar item'ları ayarlama
         let myPollsViewController = MyPollsViewController()
         myPollsViewController.tabBarItem =  UITabBarItem(title: "My Polls", image: UIImage(systemName: "square.and.pencil"), tag: 0)
         
    let allPollsViewController = AllPollsViewController()
            allPollsViewController.tabBarItem = UITabBarItem(title: "Polls", image: UIImage(systemName: "chart.pie"), tag: 1)
    
    let settingsViewController = SettingsViewController()
            settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2) //
         
         let viewControllerList = [myPollsViewController, allPollsViewController, settingsViewController]
         
         viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    
    selectedIndex = 1
    
    let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = tabBar.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.backgroundColor = UIColor(named: "MainBackgroundColor")?.withAlphaComponent(0.5)
            tabBar.insertSubview(blurEffectView, at: 0)
    
    
    tabBar.tintColor = UIColor(named: "TextColor") // Seçili item rengi
            tabBar.unselectedItemTintColor = UIColor(named: "TextColor")?.withAlphaComponent(0.6)
     }
  
  
}







