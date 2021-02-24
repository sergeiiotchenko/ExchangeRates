//
//  RatesViewController.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 14.02.21.
//

import UIKit
import Network

class RatesViewController: UIViewController {
    // MARK: - Variables
    let networkManager = NetworkManager()
    
    var actualyRates: [Rates] = []
    
    // MARK: - GUI Variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeRatesCell.self,
                           forCellReuseIdentifier: ExchangeRatesCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
        
        return activityView
    }()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Курсы НБРБ"
        
        self.view.addSubview(self.tableView)
        setupTableViewConstraints()
        
        networkManager.getTodayRates { (rates) in
            self.actualyRates = rates
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityView.stopAnimating()
            }
        }
    }
    
    // MARK: - Constraints
    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.activityView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor)
        ])
    }
    
    // MARK: - Methods
    
}

extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actualyRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ExchangeRatesCell.reuseIdentifier,
                                                      for: indexPath)
        if let cell = cell as? ExchangeRatesCell {
            cell.set(flag: actualyRates[indexPath.row].abbreviation,
                     scale: actualyRates[indexPath.row].scale,
                     abbreviation: actualyRates[indexPath.row].abbreviation,
                     rate: actualyRates[indexPath.row].rate,
                     name: actualyRates[indexPath.row].name,
                     quotes: actualyRates[indexPath.row].quote,
                     color: actualyRates[indexPath.row].color)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrencyInformationViewController()
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * .pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.2, delay: 0.01 * Double(indexPath.row), options: .curveEaseIn) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
}