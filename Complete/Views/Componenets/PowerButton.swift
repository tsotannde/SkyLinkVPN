//
//  PowerButtonView.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/30/25.
//

enum PowerButtonState
{
    case connected
    case disconnected
    case startTunnel
    case stopTunnel
}

import UIKit

final class PowerButtonView: UIView
{
    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let innerCircle = UIView()
    private let powerIcon = UIImageView()
    private var currentState: PowerButtonState = .disconnected

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
        outerCircle.layer.shadowOpacity = 0.25
        outerCircle.layer.shadowOffset = CGSize(width: 0, height: 6)
        outerCircle.layer.shadowRadius = 10
        outerCircle.layer.masksToBounds = false
        
        // Middle circle
        middleCircle.backgroundColor = AppDesign.ColorScheme.Styling.Background.surface
        middleCircle.layer.cornerRadius = middleCircleSize / 2
        middleCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Inner circle
        innerCircle.backgroundColor = AppDesign.ColorScheme.Themes.primary
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
}

extension PowerButtonView
{
    func setState(_ state: PowerButtonState)
    {
        currentState = state
        
        switch state {
        case .connected:
            print("Connected")
            connectedAnimation()
        case .disconnected:
            print("Disconnected Animation Started")
            disconnectedAnimation()
        case .startTunnel:
            print("Start Tunnel")
            connectingAnimation()
        case .stopTunnel:
            print("Stop Tunnel")
        }
    }
}

extension PowerButtonView
{
    private func connectedAnimation()
    {
        // Base colors for both circles
        outerCircle.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        innerCircle.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        
        // Create a shared color pulse animation
        let colorPulse = CABasicAnimation(keyPath: "backgroundColor")
        colorPulse.fromValue = UIColor.systemGreen.withAlphaComponent(0.9).cgColor
        colorPulse.toValue = UIColor.systemGreen.withAlphaComponent(0.4).cgColor
        colorPulse.duration = 1.2
        colorPulse.autoreverses = true
        colorPulse.repeatCount = .infinity
        colorPulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Add the animation to both layers
        outerCircle.layer.add(colorPulse, forKey: "connectedPulseOuter")
        innerCircle.layer.add(colorPulse, forKey: "connectedPulseInner")
    }
    
    private func connectingAnimation() {
        // Set middleCircle background to a faint grey so white highlight arc is visible
        middleCircle.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.4)
        
        // Remove any old loader layers from middleCircle
        middleCircle.layer.sublayers?.removeAll(where: { $0.name == "baseCircle" || $0.name == "highlightArc" })
        
        let middleCircleSize = middleCircle.bounds.size
        let radius = middleCircleSize.width / 2 - 1.5
        
        let center = CGPoint(x: middleCircle.bounds.midX, y: middleCircle.bounds.midY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        // Base circular stroke layer (light gray)
        let baseCircle = CAShapeLayer()
        baseCircle.name = "baseCircle"
        baseCircle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        baseCircle.fillColor = UIColor.clear.cgColor
        baseCircle.strokeColor = UIColor.systemGray3.cgColor
        baseCircle.lineWidth = 4
        baseCircle.lineCap = .round
        
        // Highlight arc layer (white)
        let highlightArc = CAShapeLayer()
        highlightArc.name = "highlightArc"
        highlightArc.path = baseCircle.path
        highlightArc.fillColor = UIColor.clear.cgColor
        highlightArc.strokeColor = UIColor.white.cgColor
        highlightArc.lineWidth = 4
        highlightArc.lineCap = .round
        highlightArc.strokeStart = 0
        highlightArc.strokeEnd = 0.2
        
        //middleCircle.layer.addSublayer(baseCircle)
        middleCircle.layer.addSublayer(highlightArc)
        
        // Animate strokeStart and strokeEnd to create traveling white edge
        let animationDuration: CFTimeInterval = 1.5
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = animationDuration
        strokeStartAnimation.repeatCount = .infinity
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.2
        strokeEndAnimation.toValue = 1.2
        strokeEndAnimation.duration = animationDuration
        strokeEndAnimation.repeatCount = .infinity
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        highlightArc.add(strokeStartAnimation, forKey: "strokeStartAnimation")
        highlightArc.add(strokeEndAnimation, forKey: "strokeEndAnimation")
    }
    
    private func disconnectedAnimation()
    {
        // Base colors for both circles
        outerCircle.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        innerCircle.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        
        // Create a shared color pulse animation
        let colorPulse = CABasicAnimation(keyPath: "backgroundColor")
        colorPulse.fromValue = UIColor.systemRed.withAlphaComponent(0.9).cgColor
        colorPulse.toValue = UIColor.systemRed.withAlphaComponent(0.4).cgColor
        colorPulse.duration = 1.2
        colorPulse.autoreverses = true
        colorPulse.repeatCount = .infinity
        colorPulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Add the animation to both layers
        outerCircle.layer.add(colorPulse, forKey: "disconnectedPulseOuter")
        innerCircle.layer.add(colorPulse, forKey: "disconnectedPulseInner")
    }
}
