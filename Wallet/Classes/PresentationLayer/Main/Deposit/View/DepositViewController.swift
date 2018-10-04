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
    @IBOutlet private var gradientView: UIView!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureCollections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradientView()
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
        
        addressTitleLabel.font = UIFont.caption
        qrCodeTitleLabel.font = UIFont.caption
        addressLabel.font = UIFont.generalText
        
        addressTitleLabel.textColor = Theme.Color.captionGrey
        qrCodeTitleLabel.textColor = Theme.Color.captionGrey
        
        copyButton.titleLabel?.font = UIFont.smallText
        copyButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
        shareButton.titleLabel?.font = UIFont.smallText
        shareButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
    }
    
    private func configureGradientView() {
        let height = accountsCollectionView.frame.height +
            accountsPageControl.frame.height +
            (navigationController?.navigationBar.frame.size.height ?? 44) +
            UIApplication.shared.statusBarFrame.height
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: gradientView.frame.width, height: height)
        gradientLayer.colors = [ UIColor(red: 0.2549019608, green: 0.7176470588, blue: 0.9568627451, alpha: 1).cgColor,
                                 UIColor(red: 0.1764705882, green: 0.3921568627, blue: 0.7607843137, alpha: 1).cgColor ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
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
