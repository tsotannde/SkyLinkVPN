//MARK: - UIComponents
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
        button.setTitle(DesignSystem.L10n.goPremiumKey, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Background color (orange primary)
        button.backgroundColor = DesignSystem.AppColors.Themes.primaryColor
        
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
        let defaults = UserDefaults(suiteName: DesignSystem.configuration.groupName)
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
    
    func createServerView(country: String) -> UIView
    {
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
