//
//  TransactionsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Transactions

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
    
    
    // MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UISegmentedControl) {
        output.didChooseSegment(at: sender.selectedSegmentIndex)
    }
    
    
    @objc func filterByDateTapped() {
        output.filterByDateTapped()
    }
}


// MARK: - TransactionsViewInput

extension TransactionsViewController: TransactionsViewInput {
    
    func setupInitialState() {
        configureTableView()
        configiureSegmentControl()
        addFilterButton()
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
                                    NSAttributedString.Key.foregroundColor: Theme.Text.Color.grey]
        let selectedtextAttributes = [NSAttributedString.Key.font: Theme.Font.segmentTextFont,
                                      NSAttributedString.Key.foregroundColor: Theme.Color.brightSkyBlue]
        
        let backgroundImageSize = filterSegmentControl.bounds.size
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: backgroundImageSize)
        let dividerImageSize  = CGSize(width: 1.0, height: filterSegmentControl.bounds.size.height)
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: dividerImageSize)
        
        filterSegmentControl.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        filterSegmentControl.setDividerImage(deviderImage,
                                             forLeftSegmentState: .selected,
                                             rightSegmentState: .normal,
                                             barMetrics: .default)
        
        filterSegmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        filterSegmentControl.setTitleTextAttributes(selectedtextAttributes, for: .selected)
        filterSegmentControl.setWidth(40, forSegmentAt: 0)
        filterSegmentControl.setWidth(90, forSegmentAt: 1)
        filterSegmentControl.setWidth(90, forSegmentAt: 2)
        filterSegmentControl.setTitle(LocalizedStrings.allButton, forSegmentAt: 0)
        filterSegmentControl.setTitle(LocalizedStrings.sentButton, forSegmentAt: 1)
        filterSegmentControl.setTitle(LocalizedStrings.receivedButton, forSegmentAt: 2)
    }
    
    private func addFilterButton() {
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filterButton.addTarget(self, action: #selector(self.filterByDateTapped), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
}
