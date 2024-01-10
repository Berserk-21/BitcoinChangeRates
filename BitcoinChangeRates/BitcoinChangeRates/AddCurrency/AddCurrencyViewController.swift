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
    
    private var shouldFetchData: Bool = false
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sendNotificationIfNeeded()
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
    
    private func sendNotificationIfNeeded() {
        
        if shouldFetchData {
            NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.shouldFetchData), object: nil)
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
        
        guard let item = viewModel?.allCurrencies?[indexPath.row] else { return }
        
        updateUserDefaults(for: item)

        viewModel?.allCurrencies?[indexPath.row].isSelected.toggle()
        
        reloadRow(at: indexPath)
        
        shouldFetchData = true
    }
    
    private func updateUserDefaults(for item: CurrencyModel) {
        
        if var userCurrencies = userDefaults.object(forKey: Constants.UserDefaults.selectedCurrencies) as? [String] {
            
            let isocode = item.isocode
            
            if item.isSelected {
                userCurrencies.removeAll(where: { $0 == isocode })
            } else {
                userCurrencies.append(isocode)
            }
            
            userDefaults.setValue(userCurrencies, forKey: Constants.UserDefaults.selectedCurrencies)
        }
        
    }
}
