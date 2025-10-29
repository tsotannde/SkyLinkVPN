//
//  HomeViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit
import FirebaseAuth
import NetworkExtension

class HomeViewController: UIViewController
{
    internal let gridButton = createGridButton()
    internal let premiumButton = createPremiumButton()

    internal let downloadCard = createDownloadCard()
    internal let uploadCard = createUploadCard()
    internal let selectedServerView = SelectedServer()

   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideNavigationBar()
        setBackgroundColor()
        
        constructUserInterface()
        updateSelectedServerView()
        checkVpnStatusOnLaunch()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Had appeared again")
        
        // Add listener for when server changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSelectedServerView),
            name: .serverDidUpdate,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .serverDidUpdate, object: nil)
    }
  
    
   
   
    // MARK: - VPN Status Check on Launch
private func checkVpnStatusOnLaunch() {
    Task {
        let isConnected = await VPNManager.shared.isConnectedToVPN()
        if isConnected {
            print("VPN is already connected")
            //startVpnTimer()
            // TODO: Update UI/animation to show connected state
        } else {
            print("VPN is not connected")
            //stopVpnTimer()
            // TODO: Update UI/animation to show disconnected state
        }
    }
}
}

// MARK: - Button Actions
extension HomeViewController
{
    @objc func serverViewTapped()
    {
        TapbackManager.shared.performTapFeedback()
        
        let selectionVC = ServerSelectionViewController()
        selectionVC.modalPresentationStyle = .pageSheet

        if let sheet = selectionVC.sheetPresentationController
        {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }

        present(selectionVC, animated: true)
    }
    @objc func startButtonTapped()
    {
        print("Starting VPN...")
        
        Task
        {
            await VPNManager.shared.startTunnel()
        }
    }

    @objc func stopButtonTapped()
    {
        print("Stopping VPN…")
        Task
        {
            await  VPNManager.shared.stopTunnel()
        }
    }

    @objc func signOutButtonTapped()
    {
        try? Auth.auth().signOut()
        print("User signed out")
    }
    
    @objc func updateSelectedServerView()
    {
        Task {
            // Get server from ConfigurationManager
            guard let server = await ConfigurationManager.shared.getOrSelectServer() else {
                print("No server available to display.")
                return
            }

            // Use a placeholder flag for now
            let flagImage = FlagManager.shared.getCountryFlagImage(server.country!)

            // Update UI
            selectedServerView.configure(
                flag: flagImage,
                city: server.city ?? "Unknown",
                state: server.state ?? "",
                total: server.capacity,
                current: server.currentCapacity,
                showCrown: server.requiresSubscription
            )

            print("Updated SelectedServerView with server: \(server.name)")
        }
    }

}

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
   
    
   
    
   
}
//MARK: - Construct User Interface
extension HomeViewController
{
   
    
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
            gridButton.heightAnchor.constraint(equalToConstant: 48),
            gridButton.widthAnchor.constraint(equalToConstant: 48),
            
