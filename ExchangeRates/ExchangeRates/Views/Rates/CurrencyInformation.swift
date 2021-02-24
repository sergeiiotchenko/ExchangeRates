//
//  CurrencyInformation.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 23.02.21.
//

import UIKit

class CurrencyInformation: UIView {
    // MARK: - Variables
    private var edgeInsets = UIEdgeInsets(all: 10)

    // MARK: - GUI Variables
    
    
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
//        self.contentView.addSubview(self.mainView)
//        self.mainView.addSubviews([self.flagContainerView,
//                                   self.descriptionContainerView,
//                                   self.valueContainerView])
//
//        self.flagContainerView.addSubview(self.flagImageView)
//
//        self.descriptionContainerView.addSubviews([self.currencyScaleLabel,
//                                                   self.currencyAbbreviationLabel,
//                                                   self.currencyNameLabel])
//
//        self.valueContainerView.addSubviews([self.currencyOfficialRateLabel,
//                                             self.quotesView])
//
//        self.quotesView.addSubview(self.currencyQuotesLabel)
    }
    
    // MARK: - Constraints
    
    
    // MARK: - Setter
    func set(flag: String,
             scale: String,
             abbreviation: String,
             rate: String,
             name: String,
             quotes: String,
             color: UIColor) {
//        self.flagImageView.image = UIImage(named: flag)
//        self.currencyScaleLabel.text = scale
//        self.currencyAbbreviationLabel.text = abbreviation
//        self.currencyOfficialRateLabel.text = rate
//        self.currencyNameLabel.text = name
//        self.currencyQuotesLabel.text = quotes
//        self.quotesView.backgroundColor = color
//
//        self.setNeedsUpdateConstraints()
    }
}
