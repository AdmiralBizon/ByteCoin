//
//  ViewController.swift
//  ByteCoin
//
//  Created by Ilya on 08.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }

}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}

// MARK: - CoimManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoinPrice(rate: String, currencyName: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = rate
            self.currencyLabel.text = currencyName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
