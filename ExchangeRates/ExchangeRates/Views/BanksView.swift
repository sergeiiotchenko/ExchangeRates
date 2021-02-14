//
//  BanksView.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 14.02.21.
//

import UIKit
import SnapKit

class BanksView: UIView {
    // MARK: - Variables
    
    // MARK: - GUI Variables
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .lightGray
    }
    
    // MARK: - Constraints
    
    // MARK: - Methods
    
}
