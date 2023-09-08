//
//  CoinHeaderView.swift
//  MarketCoins
//
//  Created by Matheus Accorsi on 27/08/23.
//

import UIKit

class CoinHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "CoinHeaderView"

    @IBOutlet weak var priceChangePercentageLabel: UILabel!
    
    func setupPriceChangePercentage(from filter: Filter) {
        if filter.type == .priceChangePercentage {
            if let priceChangePercentageFilter = PriceChangePercentageFilterEnum(rawValue: filter.key) {
                priceChangePercentageLabel.text = priceChangePercentageFilter.title
            }
        }
    }

}
