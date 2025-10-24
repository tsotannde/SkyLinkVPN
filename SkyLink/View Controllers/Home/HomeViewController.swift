//
//  HomeViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit

//
//  TempViewController.swift
//  SkyLink
//
//  Created by Developer on 10/11/25.
//

import UIKit

class HomeViewController: UIViewController
{
    internal let gridButton = createGridButton()
    internal let premiumButton = createPremiumButton()
    internal let downloadCard = createDownloadCard()
    internal let uploadCard = createUploadCard()
    internal let selectedServerView = SelectedServerView()
    internal let connectionStatusView = ConnectionStatusView()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .gray
        constructUserInterface()
        startStatsUpdates()
        
        NotificationCenter.default.addObserver(self,selector: #selector(updateServerView),name: .serverDidUpdate,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateServerView()
        
        ServerFetcherManager.shared.refreshServerData
        { success in
            print(success ? "Server data refreshed successfully." : "Failed to refresh server data.")
        }
    }
  
    
    private var statsUpdateTimer: Timer?

    private func startStatsUpdates() {
        statsUpdateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            
            let defaults = UserDefaults(suiteName: "group.com.adebayosotannde.SkyLink")
            let downloadBytes = defaults?.double(forKey: "downloadSpeed") ?? 0
            let uploadBytes = defaults?.double(forKey: "uploadSpeed") ?? 0
            let isConnected = defaults?.bool(forKey: "isConnected") ?? false


//            print("""
//            📲 [Main App]
//            Download: \(downloadBytes)
//            Upload: \(uploadBytes)
//            Connected: \(isConnected)
//            Defaults Path: \(defaults?.dictionaryRepresentation() ?? [:])
//            """)
            
            let state: ConnectionState = isConnected ? .active : .inactive
            self.downloadCard.update(speed: downloadBytes, state: state)
            self.uploadCard.update(speed: uploadBytes, state: state)
        }
    }
}







extension HomeViewController
{
//    @objc  func serverViewTapped()
//    {
//        print("I've been tapped")
//
//        let selectionVC = ServerSelectionViewController()
//            selectionVC.modalPresentationStyle = .pageSheet
//            if let sheet = selectionVC.sheetPresentationController
//        {
//
//                sheet.detents = [.large()]
//                sheet.prefersGrabberVisible = true
//        }
//            present(selectionVC, animated: true)
//    }
    
    @objc func serverViewTapped()
    {
        TapbackManager.shared.performTapFeedback()
        
        let selectionVC = ServerSelectionViewController()
        selectionVC.modalPresentationStyle = .pageSheet

        if let sheet = selectionVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }

        present(selectionVC, animated: true)
    }
    
//    @objc private func updateServerView()
//    {
//        guard let currentServer = ConfigurationManager.shared.loadCurrentServer() else
//        {
//            print("⚠️ No server selected yet.")
//
//            return
//        }
//
//        print(currentServer)
//
//        // Create a new model based on the saved server
//        let model = ServerCell.ViewModel(
//            flagImage: FlagManager.shared.getCountryFlagImage(currentServer.country ?? "Unknown"),
//            city: currentServer.city ?? "Unknown",
//            state: currentServer.state ?? "",
//            totalCapacity: currentServer.capacity,
//            currentPeers: currentServer.currentCapacity,
//            showCrown: currentServer.requiresSubscription
//        )
//
//        // Update the selectedServerCell with the current server model
//        selectedServerView.configure(flag: model.flagImage, city: model.city, state: model.state, total: model.totalCapacity, current: model.currentPeers, showCrown: model.showCrown)
//    }
    
    @objc private func updateServerView() {
        if let currentServer = ConfigurationManager.shared.loadCurrentServer() {
            // existing behavior
            let model = ServerCell.ViewModel(
                flagImage: FlagManager.shared.getCountryFlagImage(currentServer.country ?? "Unknown"),
                city: currentServer.city ?? "Unknown",
                state: currentServer.state ?? "",
                totalCapacity: currentServer.capacity,
                currentPeers: currentServer.currentCapacity,
                showCrown: currentServer.requiresSubscription
            )
            selectedServerView.configure(flag: model.flagImage, city: model.city, state: model.state,
                                         total: model.totalCapacity, current: model.currentPeers, showCrown: model.showCrown)
        } else {
            print("⚠️ No server selected yet. Selecting a random one...")
            
            let subscriptionStatus = SubscriptionManager.shared.isSubcribed()
            ConfigurationManager.shared.chooseRandomServer(isSubscribed: subscriptionStatus) { server in
                guard let server = server else {
                    print("❌ Failed to select random server.")
                    return
                }
                DispatchQueue.main.async {
                    print("✅ Auto-selected random server: \(server.name)")
                    NotificationCenter.default.post(name: .serverDidUpdate, object: nil)
                }
            }
        }
    }
}



