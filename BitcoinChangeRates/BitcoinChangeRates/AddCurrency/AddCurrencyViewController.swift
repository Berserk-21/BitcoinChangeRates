//
//  AddCurrencyViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var viewModel: ChangeRatesViewModel?
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sendNotificationIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        resetSearchFilter()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        title = Constants.AddCurrency.title
        
        setupNavBar()
        setupSearchBar()
    }
    
    private func setupNavBar() {
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSearchBar() {
        
        searchBar.placeholder = Constants.AddCurrency.searchBar_placeholder
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
    }
    
    // MARK: - Helper Methods
    
    private func reloadRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func sendNotificationIfNeeded() {
        
        if let shouldFetchData = viewModel?.shouldFetchData, shouldFetchData {
            NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.shouldFetchData), object: nil)
        }
    }
    
    private func resetSearchFilter() {
        
        viewModel?.searchTextDidChange(with: "")
    }
    
    // MARK: - Actions
    
    @objc private func didTapDone() {
        
        dismiss(animated: true)
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.getChangeRates().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyTableViewCell.identifier, for: indexPath) as? AddCurrencyTableViewCell else { return UITableViewCell() }
        
        if let model = viewModel?.getChangeRates() {
            cell.configure(at: indexPath, with: model)
        }
        
        return cell
    }
    
    // MARK: - UITalbleView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.didSelectRowAt(indexPath: indexPath)
        
        reloadRow(at: indexPath)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel?.searchTextDidChange(with: searchText)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
