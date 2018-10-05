//
//  TransactionsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsViewController: UIViewController {

    var output: TransactionsViewOutput!

    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.transactionTableView(transactionsTableView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        output.willMoveToParentVC()
    }
    
    
    // MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UISegmentedControl) {
        output.didChooseSegment(at: sender.selectedSegmentIndex)
    }
}


// MARK: - TransactionsViewInput

extension TransactionsViewController: TransactionsViewInput {
    
    func setupInitialState() {
        configureTableView()
        configiureSegmentControl()
    }

}


// MARK: Private methods

extension TransactionsViewController {
    private func configureTableView() {
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        transactionsTableView.tableFooterView = UIView()
    }
    
    private func configiureSegmentControl() {
        let normalTextAttributes = [NSAttributedString.Key.font: Theme.Font.segmentTextFont,
                                    NSAttributedString.Key.foregroundColor: Theme.Color.greyText]
        let selectedtextAttributes = [NSAttributedString.Key.font: Theme.Font.segmentTextFont,
                                      NSAttributedString.Key.foregroundColor: Theme.Color.brightSkyBlue]
        
        let backgroundImageSize = filterSegmentControl.bounds.size
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: backgroundImageSize)
        let dividerImageSize  = CGSize(width: 1.0, height: filterSegmentControl.bounds.size.height)
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: dividerImageSize)
        
        filterSegmentControl.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        filterSegmentControl.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        filterSegmentControl.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        filterSegmentControl.setDividerImage(deviderImage,
                                             forLeftSegmentState: .selected,
                                             rightSegmentState: .normal,
                                             barMetrics: .default)
        
        filterSegmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        filterSegmentControl.setTitleTextAttributes(selectedtextAttributes, for: .selected)
        filterSegmentControl.setWidth(60, forSegmentAt: 0)
        filterSegmentControl.setWidth(90, forSegmentAt: 1)
        filterSegmentControl.setWidth(90, forSegmentAt: 2)
    }
    
}
