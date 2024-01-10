//
//  AddCurrencyViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    // MARK: - Helper Methods
    
    private func reloadRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancel() {
        
        dismiss(animated: true)
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.allCurrencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyTableViewCell.identifier, for: indexPath) as? AddCurrencyTableViewCell else { return UITableViewCell() }
        
        if let model = viewModel?.allCurrencies {
            cell.configure(at: indexPath, with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.allCurrencies?[indexPath.row].isSelected.toggle()
        
        reloadRow(at: indexPath)
    }
}