            premiumButton.centerYAnchor.constraint(equalTo: gridButton.centerYAnchor),
            premiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            premiumButton.heightAnchor.constraint(equalToConstant: 48),
            premiumButton.widthAnchor.constraint(equalToConstant: 174)
        ])
        
        // Container for stats (rounded background) with divider between cards
        let statsContainer = UIView()
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.backgroundColor = .clear
        statsContainer.layer.cornerRadius = 16
        statsContainer.layer.masksToBounds = true
        statsContainer.layer.borderColor = UIColor.red.cgColor
        statsContainer.layer.borderWidth = 1
        view.addSubview(statsContainer)

        // Divider view (thin, inset, adaptive color)
        let divider = UIView()
        divider.backgroundColor = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.setContentHuggingPriority(.required, for: .horizontal)
        divider.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1)
        ])

        // Wrap cards in equal-width containers so the divider stays centered
        let leftContainer = UIView()
        let rightContainer = UIView()
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.translatesAutoresizingMaskIntoConstraints = false

        leftContainer.addSubview(downloadCard)
        rightContainer.addSubview(uploadCard)
        downloadCard.translatesAutoresizingMaskIntoConstraints = false
        uploadCard.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Pin cards to their containers
            downloadCard.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            downloadCard.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor),
            downloadCard.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            downloadCard.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor),

            uploadCard.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            uploadCard.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor),
            uploadCard.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            uploadCard.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor)
        ])

        let statsStack = UIStackView(arrangedSubviews: [leftContainer, divider, rightContainer])
        statsStack.axis = .horizontal
        statsStack.alignment = .fill
        statsStack.distribution = .fill
        statsStack.spacing = 0
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(statsStack)

        NSLayoutConstraint.activate([
            // Place container below grid button
            statsContainer.topAnchor.constraint(equalTo: gridButton.bottomAnchor, constant: 25),
            statsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsContainer.heightAnchor.constraint(equalToConstant: 80),

            // Pin the internal stack to the container with padding
            statsStack.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            statsStack.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            statsStack.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leftContainer.widthAnchor.constraint(equalTo: rightContainer.widthAnchor)
        ])

        // Inset the divider vertically so it doesn't span the full height
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: statsStack.topAnchor, constant: 8),
            divider.bottomAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: -8)
        ])

        downloadCard.backgroundColor = .clear
        uploadCard.backgroundColor = .clear
        downloadCard.layer.cornerRadius = 0
        uploadCard.layer.cornerRadius = 0
        downloadCard.layer.masksToBounds = false
        uploadCard.layer.masksToBounds = false

        // Status + Timer labels stack
        let statusLabel = UILabel()
        statusLabel.text = "Safely connected"
        statusLabel.font = UIFont.boldSystemFont(ofSize: 20)
        statusLabel.textAlignment = .center

        let timerLabel = UILabel()
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont.systemFont(ofSize: 16)
        timerLabel.textColor = .darkGray
        timerLabel.textAlignment = .center

        let statusStack = UIStackView(arrangedSubviews: [statusLabel, timerLabel])
        statusStack.axis = .vertical
        statusStack.spacing = 4
        statusStack.alignment = .center
        statusStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(statusStack)

        // Add PowerButtonView
        let powerButtonView = PowerButton()
        view.addSubview(powerButtonView)

        NSLayoutConstraint.activate([
            powerButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            powerButtonView.bottomAnchor.constraint(equalTo: statusStack.topAnchor, constant: -40),
            powerButtonView.widthAnchor.constraint(equalToConstant: 200),
            powerButtonView.heightAnchor.constraint(equalToConstant: 200),
            statusStack.bottomAnchor.constraint(equalTo: selectedServerView.topAnchor, constant: -20),
            statusStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

//MARK: - User Interface Components
extension HomeViewController
{
    static func createGridButton() -> UIButton
    {
        let button = UIButton(type: .system)
        button.setImage(AppDesign.Images.grid, for: .normal)
        button.tintColor = AppDesign.ColorScheme.Styling.Tint.secondary
        
        // Background Color and Border Color
        button.backgroundColor = AppDesign.ColorScheme.Styling.Background.surface
        button.layer.cornerRadius = 16
        button.layer.borderColor = AppDesign.ColorScheme.Styling.Border.subtle.cgColor
        button.layer.borderWidth = 1
        
        // Depth Drop Shadow for Depth
        button.layer.shadowColor = AppDesign.ColorScheme.Styling.Shadow.standard.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        
        return button
    }
    
    static func createPremiumButton() -> UIButton
    {
        let button = UIButton(type: .system)
        
        // Text setup
        button.setTitle(AppDesign.Text.HomeViewController.goPremium, for: .normal)
        button.setTitleColor(AppDesign.ColorScheme.TextColors.PrimaryTheme.text, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
        
        button.backgroundColor = AppDesign.ColorScheme.Themes.primary
        
        // Corner radius & shadow
        button.layer.cornerRadius = 16
        button.layer.shadowColor = AppDesign.ColorScheme.Styling.Shadow.standard.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        // Add image to left side of text
        let icon = AppDesign.Images.crown?.withRenderingMode(.alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.tintColor = .white
    
        
        // Spacing and padding
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        button.configuration = configuration
        
        // Rounded Rectanger
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 174).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }
    
    static func createDownloadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: AppDesign.AppKeys.UserDefaults.suiteName)
        let downloadBytes = defaults?.double(forKey: AppDesign.AppKeys.UserDefaults.downloadSpeed) ?? 0
        let isConnected = defaults?.bool(forKey: AppDesign.AppKeys.UserDefaults.isConnected) ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title:AppDesign.Text.downloadKey , value: downloadBytes.description, unit: "mb/s", icon: AppDesign.Images.downloadArrow)
        card.update(speed: downloadBytes, state: state)
        return card
    }
    
    static func createUploadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: AppDesign.AppKeys.UserDefaults.suiteName)
        let uploadBytes = defaults?.double(forKey: AppDesign.AppKeys.UserDefaults.uploadSpeed) ?? 0
        let isConnected = defaults?.bool(forKey: AppDesign.AppKeys.UserDefaults.isConnected) ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title: AppDesign.Text.uploadKey, value: uploadBytes.description, unit: "mb/s", icon: AppDesign.Images.uploadArrow)
        card.update(speed: uploadBytes, state: state)
        return card
    }
}

