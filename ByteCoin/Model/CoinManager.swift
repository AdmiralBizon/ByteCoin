//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Ilya on 08.08.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(rate: String, currencyName: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1DD287E4-BFDC-4671-A41B-F9BE27B24330"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR",
                         "ILS","INR","JPY","MXN","NOK","NZD","PLN","RON",
                         "RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
       
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
       
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
               if let coinRate = self.parseJSON(safeData){
                   
                   let rateString = String(format: "%.2f", coinRate)
                   
                   self.delegate?.didUpdateCoinPrice(rate: rateString,
                                                     currencyName: currency)
                }
            }
            
        }.resume()
        
    }
    
    func parseJSON(_ data: Data) -> Double? {

        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate

            return rate

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
