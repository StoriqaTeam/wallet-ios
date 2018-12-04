//
//  BlockchainExplorerLinkHandler.swift
//  Wallet
//
//  Created by Storiqa on 04/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation


enum BlockchainExplorer: String {
    case Blockcypher
    case Etherscan
}


protocol BlockchainExplorerLinkGeneratorProtocol {
    func getLink(explorer: BlockchainExplorer, transactionHash: String) -> URL?
}


class BlockchainExplorerLinkGenerator: BlockchainExplorerLinkGeneratorProtocol {
    
    #if DEBUG
        let ETHERSCAN = "https://kovan.etherscan.io/tx/"
        let BLOCKCYPHER = "https://live.blockcypher.com/btc-testnet/tx/"
    #else
        let ETHERSCAN = "https://etherscan.io/tx/"
        let BLOCKCYPHER = "https://live.blockcypher.com/btc/tx/"
    #endif
    

    func getLink(explorer: BlockchainExplorer, transactionHash: String) -> URL? {
        let urlString = explorer == .Blockcypher ? BLOCKCYPHER+transactionHash : ETHERSCAN+transactionHash
        return URL(string: urlString)
    }
}
