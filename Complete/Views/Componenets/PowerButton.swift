//
//  PowerButtonView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/30/25.
//


import UIKit

final class PowerButtonView: UIView {
    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let innerCircle = UIView()
    private let powerIcon = UIImageView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Outer circle
        outerCircle.backgroundColor = .systemBlue
        outerCircle.layer.cornerRadius = 75
        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Middle circle
        middleCircle.backgroundColor = .white
        middleCircle.layer.cornerRadius = 65
        middleCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Inner circle
        innerCircle.backgroundColor = .systemBlue
        innerCircle.layer.cornerRadius = 62.5
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
            outerCircle.widthAnchor.constraint(equalToConstant: 150),
            outerCircle.heightAnchor.constraint(equalToConstant: 150),
            
            middleCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleCircle.widthAnchor.constraint(equalToConstant: 130),
            middleCircle.heightAnchor.constraint(equalToConstant: 130),
            
            innerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 125),
            innerCircle.heightAnchor.constraint(equalToConstant: 125),
            
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