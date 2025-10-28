//
//  SelectedServerView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit

class SelectedServer: UIView
{
    private let flagImageView = UIImageView()
    private let cityStateLabel = UILabel()
    private let crownImageView = UIImageView()
    private let chevronImageView = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI()
    {
        backgroundColor = DesignSystem.AppColors.Themes.CardView.cardBackgroundColor
        layer.cornerRadius = 10
        layer.shadowColor = (DesignSystem.AppColors.Themes.CardView.shadowColor ?? UIColor.black).cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        
        addSubview(flagImageView)
        addSubview(cityStateLabel)
        addSubview(crownImageView)
        addSubview(chevronImageView)
        
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .semibold)
        chevronImageView.image = UIImage(systemName: "chevron.up", withConfiguration: config)
        chevronImageView.tintColor = DesignSystem.AppColors.Themes.primaryColor
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        // Add subtle pulse animation (more visible)
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 1.2
        pulse.fromValue = 1.0
        pulse.toValue = 1.25
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        chevronImageView.layer.add(pulse, forKey: "pulse")
    }

    private func setupConstraints()
    {
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            flagImageView.widthAnchor.constraint(equalToConstant: 28),
            flagImageView.heightAnchor.constraint(equalToConstant: 28),
            
            cityStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityStateLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 16),
            cityStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: crownImageView.leadingAnchor, constant: -16),
            
            crownImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            crownImageView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            crownImageView.widthAnchor.constraint(equalToConstant: 18),
            crownImageView.heightAnchor.constraint(equalToConstant: 18),
            
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

        // Make flag circular after setting up constraints
        flagImageView.layer.cornerRadius = 14
        flagImageView.clipsToBounds = true
    }

    func configure(flag: UIImage?, city: String, state: String?, total: Int, current: Int, showCrown: Bool)
    {
        flagImageView.image = flag
        cityStateLabel.text = state?.isEmpty == false ? "\(city), \(state!)" : city
        crownImageView.isHidden = !showCrown
    
    }
}


