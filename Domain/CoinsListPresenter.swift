//
//  CoinsListPresenter.swift
//  MarketCoins
//
//  Created by Matheus Accorsi on 26/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CoinsListPresentationLogic {
    func presentGlobalValues(response: CoinsList.FetchGlobalValues.Response)
    func presentErrorForGlobalValues(baseCoin: CoinsFilterEnum)
    func presentListCoins(response: [CoinsList.FetchListCoins.Response])
    func presentError(error: MarketCoinsError)
}

class CoinsListPresenter: CoinsListPresentationLogic {
    
    weak var viewController: CoinsListDisplayLogic?
    
    func presentGlobalValues(response: CoinsList.FetchGlobalValues.Response) {
        var globalValues: [CoinsList.FetchGlobalValues.ViewModel.GlobalValues] = []
        
        for (_, value) in response.totalMarketCap {
            let mutableAttributedString = NSMutableAttributedString(string: "\(value.toCurrency(from: response.baseCoin)) ")
            
            let color = (response.changePercentage.sign == .minus) ? UIColor.systemRed : UIColor.systemGreen
            let attribute = [ NSAttributedString.Key.foregroundColor: color ]
            let attributedString = NSAttributedString(string: response.changePercentage.toPercentage(), attributes: attribute)
            
            mutableAttributedString.append(attributedString)
            
            globalValues.append(CoinsList.FetchGlobalValues.ViewModel.GlobalValues (title: "Capitalização de Mercado Global", values: mutableAttributedString))
        }
        
        for (_, value) in response.totalVolume {
            globalValues.append(CoinsList.FetchGlobalValues.ViewModel.GlobalValues (title: "Volume em 24h", values: NSMutableAttributedString(string: value.toCurrency(from: response.baseCoin))))
        }
        
        let viewModel = CoinsList.FetchGlobalValues.ViewModel(globalValues: globalValues)
        
        viewController?.displayGlobalValues(viewModel: viewModel)
        
    }
    
    func presentErrorForGlobalValues(baseCoin: CoinsFilterEnum) {
        let mutableAttributedString = NSMutableAttributedString(string: "\(0.0.toCurrency(from: baseCoin)) ")
        
        let attribute = [ NSAttributedString.Key.foregroundColor: UIColor.systemGreen ]
        let attributedString = NSAttributedString(string: 0.0.toPercentage(), attributes: attribute)
        
        mutableAttributedString.append(attributedString)
        
        let globalValues: [CoinsList.FetchGlobalValues.ViewModel.GlobalValues] = [
            CoinsList.FetchGlobalValues.ViewModel.GlobalValues (title: "Capitalização de Mercado Global", values: mutableAttributedString),
            CoinsList.FetchGlobalValues.ViewModel.GlobalValues (title: "Volume em 24h", values: NSMutableAttributedString(string: 0.0.toCurrency(from: baseCoin)))
        ]
        
        let viewModel = CoinsList.FetchGlobalValues.ViewModel(globalValues: globalValues)
        
        viewController?.displayGlobalValues(viewModel: viewModel)
    }
    
    func presentListCoins(response: [CoinsList.FetchListCoins.Response]) {
        let coins = response.map { response in
            var rank = "-"
            
            if let marketCapRank = response.marketCapRank {
                rank = "\(marketCapRank)"
            }
            
            let color = (response.priceChangePercentage.sign == .minus) ? UIColor.systemRed : UIColor.systemGreen
            let attribute = [ NSAttributedString.Key.foregroundColor: color ]
            let attributedString = NSAttributedString(string: response.priceChangePercentage.toPercentage(), attributes: attribute)
            
            return CoinsList.FetchListCoins.ViewModel.Coin(id: response.id,
                                                           name: response.name,
                                                           rank: rank,
                                                           iconUrl: response.image,
                                                           symbol: response.symbol.uppercased(),
                                                           price: response .currentPrice.toCurrency(from: response.baseCoin),
                                                           priceChangePercentage: attributedString,
                                                           marketCapitalization: response.marketCap.toCurrency(from: response.baseCoin))
        }
        
        let viewModel = CoinsList.FetchListCoins.ViewModel(coins: coins)
        
        viewController?.displayListCoins(viewModel: viewModel)
    }
    
    func presentError(error: MarketCoinsError) {
        viewController?.displayError(error: error.errorDescription)
    }
    
}
