//
//  ChangeRatesTableViewCell.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import UIKit

final class ChangeRatesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = Constants.CellIdentifiers.changeRatesTableViewCell
    
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        titleLabel.textColor = .darkGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        valueLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    
    // MARK: - Custom Methods
    
    func configureCell(with model: ChangeRatesModel) {
        
        flagImageView.image = UIImage(named: model.isocode.uppercased())
        titleLabel.text = model.isocode.uppercased()
        subtitleLabel.text = model.name.capitalized
        
        if let string = NumberFormatterService.shared.getStringFor(model: model) {
            self.valueLabel.text = string
        }
    }
}
