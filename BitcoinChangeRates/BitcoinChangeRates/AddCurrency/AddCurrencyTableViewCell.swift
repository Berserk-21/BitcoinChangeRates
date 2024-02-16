//
//  AddCurrencyTableViewCell.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import UIKit

final class AddCurrencyTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    static let identifier: String = Constants.CellIdentifiers.addCurrencyTableViewCell
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        titleLabel.textColor = UIColor.secondaryLabel
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    }
    
    // MARK: - Custom Methods
    
    func configure(at indexPath: IndexPath, with model: [ChangeRatesModel]) {
        
        guard indexPath.row < model.count else { return }
        
        let model = model[indexPath.row]
        
        flagImageView.image = UIImage(named: model.isocode.uppercased())
        titleLabel.text = model.isocode.uppercased()
        subtitleLabel.text = model.name
        
        accessoryType = model.isSelected ? .checkmark : .none
    }
    
}
