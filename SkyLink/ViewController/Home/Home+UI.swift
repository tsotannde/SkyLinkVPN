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
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = AppDesign.Fonts.semiBold(ofSize: 16)
        configuration.attributedTitle = AttributedString(AppDesign.Text.HomeViewController.goPremium, attributes: container)
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        button.configuration = configuration
    
        
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
        button.tintColor = AppDesign.ColorScheme.Styling.Tint.primaryText
        
        // Rounded Rectanger
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 174).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }
    
    static func createDownloadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: AppDesign.AppKeys.UserDefaults.suiteName)
        
        var downloadBytes = defaults?.double(forKey: AppDesign.AppKeys.UserDefaults.downloadSpeed) ?? 0
        
        let isConnected = defaults?.bool(forKey: AppDesign.AppKeys.UserDefaults.lastConnectionState) ?? false
        // If not connected, ignore any old stored value and set speed to 0.0
        if !isConnected
        {
            downloadBytes = 0.0
        }
        print("[HomeViewController] Create Downnlaod Card State = : \(isConnected)")
        let state: ConnectionState = isConnected ? .active : .inactive
        print("[HomeViewController] Create Downnlaod  State = : \(state)")
       
        let card = StatCard(title: AppDesign.Text.downloadKey, value: downloadBytes.description, unit: AppDesign.Text.speedUnit, icon: AppDesign.Images.downloadArrow)
        card.update(speed: downloadBytes, state: state)
        return card
    }
    
    static func createUploadCard()->StatCard
    {
        let defaults = UserDefaults(suiteName: AppDesign.AppKeys.UserDefaults.suiteName)
        var uploadBytes = defaults?.double(forKey: AppDesign.AppKeys.UserDefaults.uploadSpeed) ?? 0
        let isConnected = defaults?.bool(forKey: AppDesign.AppKeys.UserDefaults.lastConnectionState) ?? false
        // If not connected, ignore any old stored value and set speed to 0.0
        if !isConnected
        {
            uploadBytes = 0.0
        }
        print("[HomeViewController] Create Upload Card State = : \(isConnected)")
        let state: ConnectionState = isConnected ? .active : .inactive
        print("[HomeViewController] Create Upload Card State = : \(isConnected)")
        
        let card = StatCard(title: AppDesign.Text.uploadKey, value: uploadBytes.description, unit: AppDesign.Text.speedUnit, icon: AppDesign.Images.uploadArrow)
        card.update(speed: uploadBytes, state: state)
        return card
    }
}