//MARK: - UIComponents
extension HomeViewController
{
   
    
    
    
   

    
    
}

//MARK: - Construct User Interface
extension HomeViewController
{
    func constructUserInterface()
    {
        hideNavigationBar()
        setBackgroundColor()
        
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
            selectedServerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Add tap gesture recognizer to cardView
        let tap = UITapGestureRecognizer(target: self, action: #selector(serverViewTapped))
        selectedServerView.addGestureRecognizer(tap)
    }
    func setBackgroundColor()
    {
        view.backgroundColor = DesignSystem.AppColors.backgroundcolor
    }
    
    func hideNavigationBar()
    {
        NavigationManager.shared.toggleNavigationBar(on: navigationController, animated: false, shouldShow: false)
    }
}
//MARK: - UIComponents
extension HomeViewController
{
    
    
   
    
    
    
   

    func createServerView(country: String) -> UIView {
        // Create a temporary container to hold the cell’s contentView
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear

        // Initialize your ServerView (UITableViewCell)
        let testCell = CountryCell(style: .default, reuseIdentifier: nil)
        
    
        // Configure it with a fake model for testing
        let model = CountryCell.ViewModel(
            flagImage: UIImage(named: "us_flag"), // or any placeholder
            name: "United States",
            totalCapacity: 500,
            currentPeers: 75,
            showChevron: true,
            showCrown: false,
            isExpanded: false
        )
        testCell.configure(with: model)

        // Add its cardView to our container manually
        if let card = testCell.contentView.subviews.first {
            container.addSubview(card)
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: container.topAnchor),
                card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                card.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }

        // Add tap gesture for later navigation
        let tap = UITapGestureRecognizer(target: self, action: #selector(serverViewTapped))
        container.addGestureRecognizer(tap)

        return container
    }
    
}




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
        
        // Padding adjustment for better proportions
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func createPremiumButton() -> UIButton {
        let button = UIButton(type: .system)
        
        // Text setup
        button.setTitle("Go Premium", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Background color (orange primary)
        button.backgroundColor = UIColor(named: "primaryColor")
        
        // Corner radius & shadow
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        // Add image to left side of text
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let icon = UIImage(named: "crown")?.withRenderingMode(.alwaysOriginal)
        
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        
        // Spacing adjustments
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        // Rounded rect style matches Figma proportions
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 174).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }
    
    static func createDownloadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: "group.com.adebayosotannde.SkyLink")
        let downloadBytes = defaults?.double(forKey: "downloadSpeed") ?? 0
        let isConnected = defaults?.bool(forKey: "isConnected") ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title: "Download", value: downloadBytes.description, unit: "mb/s", iconName: "arrow.down.circle.fill")
        card.update(speed: downloadBytes, state: state)
        return card
        
        
    }
    
    static func createUploadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: "group.com.adebayosotannde.SkyLink")
        let uploadBytes = defaults?.double(forKey: "uploadSpeed") ?? 0
        let isConnected = defaults?.bool(forKey: "isConnected") ?? false
        let state: ConnectionState = isConnected ? .active : .inactive
        
        let card = StatCard(title: "Upload", value: uploadBytes.description, unit: "mb/s", iconName: "arrow.down.circle.fill")
        card.update(speed: uploadBytes, state: state)
        return card
    }
}





