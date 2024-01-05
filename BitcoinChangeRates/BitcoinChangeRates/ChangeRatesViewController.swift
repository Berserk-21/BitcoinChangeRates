//
//  ChangeRatesViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import UIKit

final class ChangeRatesViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak private var bitcoinAmountLabel: UILabel!
    @IBOutlet weak private var bitcoinSymbolLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        
        bitcoinAmountLabel.font = UIFont.systemFont(ofSize: 64.0, weight: .medium)
        bitcoinAmountLabel.textColor = .black
        
        bitcoinSymbolLabel.font = UIFont.systemFont(ofSize: 48.0, weight: .medium)
        bitcoinSymbolLabel.textColor = .orange
    }
}
