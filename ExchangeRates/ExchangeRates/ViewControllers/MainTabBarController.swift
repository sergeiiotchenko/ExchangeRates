//
//  MainTabBarController.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 13.02.21.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBarController()
    }
    
    // MARK: - Methods
    private func setupTabBarController() {
        let mainView = UINavigationController(rootViewController: RatesViewController())
        mainView.title = "Курсы"
        mainView.tabBarItem.image = UIImage(named: "rates")
        
        let banksView = UINavigationController(rootViewController: BanksViewController())
        banksView.title = "Банки"
        banksView.tabBarItem.image = UIImage(named: "banks")
        
        let convertationView = UINavigationController(rootViewController: ConvertationViewController())
        convertationView.title = "Конвертация"
        convertationView.tabBarItem.image = UIImage(named: "convertation")
        
        viewControllers = [mainView,banksView,convertationView]
    }
}

