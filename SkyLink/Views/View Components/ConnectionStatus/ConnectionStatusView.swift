////
////  ConnectionStatusView.swift
////  SkyLink
////
////  Created by Adebayo Sotannde on 10/22/25.
////
//
//
//
//import UIKit
//
//final class ConnectionStatusView: UIView {
//
//    private let statusCircle = UIView()
//    private let statusLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//
//    private func setupUI() {
//        statusCircle.layer.cornerRadius = 5
//        statusCircle.backgroundColor = .systemRed
//
//        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
//        statusLabel.textColor = .darkGray
//        statusLabel.text = "Disconnected"
//
//        addSubview(statusCircle)
//        addSubview(statusLabel)
//
//        statusCircle.translatesAutoresizingMaskIntoConstraints = false
//        statusLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            statusCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
//            statusCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
//            statusCircle.widthAnchor.constraint(equalToConstant: 10),
//            statusCircle.heightAnchor.constraint(equalToConstant: 10),
//
//            statusLabel.leadingAnchor.constraint(equalTo: statusCircle.trailingAnchor, constant: 6),
//            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
//    func update(isConnected: Bool) {
//        DispatchQueue.main.async {
//            self.statusCircle.backgroundColor = isConnected ? .systemGreen : .systemRed
//            self.statusLabel.text = isConnected ? "Connected" : "Disconnected"
//        }
//    }
//}
//
