//
//  ChangeRatesTableViewCell.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import UIKit

final class ChangeRatesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "ChangeRatesTableViewCell"
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
    
    // MARK: - Custom Methods
    
    func configureCell(at indexPath: IndexPath, model: ChangeRatesSubModel) {
        
        textLabel?.text = model.isocode.uppercased()
    }
}