//MARK: - Constuct User Interface
extension HomeViewController
{
    func hideNavigationBar()
    {
        NavigationManager.shared.toggleNavigationBar(on: navigationController, animated: false, shouldShow: false)
    }
    
    func setBackgroundColor()
    {
        view.backgroundColor = AppDesign.ColorScheme.App.background
    }
}









struct AppDesign
{
    struct Configuration
    {
        // TODO: align with your existing app group identifier
        static let groupName: String = "group.com.skylink"
    }
    
    enum AppKeys
    {
        enum UserDefaults
        {
            static let suiteName = AppDesign.Configuration.groupName
            static let isConnected = "isConnected"
            static let downloadSpeed = "downloadSpeed"
            static let uploadSpeed = "uploadSpeed"
        }
    }
    struct Images
    {
        static let grid: UIImage? = UIImage(systemName: "square.grid.2x2")
        static let crown: UIImage? = UIImage(named: "crown")
        static let downloadArrow: UIImage? = UIImage(systemName: "arrow.down.circle.fill")
        static let uploadArrow: UIImage? = UIImage(systemName: "arrow.up.circle.fill")
    }
    
    struct ColorScheme
    {
        struct Styling
        {
            struct BackgroundsColor
            {
                static let white: UIColor = .white
            }
            
            struct tintColors
            {
                static let grey: UIColor = .darkGrey
            }
            
            struct boarderColor
            {
                static let grey: UIColor = UIColor(white: 0.9, alpha: 1)
            }
            
            struct shadowcolor
            {
                static let black: UIColor = .black
            }
            
            struct Background {
                static let surface: UIColor = .white
            }
            struct Tint {
                static let secondary: UIColor = .darkGrey
                static let statIcon: UIColor = .systemGreen
            }
            struct Border {
                static let subtle: UIColor = UIColor(white: 0.9, alpha: 1)
            }
            struct Shadow {
                static let standard: UIColor = .black
            }
        }
        
        struct App
        {
            static let background: UIColor = .systemBackground
        }
        
        struct Themes
        {
            static let primary: UIColor = UIColor(red: 0.2588, green: 0.6471, blue: 0.9608, alpha: 1.0)
        }
        
        struct TextColors
        {
            struct PrimaryTheme
            {
                static let text: UIColor = .white
            }
            
            struct SecondaryTheme
            {
                
            }
        }
        
        
    }
    
    enum Text
    {
        struct HomeViewController
        {
            static let goPremium = String(localized:  "goPremiumKey")
        }
        
        
        static let downloadKey = String(localized:  "downloadKey")
        static let uploadKey = String(localized:  "uploadKey")
    }
}

