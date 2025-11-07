//
//  PowerButtonView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/30/25.
//


import UIKit

final class PowerButtonView: UIView
{
    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let innerCircle = UIView()
    private let powerIcon = UIImageView()

    // MARK: - Init
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
        
        // Circle sizes
        let outerCircleSize: CGFloat = 130
        let middleCircleSize: CGFloat = 110
        let innerCircleSize: CGFloat = 105
        
        // Outer circle
        outerCircle.backgroundColor = AppDesign.ColorScheme.Themes.primary
        outerCircle.layer.cornerRadius = outerCircleSize / 2
        outerCircle.translatesAutoresizingMaskIntoConstraints = false

        // Shadow for depth
        outerCircle.layer.shadowColor = AppDesign.ColorScheme.Styling.Shadow.standard.cgColor
        outerCircle.layer.shadowOpacity = 0.25   // soft and subtle
        outerCircle.layer.shadowOffset = CGSize(width: 0, height: 6)
        outerCircle.layer.shadowRadius = 10
        outerCircle.layer.masksToBounds = false
        
        // Middle circle
        middleCircle.backgroundColor = .white
        middleCircle.layer.cornerRadius = middleCircleSize / 2
        middleCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Inner circle
        innerCircle.backgroundColor = .systemBlue
        innerCircle.layer.cornerRadius = innerCircleSize / 2
        innerCircle.clipsToBounds = true
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Power icon
        powerIcon.image = UIImage(systemName: "power")
        powerIcon.tintColor = .white
        powerIcon.contentMode = .scaleAspectFit
        powerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(outerCircle)
        addSubview(middleCircle)
        addSubview(innerCircle)
        innerCircle.addSubview(powerIcon)
        
        NSLayoutConstraint.activate([
            outerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: outerCircleSize),
            outerCircle.heightAnchor.constraint(equalToConstant: outerCircleSize),
            
            middleCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleCircle.widthAnchor.constraint(equalToConstant: middleCircleSize),
            middleCircle.heightAnchor.constraint(equalToConstant: middleCircleSize),
            
            innerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: innerCircleSize),
            innerCircle.heightAnchor.constraint(equalToConstant: innerCircleSize),
            
            powerIcon.centerXAnchor.constraint(equalTo: innerCircle.centerXAnchor),
            powerIcon.centerYAnchor.constraint(equalTo: innerCircle.centerYAnchor),
            powerIcon.widthAnchor.constraint(equalToConstant: 40),
            powerIcon.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
//    func configure(state: VPNState)
//    {
//        switch state {
//        case .connected:
//            innerCircle.backgroundColor = .systemOrange
//            outerCircle.backgroundColor = .systemOrange
//        case .disconnected:
//            innerCircle.backgroundColor = .systemBlue
//            outerCircle.backgroundColor = .systemBlue
//        }
//    }
}
