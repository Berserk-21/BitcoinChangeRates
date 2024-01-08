//
//  ChangeRatesViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import UIKit

final class ChangeRatesViewController: UIViewController, UITableViewDataSource {
    
    var changeRateViewModel: ChangeRatesViewModel?
    
    // MARK: - Properties
    
    @IBOutlet weak private var bitcoinAmountLabel: UILabel!
    @IBOutlet weak private var bitcoinSymbolLabel: UILabel!
    
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        fetchData()
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
    
    // MARK: - Custom Methods
    
    private func fetchData() {
        
        changeRateViewModel = ChangeRatesViewModel()
        
        changeRateViewModel?.fetchData(completionHandler: { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                // Afficher un layout d'erreur/reload
            }
        })
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangeRatesTableViewCell.identifier, for: indexPath) as? ChangeRatesTableViewCell else { return UITableViewCell() }
        
        if let model = changeRateViewModel?.finalRates[indexPath.row] {
            cell.configureCell(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return changeRateViewModel?.finalRates.count ?? 0
    }
}
