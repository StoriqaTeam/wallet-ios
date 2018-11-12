//
//  PinSetupDataManager.swift
//  Wallet
//
//  Created by Storiqa on 12/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinSetupDataManagerDelegate: class {
    func pinSet(input: String)
}


class PinSetupDataManager: NSObject {
    
    weak var delegate: PinSetupDataManagerDelegate?
    private let kPinSetupCellIdentifier = "pinSetupCell"
    private var pinSetupCollectionView: UICollectionView!
    
    
    func setCollectionView(_ view: UICollectionView) {
        pinSetupCollectionView = view
        pinSetupCollectionView.dataSource = self
        pinSetupCollectionView.delegate = self
        pinSetupCollectionView.isScrollEnabled = false
        registerXib()
    }
    
    func scrollTo(state: PinSetupStep) {
        let row: Int
        switch state {
        case .setPin:
            row = 0
            
        case .confirmPin: row = 1
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        pinSetupCollectionView.scrollToItem(at: indexPath,
                                            at: .left,
                                            animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension PinSetupDataManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPinSetupCellIdentifier, for: indexPath)
        guard let pinSetupCell = cell as? PinSetupCollectionViewCell else { fatalError("Fail to create PinInputCell") }
        pinSetupCell.delegate = self
        return pinSetupCell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PinSetupDataManager: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let pinInputCell = cell as? PinSetupCollectionViewCell else  {
            fatalError("Fail to cast to PinSetupCollectionViewCell")
        }
        
        pinInputCell.clearInput()
    }
}


// MARK: - PinSetupCollectionViewCellDelegate

extension PinSetupDataManager: PinSetupCollectionViewCellDelegate {
    func pinSet(input: String) {
        delegate?.pinSet(input: input)
    }
}


// MARK: - Private methods

extension PinSetupDataManager {
    private func registerXib() {
        let nib = UINib(nibName: "PinSetupCell", bundle: nil)
        pinSetupCollectionView.register(nib, forCellWithReuseIdentifier: kPinSetupCellIdentifier)
    }
}
