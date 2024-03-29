//
//  ChangeRatesViewController.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import UIKit

final class ChangeRatesViewController: UIViewController, UITableViewDataSource {
    
    var changeRatesViewModel: ChangeRatesViewModel?
    
    // MARK: - Properties
    
    @IBOutlet weak private var bitcoinAmountLabel: UILabel!
    @IBOutlet weak private var bitcoinSymbolLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loadingView: LoadingView!
    @IBOutlet weak private var headerBottomSeparatorView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupLoadingView()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeNotifications()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        title = Constants.ChangeRates.title
        
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        
        bitcoinAmountLabel.font = UIFont.systemFont(ofSize: 64.0, weight: .medium)
        bitcoinAmountLabel.textColor = UIColor.label
        
        bitcoinSymbolLabel.font = UIFont.systemFont(ofSize: 48.0, weight: .medium)
        bitcoinSymbolLabel.textColor = .orange
        
        headerBottomSeparatorView.backgroundColor = tableView.separatorColor
    }
    
    private func updateLoadingLayout(isLoading: Bool, error: Error? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            
            if let err = error {
                self?.loadingView.displayErrorLayout(with: err)
                self?.tableView.isHidden = true
            } else if isLoading {
                self?.loadingView.displayLoadingLayout()
                self?.tableView.isHidden = true
            } else {
                self?.loadingView.hideLoadingLayout()
                self?.tableView.isHidden = false
            }
        }
    }
    
    // MARK: - Custom Methods
    
    private func setupLoadingView() {
        
        loadingView.refreshButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
    }
    
    private func subscribeNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(Constants.Notifications.shouldFetchData), object: nil)
    }
    
    @objc private func fetchData() {
        
        if changeRatesViewModel == nil {
            changeRatesViewModel = ChangeRatesViewModel(bundleService: BundleService(), networkService: NetworkService())
        }
        
        updateLoadingLayout(isLoading: true)
        
        changeRatesViewModel?.fetchData(completionHandler: { [weak self] result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.updateLoadingLayout(isLoading: false)
                }
            case .failure(let error):
                // Afficher un layout d'erreur/reload
                DispatchQueue.main.async {
                    self?.updateLoadingLayout(isLoading: false, error: error)
                }
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapAddCurrency() {
        
        performSegue(withIdentifier: Constants.SegueIdentifiers.fromChangeRatesToAddCurrency, sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Constants.SegueIdentifiers.fromChangeRatesToAddCurrency:
            if let navigationController = segue.destination as? UINavigationController, let addCurrencyVC = navigationController.topViewController as? AddCurrencyViewController {
                addCurrencyVC.viewModel = self.changeRatesViewModel
            }
        default:
            break
        }
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangeRatesTableViewCell.identifier, for: indexPath) as? ChangeRatesTableViewCell else { return UITableViewCell() }
        
        guard indexPath.row < changeRatesViewModel?.selectedChangeRates.count ?? 0 else {
            #if DEBUG
            DebugLogService.log("changeRates index out of range")
            #endif
            return UITableViewCell() }
        
        if let model = changeRatesViewModel?.selectedChangeRates[indexPath.row] {
            cell.configureCell(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return changeRatesViewModel?.selectedChangeRates.count ?? 0
    }
}
