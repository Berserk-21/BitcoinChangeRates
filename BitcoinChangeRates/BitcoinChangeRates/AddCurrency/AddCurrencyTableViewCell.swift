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
    @IBOutlet weak private var isocodeLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    
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
    
    func configure(at indexPath: IndexPath, with model: [CurrencyModel]) {
        
        let model = model[indexPath.row]
        
        flagImageView.image = UIImage(named: model.isocode.uppercased())
        isocodeLabel.text = model.isocode
        nameLabel.text = model.name
    }
    
}
