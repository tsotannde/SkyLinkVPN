//
//  PowerButtonView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/28/25.
//

import UIKit

final class PowerButton: UIView {

    // MARK: - Subviews
    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let innerCircle = UIView()
    private let powerIcon = UIImageView()
    private let powerLabel = UILabel()
    private let powerStack = UIStackView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
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

        // Power label
        powerLabel.text = "Stop"
        powerLabel.textColor = .white
        powerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        powerLabel.textAlignment = .center
        powerLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack for icon + label
        powerStack.axis = .vertical
        powerStack.alignment = .center
        powerStack.spacing = 6
        powerStack.translatesAutoresizingMaskIntoConstraints = false
        powerStack.addArrangedSubview(powerIcon)
        powerStack.addArrangedSubview(powerLabel)

        // Add all subviews
        addSubview(outerCircle)
        addSubview(middleCircle)
        addSubview(innerCircle)
        innerCircle.addSubview(powerStack)

        // Constraints
        NSLayoutConstraint.activate([
            // Outer
            outerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 150),
            outerCircle.heightAnchor.constraint(equalToConstant: 150),

            // Middle
            middleCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleCircle.widthAnchor.constraint(equalToConstant: 130),
            middleCircle.heightAnchor.constraint(equalToConstant: 130),

            // Inner
            innerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 125),
            innerCircle.heightAnchor.constraint(equalToConstant: 125),

            // Stack
            powerStack.centerXAnchor.constraint(equalTo: innerCircle.centerXAnchor),
            powerStack.centerYAnchor.constraint(equalTo: innerCircle.centerYAnchor),
            powerIcon.widthAnchor.constraint(equalToConstant: 40),
            powerIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Public Configuration
    func configure(state: VPNState) {
        switch state {
        case .connected:
            powerLabel.text = "Stop"
            innerCircle.backgroundColor = .systemOrange
            outerCircle.backgroundColor = .systemOrange
        case .disconnected:
            powerLabel.text = "Connect"
            innerCircle.backgroundColor = .systemBlue
            outerCircle.backgroundColor = .systemBlue
        }
    }
}

// Example enum for readability
enum VPNState {
    case connected
    case disconnected
}
