//
//  ERConvertationViewController.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 15.03.21.
//

import UIKit
import SnapKit

class ERConvertationViewController: UIViewController,
                                    UIPickerViewDelegate,
                                    UIPickerViewDataSource,
                                    UITextFieldDelegate {
    
    
    // MARK: - Variables
    private var actualyRates: [NBRBRates] = []
    private(set) var edgeInsets = UIEdgeInsets(all: 10)
    
    private lazy var collectionViewHeight = 190
    private lazy var pickerSize = CGSize(width: 120, height: 70)
    private lazy var textFieldSize = CGSize(width: 150, height: 50)
    private lazy var firstPickerRowWalue = 0
    private lazy var secondPickerRowWalue = 0
    
    var pickerAction: ((Int) -> Void)?
    
    var firstTextFildAction: ((Int) -> Void)?
    var secondTextFildAction: ((Int) -> Void)?
    
    // MARK: - GUI Variables
    private lazy var mainView: UIView = {
        let view = UIView()
        self.view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private lazy var collectionView: RatesCollectionView = {
        let view = RatesCollectionView()
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private var firstRatesPicker: RatesPickerView = {
        let picker = RatesPickerView()
        picker.backgroundColor = .clear
        picker.tag = 1
        
        return picker
    }()
    
    private var secondRatesPicker: RatesPickerView = {
        let picker = RatesPickerView()
        picker.backgroundColor = .clear
        picker.tag = 2

        return picker
    }()
    
    private lazy var firstTF: UITextField = {
        let text = UITextField()
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.separator.cgColor
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 25)
        text.tag = 3
        text.keyboardType = .numberPad
        text.isEnabled = false
        text.isUserInteractionEnabled = false
        
        return text
    }()
    
    private lazy var secondTF: UITextField = {
        let text = UITextField()
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.separator.cgColor
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 25)
        text.tag = 4
        text.keyboardType = .numberPad
        
        return text
    }()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRates()
        self.navigationItem.title = "Конвертация валют"
        
        self.firstRatesPicker.delegate = self
        self.secondRatesPicker.delegate = self
        self.firstTF.delegate = self
        self.secondTF.delegate = self
        
        self.view.addSubview(self.mainView)
        self.mainView.addSubviews([self.collectionView,
                                   self.firstRatesPicker,
                                   self.secondRatesPicker,
                                   self.firstTF,
                                   self.secondTF])
        self.setupConstraints()
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        self.mainView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }
        
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(120)
            make.left.equalTo(self.mainView.snp.left)
            make.right.equalTo(self.mainView.snp.right)
            make.height.equalTo(self.collectionViewHeight)
        }
        
        self.firstRatesPicker.snp.updateConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(self.pickerSize)
        }
        
        self.secondRatesPicker.snp.updateConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(50)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(self.pickerSize)
        }
        
        self.firstTF.snp.updateConstraints { (make) in
            make.top.equalTo(self.firstRatesPicker.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(self.textFieldSize)
        }
        
        self.secondTF.snp.updateConstraints { (make) in
            make.top.equalTo(self.firstRatesPicker.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(self.textFieldSize)
        }
    }
    
    // MARK: - Functions
    private func setRates() {
        if NetworkChecker.isConnectedToNetwork() {
            NetworkManager.shared.getTodayRates { [weak self] (rates) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.actualyRates = rates
                    self.actualyRates.append(NBRBRates.init(abbreviation: "BYN",
                                                            id: "1",
                                                            date: rates[0].date,
                                                            name: "Беларуский рубль",
                                                            scale: 1,
                                                            rate: 1.0000,
                                                            quote: "0.0000",
                                                            color: .systemGreen))
                    
                    self.collectionView.setRates(array: self.actualyRates)
                    self.firstRatesPicker.setRates(array: self.actualyRates)
                    self.secondRatesPicker.setRates(array: self.actualyRates)
                    self.firstTF.text = String(self.actualyRates[0].rate)
                    self.secondTF.text = String(self.actualyRates[0].rate)
                    
                }
            }
        } else {
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
    
    
    // Почти готовая модель для 
    func equalRates(_ textFieldTag : Int, _ firstPickerNominal: Int, _ secondPickerNominar: Int) {
        let firstValue = self.actualyRates[firstPickerNominal].rate
        let secondValue = self.actualyRates[secondPickerNominar].rate
        print("1")
        var firstEditingValue: Double = Double(actualyRates[firstPickerNominal].scale)
        var secondEditingValue: Double = Double(actualyRates[secondPickerNominar].scale)
        
        switch textFieldTag {
        case 1:
            let value = (firstEditingValue / firstValue) / (secondEditingValue / secondValue)
            if firstEditingValue != 1 {
                firstEditingValue = firstEditingValue / firstEditingValue
            }
            self.firstTF.text = String(firstEditingValue)
            self.secondTF.text = String(value)
        case 2:
            let value =  (secondEditingValue / secondValue) / (firstEditingValue / firstValue)
            if secondEditingValue != 1 {
                secondEditingValue = secondEditingValue / secondEditingValue
            }
            self.firstTF.text = String(value)
            self.secondTF.text = String(secondEditingValue)
        case 3:
            let value = (firstEditingValue / firstValue) / (secondEditingValue / secondValue)
            if firstEditingValue != 1 {
                firstEditingValue = firstEditingValue / firstEditingValue
            }
            self.firstTF.text = String(firstEditingValue)
            self.secondTF.text = String(value)
        case 4:
            let value =  (secondEditingValue / secondValue) / (firstEditingValue / firstValue)
            if secondEditingValue != 1 {
                secondEditingValue = secondEditingValue / secondEditingValue
            }
            self.firstTF.text = String(value)
            self.secondTF.text = String(secondEditingValue)
        default:
            break
        }
    }
    
    
    // MARK: - Function from extension UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actualyRates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let result = actualyRates[row].abbreviation
        return result
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            self.firstPickerRowWalue = row
            self.firstTF.text = String(self.actualyRates[row].rate)
            self.equalRates(pickerView.tag, firstPickerRowWalue, secondPickerRowWalue)
            
        case 2:
            self.secondPickerRowWalue = row
            self.secondTF.text = String(self.actualyRates[row].rate)
            self.equalRates(pickerView.tag, firstPickerRowWalue, secondPickerRowWalue)
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.equalRates(textField.tag, firstPickerRowWalue, secondPickerRowWalue)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.equalRates(textField.tag, firstPickerRowWalue, secondPickerRowWalue)
    }
}


