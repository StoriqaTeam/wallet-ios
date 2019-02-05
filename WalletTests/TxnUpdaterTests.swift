//
//  TxnUpdaterTests.swift
//  WalletTests
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

import XCTest
@testable import Wallet


class TxnUpdaterTests: XCTestCase {
    private var updater: TransactionsUpdaterProtocol!
    private var dataStore: TransactionDataStoreService!
    private var provider: TransactionsProviderProtocol!
    private let defaults = FakeDefaultsProvider()
    private let networkProvider = FakeTransactionsNetworkProvider()
    private let authTokenProvider = FakeAuthTokenProvider()
    private let signHeaderFactory = FakeSignHeaderFactory()
    private let userDataStoreService = FakeUserDataStoreService()
    private let receivedTransactionProvider = FakeReceivedTransactionProvider()
    
    private let doneTxn: [Transaction] = {
        var result = [Transaction]()
        
        for i in 1...14 {
            let tx = Transaction(id: "\(i)",
                fromAddress: [""],
                fromAccount: [TransactionAccount](),
                toAddress: "",
                toAccount: nil,
                fromValue: Decimal(),
                fromCurrency: .stq,
                toValue: Decimal(),
                toCurrency: .stq,
                fee: Decimal(),
                blockchainIds: [""],
                createdAt: Date(timeIntervalSince1970: TimeInterval(i)),
                updatedAt: Date(timeIntervalSince1970: 0),
                status: .done,
                fiatValue: nil,
                fiatCurrency: nil)
            result.insert(tx, at: 0)
        }
        
        return result
    }()
    
    private let pendingTxn: [Transaction] = {
        var result = [Transaction]()
        
        for i in 1...14 {
            let status: TransactionStatus = i == 10 ? .pending : .done
            let tx = Transaction(id: "\(i)",
                fromAddress: [""],
                fromAccount: [TransactionAccount](),
                toAddress: "",
                toAccount: nil,
                fromValue: Decimal(),
                fromCurrency: .stq,
                toValue: Decimal(),
                toCurrency: .stq,
                fee: Decimal(),
                blockchainIds: [""],
                createdAt: Date(timeIntervalSince1970: TimeInterval(i)),
                updatedAt: Date(timeIntervalSince1970: 0),
                status: status,
                fiatValue: nil,
                fiatCurrency: nil)
            result.insert(tx, at: 0)
        }
        
        return result
    }()
    
    override func setUp() {
        super.setUp()
        
        let realmPath = NSTemporaryDirectory().appending("TxnUpdaterTests_realm")
        // Delete previous Realm file
        if FileManager.default.fileExists(atPath: realmPath) {
            try! FileManager.default.removeItem(atPath: realmPath)
        }
        
        dataStore = TransactionDataStoreService(forTests: URL(string: realmPath)!)
        dataStore.resetAllDatabase()
        networkProvider.txn = doneTxn
        
        provider = TransactionsProvider(transactionDataStoreService: dataStore)
        
        updater = TransactionsUpdater(
            transactionsProvider: provider,
            transactionsNetworkProvider: networkProvider,
            transactionsDataStoreService: dataStore,
            signHeaderFactory: signHeaderFactory,
            defaultsProvider: defaults,
            authTokenProvider: authTokenProvider,
            userDataStoreService: userDataStoreService,
            receivedTransactionProvider: receivedTransactionProvider,
            limit: 2)
        
    }
    
    override func tearDown() {
        dataStore.resetAllDatabase()
    }
    
