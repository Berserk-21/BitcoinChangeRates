//
//  LoadingView.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 11/01/2024.
//

import UIKit

final class LoadingView: UIView {
    
    // MARK: - Properties
    
    private let stackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private let errorLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let buttonContainerView = {
        let v = UIView()
        v.backgroundColor = .orange
        return v
    }()
    
    let refreshButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: Constants.URLRequest.reloadText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0, weight: .semibold)]), for: .normal)
        return button
    }()
    
    // MARK: - Life Cyclme
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        buttonContainerView.addSubview(refreshButton)
        buttonContainerView.layer.masksToBounds = true
        buttonContainerView.layer.cornerRadius = 4.0
        buttonContainerView.backgroundColor = .orange
        
        let refreshButtonConstraints = [
            refreshButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 8.0),
            refreshButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0),
            refreshButton.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor, constant: -8.0),
            refreshButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: 0),
        ]
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.tintColor = .orange
        
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(buttonContainerView)
        stackView.addArrangedSubview(errorLabel)
        
        addSubview(stackView)
        stackView.alignment = .center
        stackView.spacing = 12
        
        let centerXConstraint = stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerYConstraint = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leadingConstraint = stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 16.0)
        let trailingConstraint = stackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16.0)
        
        NSLayoutConstraint.activate(refreshButtonConstraints + [centerXConstraint, centerYConstraint, leadingConstraint, trailingConstraint])
    }
    
    // MARK: - Custom Methods
    
    /// Hides the loadingView and stop animating the activityIndicator.
    func hideLoadingLayout() {
        
        isHidden = true
        isUserInteractionEnabled = false
        activityIndicator.stopAnimating()
    }
    
    /// Displays the loadingView and start animating the activityIndicator.
    func displayLoadingLayout() {
        
        isHidden = false
        isUserInteractionEnabled = true
        
        activityIndicator.startAnimating()

        buttonContainerView.isHidden = true
        errorLabel.text = Constants.URLRequest.loadingText
    }
    
    /// Displays the loadingView with a reload button and present the error reason.
    func displayErrorLayout(with error: Error) {
        
        var errorText = Constants.URLRequest.requestTimedOut
        
        let err = error as NSError
        
        switch err.code {
        case 4865:
            // API limit exceeded, wait 60sec.
            errorText = Constants.URLRequest.exceeded60secLimit
        default:
            #if DEBUG
            DebugLogService.log(err)
            #endif
            break
        }
                
        isHidden = false
        isUserInteractionEnabled = true

        activityIndicator.stopAnimating()
        buttonContainerView.isHidden = false
        errorLabel.text = errorText
    }
}
