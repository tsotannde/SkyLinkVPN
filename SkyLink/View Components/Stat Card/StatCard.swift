//
//  StatCard.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//


import UIKit

class StatCard: UIView
{
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let icon = UIImageView()
    
    init(title: String, value: String, unit: String, iconName: String)
    {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        // Configure icon
        icon.image = UIImage(systemName: iconName)
        icon.tintColor = UIColor(named: "primaryColor")
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .darkGray
        
        // Value label
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        valueLabel.textColor = .black
        
        // Unit label
        unitLabel.text = unit
        unitLabel.font = UIFont.systemFont(ofSize: 12)
        unitLabel.textColor = .gray
        
        // Layout
        let valueStack = UIStackView(arrangedSubviews: [valueLabel, unitLabel])
        valueStack.axis = .horizontal
        valueStack.spacing = 4
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, valueStack])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [textStack, icon])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private static func formatSpeed(_ bytesPerSecond: Double) -> (String, String) {
        guard bytesPerSecond > 0 else { return ("0.00", "B/s") }

        let units = ["B/s", "KB/s", "MB/s", "GB/s", "TB/s"]
        var value = bytesPerSecond
        var index = 0

        while value >= 1024 && index < units.count - 1 {
            value /= 1024
            index += 1
        }

        let formatted = String(format: "%.2f", value)
        return (formatted, units[index])
    }
    
    // Add this method for updates
    func update(speed: Double, state: ConnectionState)
    {
        // Determine color
        switch state {
        case .inactive:
            valueLabel.textColor = .red
        case .active:
            valueLabel.textColor = .systemGreen
        }

        // Format speed and unit
        let (formattedValue, unit) = StatCard.formatSpeed(speed)
        UIView.transition(with: valueLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.valueLabel.text = formattedValue
        }, completion: nil)
        UIView.transition(with: unitLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.unitLabel.text = unit
        }, completion: nil)
    }
}
