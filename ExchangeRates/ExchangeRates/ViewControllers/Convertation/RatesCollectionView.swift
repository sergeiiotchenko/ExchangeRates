//
//  RatesCollectionView.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 15.03.21.
//

import UIKit
import SnapKit

struct Constants {
    static let leftDistanceToView: CGFloat = 30
    static let rightDistanceToView: CGFloat = 30
    static let galleryMinimumLineSpacing: CGFloat = 10
}

class RatesCollectionView: UICollectionView,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    // MARK: - Variables
    private var actualyRates: [NBRBRates] = []
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        register(ERCollectionViewCell.self,
                 forCellWithReuseIdentifier: ERCollectionViewCell.reuseIdentifier)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.galleryMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 10,
                                    left: Constants.leftDistanceToView,
                                    bottom: 10,
                                    right: Constants.rightDistanceToView)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setRates(array cells: [NBRBRates]) {
        self.actualyRates = cells
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return actualyRates.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
            withReuseIdentifier: ERCollectionViewCell.reuseIdentifier,
            for: indexPath)
        
        let rates: NBRBRates = self.actualyRates[indexPath.row]
        
        if let cell = cell as? ERCollectionViewCell {
            cell.set(flag: rates.abbreviation,
                     scale: String(rates.scale),
                     abbreviation: rates.abbreviation,
                     rate: "\(rates.rate) BYN")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.2,
                      height: collectionView.frame.width/3.2)
    }

}
