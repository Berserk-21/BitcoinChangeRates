//
//  AddCurrencyViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyViewController: UIViewController {
    
    // MARK: - Properties
    
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
}
