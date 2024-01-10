//
//  AddCurrencyTableViewCell.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = Constants.CellIdentifiers.addCurrencyTableViewCell
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        
    }
    
    // MARK: - Custom Methods
    
    func configure(at indexPath: IndexPath, with model: [ChangeRatesModel]) {
        
        textLabel?.text = model[indexPath.row].isocode
    }
    
}
