//
//  CurrencyInformationView.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 23.02.21.
//

import UIKit
import SnapKit
import Charts

class CurrencyInformationView: UIView, ChartViewDelegate {
    // MARK: - Variables
    private(set) var edgeInsets = UIEdgeInsets(all: 10) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    private let lineHeight: CGFloat = 1
    private let heightSegmentedControl = 30
    private let heightLineChartView = 200
    
    var requestAction: ((Int) -> Void)?
    var setupCource: ((Double, Double) -> Void)?
    
    // MARK: - GUI Variables
    private lazy var mainView = UIView()
    
    private lazy var descriptionView = UIView()
    
    private lazy var currencyScaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private lazy var currencyOfficialRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var infoQuotesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "По отношению ко вчерашнему дню"
        
        return label
    }()
    
    private lazy var currencyQuotesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var secongHorizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        
        return view
    }()
    
    private lazy var chartsView = UIView()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["1Н", "1М", "3М", "6М", "1Г"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentSelection), for: .valueChanged)
        
        return control
    }()
    
    private lazy var courceForTheSelectedDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        
        chart.xAxis.labelTextColor = self.currencyOfficialRateLabel.textColor
        chart.rightAxis.labelTextColor = self.currencyOfficialRateLabel.textColor
        chart.legend.textColor = self.currencyOfficialRateLabel.textColor
        chart.xAxis.enabled = false
        
        chart.noDataText = ""
        
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        
        chart.leftAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        
        chart.delegate = self
        
        return chart
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func initView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(self.mainView)
        self.mainView.addSubviews([self.descriptionView,
                                   self.chartsView])
        
        self.descriptionView.addSubviews([self.currencyScaleLabel,
                                          self.currencyNameLabel,
                                          self.currencyOfficialRateLabel,
                                          self.infoQuotesLabel,
                                          self.currencyQuotesLabel])
        
        self.chartsView.addSubviews([self.secongHorizontalLineView,
                                     self.segmentedControl,
                                     self.courceForTheSelectedDayLabel,
                                     self.lineChartView])
        
        self.updateConstraints()
    }
    
    // MARK: - Constraints
    override func updateConstraints() {
        self.mainView.snp.updateConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        self.descriptionView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.infoQuotesLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.currencyOfficialRateLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyOfficialRateLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyScaleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.currencyOfficialRateLabel.snp.right).offset(10)
            make.centerY.equalTo(self.currencyOfficialRateLabel.snp.centerY)
        }
        
        self.currencyNameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.currencyScaleLabel.snp.right).offset(4)
            make.centerY.equalTo(self.currencyScaleLabel.snp.centerY)
            make.right.lessThanOrEqualToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyQuotesLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.infoQuotesLabel.snp.centerY)
            make.left.equalTo(self.infoQuotesLabel.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.chartsView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
            make.top.equalTo(self.descriptionView.snp.bottom)
        }
        
        self.secongHorizontalLineView.snp.updateConstraints { (make) in
            make.width.equalTo(self.courceForTheSelectedDayLabel.snp.width)
            make.height.equalTo(self.lineHeight)
            make.top.equalToSuperview()
            make.centerX.equalTo(self.chartsView.snp.centerX)
        }
        
        self.courceForTheSelectedDayLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.secongHorizontalLineView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        self.lineChartView.snp.updateConstraints { (make) in
            make.top.equalTo(self.courceForTheSelectedDayLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-4)
            make.height.greaterThanOrEqualTo(self.heightLineChartView)
        }
        
        self.segmentedControl.snp.updateConstraints { (make) in
            make.top.equalTo(self.lineChartView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(self.heightSegmentedControl)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setter
    func set(scale: String,
             abbreviation: String,
             rate: String,
             name: String,
             quotes: String,
             color: UIColor) {
        self.currencyScaleLabel.text = scale
        self.currencyOfficialRateLabel.text = "Курс равен    \(rate)"
        self.currencyNameLabel.text = name
        self.currencyQuotesLabel.text = quotes
        self.currencyQuotesLabel.textColor = color
        self.courceForTheSelectedDayLabel.text = "Курс равен \(rate)"
        
        self.setNeedsUpdateConstraints()
    }
    
    func setData(data: LineChartData, x: Double, dataSetIndex: Int) {
        self.lineChartView.data = data
        self.lineChartView.highlightValue(x: x, dataSetIndex: dataSetIndex)
    }
    
    func setCource(_ cource: String) {
        self.courceForTheSelectedDayLabel.text = cource
    }
    
    // MARK: - Functions
    @objc func segmentSelection(_ sender: UISegmentedControl) {
        self.requestAction?(sender.selectedSegmentIndex)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.setupCource?(entry.y, entry.x)
    }
}
