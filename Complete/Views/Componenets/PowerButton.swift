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
    case connecting
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
        case .connecting:
            print("Start Tunnel")
            connectingAnimation()
        case .stopTunnel:
            print("Stop Tunnel")
        }
    }
}

extension PowerButtonView
{
    
    private func connectedAnimation() {
        // First, remove the spinner layer if it exists
        middleCircle.layer.sublayers?.removeAll(where: { $0.name == "spinnerLayer" })
        
        // Reset the middle circle’s background to solid (if you want to make it clean)
        middleCircle.backgroundColor = AppDesign.ColorScheme.Styling.Background.surface
        
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
   
    
    private func connectingAnimation2()
    {
        middleCircle.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.4)
        middleCircle.layer.sublayers?.removeAll(where: { $0.name == "spinnerLayer" })
        
        let radius = min(middleCircle.bounds.width, middleCircle.bounds.height) / 2 - 2
        
        // Create spinner layer
        let spinnerLayer = CAShapeLayer()
        spinnerLayer.name = "spinnerLayer"
        
        // Create path at (0,0) since we'll position using anchorPoint
        let path = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius), // Offset by radius
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: .pi / 2,
            clockwise: true
        )
        
        spinnerLayer.path = path.cgPath
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.strokeColor = UIColor.white.cgColor
        spinnerLayer.lineWidth = 3
        spinnerLayer.lineCap = .round
        spinnerLayer.strokeEnd = 1.0
        
        // Set the frame and anchor point
        spinnerLayer.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        spinnerLayer.position = CGPoint(x: middleCircle.bounds.midX, y: middleCircle.bounds.midY)
        spinnerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Rotate around center
        
        middleCircle.layer.addSublayer(spinnerLayer)
        
        // Rotate animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // Pulse animation
        let pulseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 0.7
        pulseAnimation.duration = 0.8
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        spinnerLayer.add(rotationAnimation, forKey: "rotation")
        spinnerLayer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func connectingAnimation()
    {
        middleCircle.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.4)
        middleCircle.layer.sublayers?.removeAll(where: { $0.name == "spinnerLayer" })
        
        let radius = min(middleCircle.bounds.width, middleCircle.bounds.height) / 2 - 2
        
        // Create spinner layer
        let spinnerLayer = CAShapeLayer()
        spinnerLayer.name = "spinnerLayer"
        
        // Create path at (0,0) since we'll position using anchorPoint
        let path = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius), // Offset by radius
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: .pi / 2,
            clockwise: true
        )
        
        spinnerLayer.path = path.cgPath
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.strokeColor = UIColor.white.cgColor
        spinnerLayer.lineWidth = 3
        spinnerLayer.lineCap = .round
        spinnerLayer.strokeEnd = 1.0
        
        // Set the frame and anchor point
        spinnerLayer.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        spinnerLayer.position = CGPoint(x: middleCircle.bounds.midX, y: middleCircle.bounds.midY)
        spinnerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Rotate around center
        
        middleCircle.layer.addSublayer(spinnerLayer)
        
        // Rotate animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // Pulse animation
        let pulseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 0.7
        pulseAnimation.duration = 0.8
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        spinnerLayer.add(rotationAnimation, forKey: "rotation")
        spinnerLayer.add(pulseAnimation, forKey: "pulse")
        
        // Add a subtle scale pulse to the whole button for a "connecting" feel
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.95
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = 1.2
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.layer.add(scaleAnimation, forKey: "connectingScalePulse")
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
