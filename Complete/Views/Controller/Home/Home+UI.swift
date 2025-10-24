//
//  Home+UI.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/24/25.
//

import UIKit

//MARK: - UIComponents
extension HomeViewController
{
    static func createGridButton() -> UIButton
    {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "square.grid.2x2", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        
        // Background + border styling
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        button.layer.borderWidth = 1
        
        // Subtle drop shadow for depth
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.08
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func createPremiumButton() -> UIButton {
        let button = UIButton(type: .system)
        
        // Text setup
        button.setTitle(DesignSystem.L10n.goPremiumKey, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Background color (orange primary)
        button.backgroundColor = DesignSystem.AppColors.Themes.primaryColor
        
        // Corner radius & shadow
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        // Add image to left side of text
        let icon = UIImage(named: "crown")?.withRenderingMode(.alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        
        // Spacing and padding adjustments using UIButton.Configuration API
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        button.configuration = configuration
        
        // Rounded rect style matches Figma proportions
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 174).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }
    
    static func createDownloadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: DesignSystem.configuration.groupName)
        let downloadBytes = defaults?.double(forKey: "downloadSpeed") ?? 0
        let isConnected = defaults?.bool(forKey: "isConnected") ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title:DesignSystem.L10n.downloadKey , value: downloadBytes.description, unit: "mb/s", iconName: "arrow.down.circle.fill")
        card.update(speed: downloadBytes, state: state)
        return card
    }
    
    static func createUploadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: DesignSystem.configuration.groupName)
        let uploadBytes = defaults?.double(forKey: "uploadSpeed") ?? 0
        let isConnected = defaults?.bool(forKey: "isConnected") ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title: DesignSystem.L10n.uploadKey, value: uploadBytes.description, unit: "mb/s", iconName: "arrow.down.circle.fill")
        card.update(speed: uploadBytes, state: state)
        return card
    }
}

//MARK: - Construct User Interface
extension HomeViewController
{
    func hideNavigationBar()
    {
        NavigationManager.shared.toggleNavigationBar(on: navigationController, animated: false, shouldShow: false)
    }
    
    func setBackgroundColor()
    {
        view.backgroundColor = DesignSystem.AppColors.backgroundcolor
    }
    
    func constructUserInterface()
    {
        // Add subviews
        view.addSubview(gridButton)
        view.addSubview(premiumButton)
        view.addSubview(downloadCard)
        view.addSubview(uploadCard)
        view.addSubview(selectedServerView)

        // Ensure translatesAutoresizingMaskIntoConstraints is false for all
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        premiumButton.translatesAutoresizingMaskIntoConstraints = false
        downloadCard.translatesAutoresizingMaskIntoConstraints = false
        uploadCard.translatesAutoresizingMaskIntoConstraints = false
        selectedServerView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        
        // Top row: gridButton left, premiumButton right
        NSLayoutConstraint.activate([
            gridButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gridButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            premiumButton.centerYAnchor.constraint(equalTo: gridButton.centerYAnchor),
            premiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            premiumButton.heightAnchor.constraint(equalToConstant: 48),
            premiumButton.widthAnchor.constraint(equalToConstant: 174)
        ])
        
        // Middle row: downloadCard and uploadCard side by side, placed below gridButton with spacing
        NSLayoutConstraint.activate([
            downloadCard.topAnchor.constraint(equalTo: gridButton.bottomAnchor, constant: 40),
            downloadCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadCard.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            downloadCard.heightAnchor.constraint(equalToConstant: 80),
            
            uploadCard.topAnchor.constraint(equalTo: gridButton.bottomAnchor, constant: 40),
            uploadCard.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            uploadCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uploadCard.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Add selectedServerCell.cardView to hierarchy and constrain it to the bottom safe area, with left/right padding 20 and height ~80
        NSLayoutConstraint.activate([
            selectedServerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedServerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectedServerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectedServerView.heightAnchor.constraint(equalToConstant: 55)
        ])

        // Add tap gesture recognizer to cardView
        let tap = UITapGestureRecognizer(target: self, action: #selector(serverViewTapped))
        selectedServerView.addGestureRecognizer(tap)
    }
}
