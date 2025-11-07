//
//  ConnectionStatusView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/30/25.
//

import UIKit

final class ConnectionStatusView: UIView
{
    private let statusLabel = UILabel()
    private let timerLabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView()
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.text = AppDesign.Text.disconnectedKey //Default Text
        statusLabel.textColor = .label
        statusLabel.font = AppDesign.Fonts.semiBold(ofSize: 16)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timerLabel.text = "00:00:00" //Defualt Timer
        timerLabel.textColor = AppDesign.ColorScheme.TextColors.PrimaryTheme.secondaryText
        timerLabel.font = AppDesign.Fonts.semiBold(ofSize: 14)
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let infoStack = UIStackView(arrangedSubviews: [statusLabel, timerLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .center
        infoStack.spacing = 5
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: topAnchor),
            infoStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setStatus(isConnected: Bool)
    {
        if isConnected
        {
            statusLabel.text = AppDesign.Text.connectedKey
        }
        else
        {
            statusLabel.text = AppDesign.Text.disconnectedKey
        }
        
    }
    
    func setTimer(text: String)
    {
        timerLabel.text = text
    }
}

