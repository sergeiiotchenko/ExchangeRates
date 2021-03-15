//
//  CurrencyInformationViewController.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 22.02.21.
//

import UIKit
import SnapKit
import Charts

class CurrencyInformationViewController: UIViewController, UIPickerViewDelegate {
    // MARK: - Variables
    var id: String = ""
    var abbreviation = ""
    
    private let network = NetworkManager.shared
    
    private var todaysExchangeRates: [(flag: String,
                               abbreviation: String,
                               id: String,
                               date: String,
                               name: String,
                               scale: String,
                               rate: String,
                               quote: String,
                               color: UIColor)] = []
    private var dateForChartView: [String] = []
    
    // MARK: - GUI Variables
    private lazy var currencyInformationView: CurrencyInformationView = {
        let view = CurrencyInformationView()
        view.requestAction = { [weak self] index in
            guard let self = self else { return }
            self.sendRates(index)
        }
        view.setupCource = { [weak self] (cource, date) in
            guard let self = self else { return }
            self.setupCource(cource, self.dateForChartView[Int(date) - 1])
        }
        
        return view
    }()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.currencyInformationView)
        self.navigationItem.title = self.abbreviation
        
        self.setupConstraints()
        self.currencyInformationView.set(scale: self.todaysExchangeRates[0].scale,
                                         abbreviation: self.todaysExchangeRates[0].abbreviation,
                                         rate: self.todaysExchangeRates[0].rate,
                                         name: self.todaysExchangeRates[0].name,
                                         quotes: self.todaysExchangeRates[0].quote,
                                         color: self.todaysExchangeRates[0].color)
        
        self.sendRates(0)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        self.currencyInformationView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    func set(abbreviation: String, id: String, date: String,
             name: String, scale: String, rate: String,
             quote: String, color: UIColor) {
        self.todaysExchangeRates.append((flag: abbreviation, abbreviation: abbreviation,
                                         id: id, date: date, name: name, scale: scale,
                                         rate: rate, quote: quote, color: color))
    }
    
    private func setupCource(_ cource: Double, _ date: String) {
        let string = "Курс равен \(cource) на \(date)"
        self.currencyInformationView.setCource(string)
    }
    
    private func sendRates(_ index: Int) {
        var countDays: Int = 0
        var coursesForThePeriod: [ShortRates] = []
        var chartRatesValues: [ChartDataEntry] = []
        var x: Double = 1
        
        switch index {
        case 0:
            countDays = Period.week.rawValue
        case 1:
            countDays = Period.month.rawValue
        case 2:
            countDays = Period.quarter.rawValue
        case 3:
            countDays = Period.halfYear.rawValue
        case 4:
            countDays = Period.year.rawValue
        default: break
        }
        
        self.network.getRatesForACertainPeriod(id: id, range: countDays) { (rates) in
            self.dateForChartView.removeAll()
            DispatchQueue.main.async {
                coursesForThePeriod = rates
                
                rates.forEach {
                    chartRatesValues.append(ChartDataEntry(x: x, y: $0.rate))
                    x += 1.0
                    self.dateForChartView.append($0.date)
                }
                
                self.currencyInformationView.setData(
                    data: self.setupLineChartViewPropertiesAndData(chartRatesValues,
                                                                   description: self.abbreviation,
                                                                   coursesForThePeriod), x: 1, dataSetIndex: 0)
            }
        }
    }
    
    private func setupLineChartViewPropertiesAndData(_ entries: [ChartDataEntry],
                                             description label: String,
                                             _ array: [ShortRates]) -> LineChartData {
        let set = LineChartDataSet(entries: entries,
                                   label: label)
        let colorTop: CGColor
        let colorBottom: CGColor
        
        set.drawCirclesEnabled = false
        set.lineWidth = 1
        set.drawFilledEnabled = true
        set.highlightEnabled = true
        set.highlightColor = .systemBlue
        
        if array[0].rate < array.last?.rate ?? 0.0 {
            colorTop =  UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 0.05).cgColor
            colorBottom = UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 0.65).cgColor
            set.setColor(.systemRed)
        } else {
            colorTop =  UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 0.05).cgColor
            colorBottom = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 0.65).cgColor
            set.setColor(.systemGreen)
        }
        
        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors,
                                       locations: colorLocations)
        
        if let gradient = gradient {
            set.fill = Fill(linearGradient: gradient, angle: 90)
            set.fillAlpha = 0.7
        }
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        
        return data
    }
}
