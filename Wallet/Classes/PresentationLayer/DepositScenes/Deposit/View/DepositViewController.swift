//
//  DepositViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositViewController: UIViewController {

    var output: DepositViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var addressTitleLabel: UILabel!
    @IBOutlet private var qrCodeTitleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var qrCodeImageView: UIImageView!
    @IBOutlet private var copyButton: UIButton!
    @IBOutlet private var shareButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: IBActions
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        output.copyButtonPressed()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        output.shareButtonPressed()
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
        
        addressTitleLabel.font = Theme.Font.caption
        qrCodeTitleLabel.font = Theme.Font.caption
        addressLabel.font = Theme.Font.generalText
        
        addressTitleLabel.textColor = Theme.Text.Color.captionGrey
        qrCodeTitleLabel.textColor = Theme.Text.Color.captionGrey
        
        copyButton.titleLabel?.font = Theme.Font.smallText
        copyButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
        shareButton.titleLabel?.font = Theme.Font.smallText
        shareButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
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
