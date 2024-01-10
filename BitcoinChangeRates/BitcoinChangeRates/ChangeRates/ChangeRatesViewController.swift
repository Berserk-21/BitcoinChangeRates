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
        setupLeftBarButton()
    }
    
    private func setupHeaderView() {
        
        bitcoinAmountLabel.font = UIFont.systemFont(ofSize: 64.0, weight: .medium)
        bitcoinAmountLabel.textColor = .black
        
        bitcoinSymbolLabel.font = UIFont.systemFont(ofSize: 48.0, weight: .medium)
        bitcoinSymbolLabel.textColor = .orange
    }
    
    private func setupLeftBarButton() {
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddCurrency))
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    // MARK: - Custom Methods
    
    private func fetchData() {
        
        changeRateViewModel = ChangeRatesViewModel(bundleService: BundleService(), networkService: NetworkService())
        
        changeRateViewModel?.fetchData(completionHandler: { [weak self] result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                // Afficher un layout d'erreur/reload
                break
            }
        })
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddCurrency() {
        
        performSegue(withIdentifier: Constants.SegueIdentifiers.fromChangeRatesToAddCurrency, sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Constants.SegueIdentifiers.fromChangeRatesToAddCurrency:
            if let navigationController = segue.destination as? UINavigationController, let addCurrencyVC = navigationController.topViewController as? AddCurrencyViewController {
                addCurrencyVC.viewModel = self.changeRateViewModel
            }
        default:
            break
        }
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangeRatesTableViewCell.identifier, for: indexPath) as? ChangeRatesTableViewCell else { return UITableViewCell() }
        
        if let model = changeRateViewModel?.changeRates[indexPath.row] {
            cell.configureCell(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return changeRateViewModel?.changeRates.count ?? 0
    }
}
