//
//  AddCurrencyViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Properties
    
    var viewModel: ChangeRatesViewModel?
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        setupNavBar()
        setupSearchBar()
    }
    
    private func setupNavBar() {
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSearchBar() {
        
        searchBar.placeholder = "Search a currency.."
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancel() {
        
        dismiss(animated: true)
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyTableViewCell.identifier, for: indexPath) as? AddCurrencyTableViewCell else { return UITableViewCell() }
        
        if let changeRates = viewModel?.currencies {
            cell.configure(at: indexPath, with: changeRates)
        }
        
        return cell
    }
}
