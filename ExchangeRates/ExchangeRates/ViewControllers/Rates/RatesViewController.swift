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
    private var actualyRates: [NBRBRates] = []
    private var actualyRatesFiltered: [NBRBRates] = []
    
    private let refreshControl = UIRefreshControl()
    private let search = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = search.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return self.search.isActive && !self.searchBarIsEmpty
    }
    
    // MARK: - GUI Variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeRatesCell.self,
                           forCellReuseIdentifier: ExchangeRatesCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.updateTable), for: .valueChanged)
        
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
        
        self.setupTableViewConstraints()
        self.setRates()
        self.setupSearchBar()
    }
    
    
    // MARK: - Constraints
    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.activityView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor)
        ])
        
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Functions
    func setupSearchBar() {
        self.navigationItem.searchController = search
        search.searchResultsUpdater = self
        self.search.obscuresBackgroundDuringPresentation = false
        self.search.searchBar.placeholder = "Валюта"
        self.definesPresentationContext = true
    }
    
    private func setRates() {
        if NetworkChecker.isConnectedToNetwork() {
            NetworkManager.shared.getTodayRates { [weak self] (rates) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.actualyRates = rates
                    self.activityView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        } else {
            self.activityView.stopAnimating()
            
            let title: String = "Ошибка!"
            let message: String = "Отсутствует подключение к интернету."
            
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Обновить", style: .default, handler: { _ in
                self.setRates()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func updateTable() {
        self.setRates()
        self.refreshControl.endRefreshing()
    }
}

//MARK: - Extensions
extension RatesViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(self.search.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        self.actualyRatesFiltered = actualyRates.filter({ (rates: NBRBRates) -> Bool in
            return rates.abbreviation.lowercased().contains(searchText.lowercased()) || rates.name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isFiltering ? self.actualyRatesFiltered.count : self.actualyRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ExchangeRatesCell.reuseIdentifier, for: indexPath)
        var rates: NBRBRates
        
        self.isFiltering ? (rates = self.actualyRatesFiltered[indexPath.row]) : (rates = self.actualyRates[indexPath.row])
        
        if let cell = cell as? ExchangeRatesCell {
            cell.set(flag: rates.abbreviation,
                     scale: rates.scale,
                     abbreviation: rates.abbreviation,
                     rate: rates.rate,
                     name: rates.name,
                     quotes: rates.quote,
                     color: rates.color)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrencyInformationViewController()
        var rates: NBRBRates
        
        self.isFiltering ? (rates = self.actualyRatesFiltered[indexPath.row]) : (rates = self.actualyRates[indexPath.row])
        
        vc.set(abbreviation: rates.abbreviation,
               id: rates.id,
               date: rates.date,
               name: rates.name,
               scale: rates.scale,
               rate: rates.rate,
               quote: rates.quote,
               color: rates.color)
        
        vc.id = self.actualyRates[indexPath.row].id
        vc.abbreviation = self.actualyRates[indexPath.row].abbreviation
        
        DispatchQueue.main.async {
            //self.present(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
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
