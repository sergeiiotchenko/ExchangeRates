//
//  ERCollectionViewCell.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 15.03.21.
//

import UIKit
import SnapKit

class ERCollectionViewCell: UICollectionViewCell {
    // MARK: - Idetifier
    static var reuseIdentifier = "ERCollectionViewCellId"

    // MARK: - Variables
    private(set) var edgeInsets = UIEdgeInsets(all: 10) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    private var flagSize = CGSize(width: 50, height: 50)
    
    // MARK: - GUI Variables
    private lazy var mainView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var flagImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    var currencyScaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    var currencyAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    var currencyOfficialRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    private func initView() {
        self.contentView.addSubview(self.mainView)
        self.mainView.addSubviews([self.flagImageView,
                                   self.currencyAbbreviationLabel,
                                   self.currencyScaleLabel,
                                   self.currencyOfficialRateLabel])
        
        self.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 8)
        layer.shadowPath = shadowPath.cgPath
        
        self.clipsToBounds = false

    }

    // MARK: - Constraints
    override func updateConstraints() {
        self.mainView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.flagImageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.edgeInsets)
            make.size.equalTo(self.flagSize)
        }
        
        self.currencyScaleLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.flagImageView.snp.centerY)
            make.left.equalTo(self.flagImageView.snp.right).offset(4)
        }

        self.currencyAbbreviationLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.flagImageView.snp.centerY)
            make.left.equalTo(self.currencyScaleLabel.snp.right).offset(4)
        }

        self.currencyOfficialRateLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.flagImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        super.updateConstraints()
    }

    // MARK: - Setter
    func set(flag: String, scale: String, abbreviation: String, rate: String) {
        self.flagImageView.image = UIImage(named: flag)
        self.currencyScaleLabel.text = scale
        self.currencyAbbreviationLabel.text = abbreviation
        self.currencyOfficialRateLabel.text = rate
    }
}
