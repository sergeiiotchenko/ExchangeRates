//
//  MainTabBarController.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 13.02.21.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Variables
    let ratesVC = RatesViewController()
    let convertationVC = ERConvertationViewController()
    
    let ratesNC = UINavigationController(
        rootViewController: RatesViewController())
    let convertationNC = UINavigationController(
        rootViewController: ERConvertationViewController())
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBarController()
    }
    
    // MARK: - Methods
    private func setupTabBarController() {
        self.ratesNC.navigationBar.prefersLargeTitles = true
        self.convertationNC.navigationBar.prefersLargeTitles = true
        
        self.ratesVC.navigationItem.largeTitleDisplayMode = .always
        self.convertationVC.navigationItem.largeTitleDisplayMode = .always
        
        self.ratesNC.tabBarItem = UITabBarItem(title: "Курсы",
                                               image: UIImage(named: "rates"),
                                               tag: 1)
        self.convertationNC.tabBarItem = UITabBarItem(title: "Конвертация",
                                                      image: UIImage(named: "convertation"),
                                                      tag: 1)
        
        setViewControllers([self.ratesNC, self.convertationNC], animated: false)
    }
}

