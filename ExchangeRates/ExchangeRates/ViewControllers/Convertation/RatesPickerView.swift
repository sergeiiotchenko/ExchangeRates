//
//  RatesPickerView.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 15.03.21.
//

import UIKit
import SnapKit

class RatesPickerView: UIPickerView,  UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Variables
    private var actualyRates: [NBRBRates] = []
    private let numberOfComponentsPV: Int = 1

    var pickerAction: ((Int) -> Void)?

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        dataSource = self
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    func setRates(array cells: [NBRBRates]) {
            self.actualyRates = cells
            self.reloadAllComponents()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponentsPV
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return actualyRates.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let result = actualyRates[row].abbreviation
        return result
    }
}
