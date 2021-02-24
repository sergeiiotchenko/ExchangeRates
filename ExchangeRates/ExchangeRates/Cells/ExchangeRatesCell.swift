//
//  ExchangeRates.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 16.02.21.
//

import UIKit
import SnapKit

class ExchangeRatesCell: UITableViewCell {
    // MARK: - Idetifier
    static let reuseIdentifier = "ExchangeRatesCellIdentifier"
    

    // MARK: - Variables
    private(set) var edgeInsets = UIEdgeInsets(all: 10) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    private(set) var contentEdgeInsets = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 5) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    private var flagSize = CGSize(width: 50, height: 50)
    
    // MARK: - GUI Variables
    private lazy var mainView = UIView()
    
    private lazy var flagContainerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var valueContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var flagImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var currencyScaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var currencyAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var currencyOfficialRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var quotesView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var currencyQuotesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        self.contentView.addSubview(self.mainView)
        self.mainView.addSubviews([self.flagContainerView,
                                   self.descriptionContainerView,
                                   self.valueContainerView])
        
        self.flagContainerView.addSubview(self.flagImageView)
        
        self.descriptionContainerView.addSubviews([self.currencyScaleLabel,
                                                   self.currencyAbbreviationLabel,
                                                   self.currencyNameLabel])
        
        self.valueContainerView.addSubviews([self.currencyOfficialRateLabel,
                                             self.quotesView])
        
        self.quotesView.addSubview(self.currencyQuotesLabel)
    }
    
    // MARK: - Constraints
    override func updateConstraints() {
        self.mainView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.flagContainerView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().inset(self.edgeInsets)
            make.top.bottom.equalToSuperview().inset(2)
        }
        
        self.flagImageView.snp.updateConstraints { (make) in
            make.width.equalTo(self.flagSize)
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.descriptionContainerView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(2)
            make.right.equalTo(self.valueContainerView.snp.left)
            make.left.equalTo(self.flagContainerView.snp.right)
        }
        
        self.valueContainerView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(2)
            make.right.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyScaleLabel.snp.updateConstraints { (make) in
            make.top.left.equalTo(self.descriptionContainerView).inset(self.edgeInsets)
        }
        
        self.currencyAbbreviationLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.currencyScaleLabel.snp.centerY)
            make.left.equalTo(self.currencyScaleLabel.snp.right).offset(4)
        }
        
        self.currencyOfficialRateLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.currencyScaleLabel.snp.centerY)
            make.right.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyNameLabel.snp.updateConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(self.edgeInsets)
            make.right.equalToSuperview().inset(self.edgeInsets)
            make.top.equalTo(self.currencyScaleLabel.snp.bottom).offset(4)
        }
        
        self.quotesView.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.currencyNameLabel.snp.centerY)
            make.right.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.currencyQuotesLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.quotesView.snp.centerY)
            make.edges.equalTo(self.contentEdgeInsets)
        }
        
        super.updateConstraints()
    }

    // MARK: - Setter
    func set(flag: String,
             scale: String,
             abbreviation: String,
             rate: String,
             name: String,
             quotes: String,
             color: UIColor) {
        self.flagImageView.image = UIImage(named: flag)
        self.currencyScaleLabel.text = scale
        self.currencyAbbreviationLabel.text = abbreviation
        self.currencyOfficialRateLabel.text = rate
        self.currencyNameLabel.text = name
        self.currencyQuotesLabel.text = quotes
        self.quotesView.backgroundColor = color
        
        self.setNeedsUpdateConstraints()
    }
}