    func testFirstLoad() {
        resetState()
        
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0,2,4,6,8,10,12,14])
        XCTAssertEqual(networkProvider.blocks.count, 8)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(networkProvider.blocks[1], ["12","11"])
        XCTAssertEqual(networkProvider.blocks[2], ["10","9"])
        XCTAssertEqual(networkProvider.blocks[3], ["8","7"])
        XCTAssertEqual(networkProvider.blocks[4], ["6","5"])
        XCTAssertEqual(networkProvider.blocks[5], ["4","3"])
        XCTAssertEqual(networkProvider.blocks[6], ["2","1"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        networkProvider.clear()
        
        // All txn already loaded
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0])
        XCTAssertEqual(networkProvider.blocks.count, 1)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        resetState()
        
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0,2,4,6,8,10,12,14])
        XCTAssertEqual(networkProvider.blocks.count, 8)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(networkProvider.blocks[1], ["12","11"])
        XCTAssertEqual(networkProvider.blocks[2], ["10","9"])
        XCTAssertEqual(networkProvider.blocks[3], ["8","7"])
        XCTAssertEqual(networkProvider.blocks[4], ["6","5"])
        XCTAssertEqual(networkProvider.blocks[5], ["4","3"])
        XCTAssertEqual(networkProvider.blocks[6], ["2","1"])
        XCTAssertEqual(networkProvider.blocks[7], [])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        
        resetState()
        updater = TransactionsUpdater(
            transactionsProvider: provider,
            transactionsNetworkProvider: networkProvider,
            transactionsDataStoreService: dataStore,
            signHeaderFactory: signHeaderFactory,
            defaultsProvider: defaults,
            authTokenProvider: authTokenProvider,
            userDataStoreService: userDataStoreService,
            receivedTransactionProvider: receivedTransactionProvider,
            limit: 3)
        
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0,3,6,9,12])
        XCTAssertEqual(networkProvider.blocks.count, 5)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13","12"])
        XCTAssertEqual(networkProvider.blocks[1], ["11","10", "9"])
        XCTAssertEqual(networkProvider.blocks[2], ["8","7","6"])
        XCTAssertEqual(networkProvider.blocks[3], ["5","4","3"])
        XCTAssertEqual(networkProvider.blocks[4], ["2","1"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        
        updater = TransactionsUpdater(
            transactionsProvider: provider,
            transactionsNetworkProvider: networkProvider,
            transactionsDataStoreService: dataStore,
            signHeaderFactory: signHeaderFactory,
            defaultsProvider: defaults,
            authTokenProvider: authTokenProvider,
            userDataStoreService: userDataStoreService,
            receivedTransactionProvider: receivedTransactionProvider,
            limit: 2)
    }
    
    func testLoadWithPending() {
        resetState()
        dataStore.save(pendingTxn)
        
        updater.update()
        //FIXME: test will fail, that's ok for now
        //tx updater is currently dealing with server bug
        //so we have one more block loaded then expected
        XCTAssertEqual(networkProvider.offsets, [0,2,4])
        XCTAssertEqual(networkProvider.blocks.count, 3)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(networkProvider.blocks[1], ["12","11"])
        XCTAssertEqual(networkProvider.blocks[2], ["10","9"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
    }
    
    func testLoadWithTimestamp() {
        resetState()
        dataStore.save(doneTxn)
        defaults.lastTxTimastamp = 8.0
        
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0,2,4,6])
        XCTAssertEqual(networkProvider.blocks.count, 4)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(networkProvider.blocks[1], ["12","11"])
        XCTAssertEqual(networkProvider.blocks[2], ["10","9"])
        XCTAssertEqual(networkProvider.blocks[3], ["8","7"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        
        
        resetState()
        dataStore.save(doneTxn)
        defaults.lastTxTimastamp = 13.0
        
        updater.update()
        //FIXME: test will fail, that's ok for now
        //tx updater is currently dealing with server bug
        //so we have one more block loaded then expected
        XCTAssertEqual(networkProvider.offsets, [0])
        XCTAssertEqual(networkProvider.blocks.count, 1)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
        
        resetState()
        dataStore.save(doneTxn)
        defaults.lastTxTimastamp = 3.0
        
        updater.update()
        //FIXME: test will fail, that's ok for now
        //tx updater is currently dealing with server bug
        //so we have one more block loaded then expected
        XCTAssertEqual(networkProvider.offsets, [0,2,4,6,8,10])
        XCTAssertEqual(networkProvider.blocks.count, 6)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(networkProvider.blocks[1], ["12","11"])
        XCTAssertEqual(networkProvider.blocks[2], ["10","9"])
        XCTAssertEqual(networkProvider.blocks[3], ["8","7"])
        XCTAssertEqual(networkProvider.blocks[4], ["6","5"])
        XCTAssertEqual(networkProvider.blocks[5], ["4","3"])
        XCTAssertNil(defaults.lastTxTimastamp)
        
        checkSaved()
    }
    
    func testLoadFailure() {
        resetState()
        dataStore.save(pendingTxn)
        networkProvider.failOnOffset = 2
        
        updater.update()
        XCTAssertEqual(networkProvider.offsets, [0,2])
        XCTAssertEqual(networkProvider.blocks.count, 1)
        XCTAssertEqual(networkProvider.blocks[0], ["14","13"])
        XCTAssertEqual(defaults.lastTxTimastamp, 9)
        
        let allTxn = provider.getAllTransactions().sorted { $0.createdAt > $1.createdAt }
        XCTAssertEqual(allTxn.count, pendingTxn.count)
        XCTAssertEqual(allTxn.map { $0.id }, pendingTxn.map { $0.id })
        XCTAssertEqual(allTxn.map { $0.status }, pendingTxn.map { $0.status })
    }
    
    
    private func resetState() {
        defaults.lastTxTimastamp = nil
        dataStore.resetAllDatabase()
        networkProvider.clear()
    }
    
    private func checkSaved() {
        let allTxn = provider.getAllTransactions().sorted { $0.createdAt > $1.createdAt }
        let loaded = networkProvider.txn
        XCTAssertEqual(allTxn.count, loaded.count)
        XCTAssertEqual(allTxn.map { $0.id }, loaded.map { $0.id })
        XCTAssertEqual(allTxn.map { $0.status }, loaded.map { $0.status })
    }
}


private class FakeDefaultsProvider: DefaultsProviderProtocol {
    var deviceId: String = ""
    var isFirstTransactionsLoad: Bool = false
    var isFirstLaunch: Bool = false
    var isQuickLaunchShown: Bool = false
    var isBiometryAuthEnabled: Bool = false
    var fiatISO: String = ""
    var lastTxTimastamp: TimeInterval? = nil
    var socialAuthProvider: SocialNetworkTokenProvider? = nil
    
    func clear() {}
}

private class FakeAuthTokenProvider: AuthTokenProviderProtocol {
    func currentAuthToken(completion: @escaping (Result<String>) -> Void) {
        completion(.success("authToken"))
    }
}

private class FakeTransactionsNetworkProvider: TransactionsNetworkProviderProtocol {

    var offsets = [Int]()
    var blocks = [[String]]()
    
    var txn = [Transaction]()
    var failOnOffset: Int?
    
    func getTransactions(authToken: String, userId: Int, offset: Int, limit: Int, queue: DispatchQueue, signHeader: SignHeader, completion: @escaping (Result<[Transaction]>) -> Void) {
        offsets.append(offset)
        
        if let failOnOffset = failOnOffset,
            offset == failOnOffset {
            completion(.failure(NetworkUnknownError()))
            return
        }
        
        let txn = Array(self.txn[offset..<min(self.txn.count, (offset + limit))])
        blocks.append(txn.map { $0.id } )
        completion(.success(txn))
    }
    
    func clear() {
        offsets.removeAll()
        blocks.removeAll()
    }
}

private class FakeSignHeaderFactory: SignHeaderFactoryProtocol {
    func createSignHeader(email: String) throws -> SignHeader {
        return SignHeader(deviceId: "", timestamp: "", signature: "", pubKeyHex: "")
    }
}

private class FakeUserDataStoreService: UserDataStoreServiceProtocol {
    func save(_ user: User) { }
    
    func update(_ user: User) { }
    
    func delete() { }
    
    func getCurrentUser() -> User {
        return User(id: 0, email: "", phone: "", firstName: "", lastName: "", photo: nil)
    }
    
    func resetAllDatabase() { }
    
}

private class FakeReceivedTransactionProvider: ReceivedTransactionProviderProtocol {
    func resolve(oldTxs: [Transaction], newTxs: [Transaction]) { }
    func setReceivedTxsChannel(_ channel: ReceivedTxsChannel) { }
}
