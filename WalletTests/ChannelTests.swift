//
//  ChannelTests.swift
//  WalletTests
//
//  Created by Daniil Miroshnichecko on 28/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

fileprivate struct FakeSignalData {
    let propertyString: String
    let propertyInt: Int
}

fileprivate class FakeChannelStorage {
    let fakeChannel: Channel<[FakeSignalData]> = Channel<[FakeSignalData]>(queue: .main)
}

fileprivate class FakePoster {
    private var fakeChannelOutput: Channel<[FakeSignalData]>?

    // MARK: Channel
    func setFakeChannelOutput(_ channel: Channel<[FakeSignalData]>) {
        self.fakeChannelOutput = channel
    }

    func postToChannel() {
        let signalData_1 = FakeSignalData(propertyString: "First", propertyInt: 1)
        let signalData_2 = FakeSignalData(propertyString: "Second", propertyInt: 2)
        let signalDataArray = [signalData_1, signalData_2]
        fakeChannelOutput?.send(signalDataArray)
    }
}

fileprivate class FakeListner {
    private var fakeChannelInput: Channel<[FakeSignalData]>?
    
    var expectation = XCTestExpectation()

    deinit {
        self.fakeChannelInput?.removeObserver(withId: self.objId)
        self.fakeChannelInput = nil
    }


    // MARK: Channels
    private lazy var objId: String = {
        let id = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return id
    }()

    func setFakeChannelInput(_ channel: Channel<[FakeSignalData]>) {
        self.fakeChannelInput = channel
        let observer = Observer<[FakeSignalData]>(id: self.objId) { [weak self] (signalData) in
            self?.handleDataFromChannel(signalData)
        }
        self.fakeChannelInput?.addObserver(observer)
    }

    private func handleDataFromChannel(_ signalData: [FakeSignalData]) {
        XCTAssert(signalData.count == 2)
        XCTAssert(signalData[0].propertyInt == 1)
        XCTAssert(signalData[0].propertyString == "First")
        XCTAssert(signalData[1].propertyInt == 2)
        XCTAssert(signalData[1].propertyString == "Second")
        
        expectation.fulfill()
    }
}


class ChannelTests: XCTestCase {

    fileprivate let fakeChannelStorage = FakeChannelStorage()
    fileprivate let fakePoster = FakePoster()
    fileprivate let fakeListner = FakeListner()


    override func setUp() {
        fakePoster.setFakeChannelOutput(fakeChannelStorage.fakeChannel)
        fakeListner.setFakeChannelInput(fakeChannelStorage.fakeChannel)
    }

    func testChannels() {
        fakePoster.postToChannel()
        
        let date = Date()
        wait(for: [fakeListner.expectation], timeout: 1)
        let distance = date.timeIntervalSinceNow
        log.debug("waited: \(distance * -1) seconds")
        
    }

}
