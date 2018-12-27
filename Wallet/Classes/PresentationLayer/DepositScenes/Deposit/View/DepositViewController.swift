//
//  DepositViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Deposit

    var output: DepositViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var addressTitleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var qrCodeImageView: UIImageView!
    @IBOutlet private var copyButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var shareDescriptionLabel: UILabel!
    @IBOutlet private var shareTapView: UIView!
    
    @IBOutlet private var addressContainerView: UIView!
    @IBOutlet private var qrCodeContainerView: UIView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        localizeText()
        output.accountsCollectionView(accountsCollectionView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.configureCollections()
        output.viewWillAppear()
        setNavBarTransparency()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        output.configureCollections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisapear()
    }

    // MARK: IBActions
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        output.copyButtonPressed()
    }
    
    @IBAction func shareLongPressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            shareTapView.backgroundColor = Theme.Color.Text.lightGrey
            shareTapView.alpha = 0.3
        default:
            shareTapView.backgroundColor = .clear
            output.shareButtonPressed()
        }
    }
}


// MARK: - DepositViewInput

extension DepositViewController: DepositViewInput {
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }
    
    func setAddress(_ address: String) {
        UIView.transition(with: addressLabel,
                          duration: 0.25,
                          options: [.transitionCrossDissolve, .beginFromCurrentState],
                          animations: { [weak self] in
                            self?.addressLabel.text = address
            }, completion: nil)
    }
    
    func setQrCode(_ qrCode: UIImage) {
        UIView.transition(with: qrCodeImageView,
                          duration: 0.25,
                          options: [.transitionCrossDissolve, .beginFromCurrentState],
                          animations: { [weak self] in
                            self?.qrCodeImageView.image = qrCode
            }, completion: nil)
    }
    
    func setupInitialState(numberOfPages: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
    }

}


// MARK: - UIScrollViewDelegate

extension DepositViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavBarTransparency()
    }
}


// MARK: - Private methods

extension DepositViewController {
    
    private func configureInterface() {
        scrollView.delegate = self
        
        view.backgroundColor = Theme.Color.backgroundColor
        scrollView.backgroundColor = Theme.Color.backgroundColor
        addressContainerView.backgroundColor = Theme.Color.backgroundColor
        
        addressTitleLabel.font = Theme.Font.smallMediumWeightText
        addressTitleLabel.textColor = Theme.Color.Text.lightGrey
    
        
        addressLabel.font = Theme.Font.input
        addressLabel.tintColor = .white
        
        copyButton.setImage(UIImage(named: "copyIcon"), for: .normal)
        copyButton.tintColor = Theme.Color.opaqueWhite
        copyButton.titleLabel?.font = Theme.Font.smallText
        
        shareDescriptionLabel.font = Theme.Font.smallMediumWeightText
        shareDescriptionLabel.tintColor = Theme.Color.Text.lightGrey
        
        qrCodeContainerView.roundCorners(radius: 9)
    }
    
    private func localizeText() {
        addressTitleLabel.text = LocalizedStrings.addressTitle
        shareDescriptionLabel.text = LocalizedStrings.shareButton
    }
    
    private func setNavBarTransparency() {
        if let cellY = accountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
}
