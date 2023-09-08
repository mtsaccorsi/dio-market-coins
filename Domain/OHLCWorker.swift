//
//  OHLCWorker.swift
//  MarketCoins
//
//  Created by Matheus Accorsi on 02/09/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class OHLCWorker {
    
    private let dataProvider: OHLCDataProvider?
    private var completion: ((Result<[GraphicDataModel]?, MarketCoinsError>) -> Void)?
    
    init(dataProvider: OHLCDataProvider = OHLCDataProvider()) {
        self.dataProvider = dataProvider
        self.dataProvider?.delegate = self
    }
    
    func doFetchMarketChart(id: String,
                            baseCoin: String,
                            of: String,
                            completion: @escaping ((Result<[GraphicDataModel]?, MarketCoinsError>) -> Void)) {
        dataProvider?.fetchOhlc(by: id, currency: baseCoin, of: of)
        self.completion = completion
    }
}

extension OHLCWorker: OHLCDataProviderDelegate {
    
    func success(model: Any) {
        guard let completion = completion else {
            fatalError("Completion not implemented!")
        }
        completion(.success(model as? [GraphicDataModel]))
    }
    
    func errorData(_ provider: GenericDataProviderDelegate?, error: Error) {
        guard let completion = completion else {
            fatalError("Completion not implemented!")
        }
        
        if error.errorCode == 500 {
            completion(.failure(.internalServerError))
        } else if error.errorCode == 400 {
            completion(.failure(.badRequestError))
        } else if error.errorCode == 404 {
            completion(.failure(.notFoundError))
        } else {
            completion(.failure(.undefinedError))
        }
    }
}