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
        
    }
    
    // MARK: - Custom Methods
    
    func configureCell(with model: ChangeRatesSubModel) {
        
        flagImageView.image = UIImage(named: model.isocode.uppercased())
        titleLabel.text = model.isocode.uppercased()
        subtitleLabel.text = model.name.capitalized
        
        if let changeRate = model.changeRate {
            self.valueLabel.text = "\(changeRate)"
        }
    }
}
