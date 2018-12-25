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

    @IBOutlet weak var directionFilterView: DirectionFilterView!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.transactionTableView(transactionsTableView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
        directionFilterView.setInitialFilter(position: .all)
    }

    @objc func filterByDateTapped() {
        output.filterByDateTapped()
    }
}


// MARK: - TransactionsViewInput

extension TransactionsViewController: TransactionsViewInput {
    
    func setupInitialState() {
        setDelegates()
        configureAppearence()
        configureTableView()
        addFilterButton()
    }
}


// MARK: - DirectionFilterDelegate

extension TransactionsViewController: DirectionFilterDelegate {
    func didSet(positionIndex: Int) {
        output.didChooseSegment(at: positionIndex)
    }
}


// MARK: Private methods

extension TransactionsViewController {
    private func configureTableView() {
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        transactionsTableView.tableFooterView = UIView()
    }
    
    private func setDelegates() {
        directionFilterView.delegate = self
    }
    
    private func addFilterButton() {
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filterButton.addTarget(self, action: #selector(self.filterByDateTapped), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    private func configureAppearence() {
        view.backgroundColor = Theme.Color.backgroundColor
        transactionsTableView.backgroundColor = Theme.Color.backgroundColor
    }
    
}
