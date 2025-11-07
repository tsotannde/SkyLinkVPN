//
//  AppDesign.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 11/6/25.
//


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
        static let downloadArrow: UIImage? = UIImage(systemName: "arrow.down")
        static let uploadArrow: UIImage? = UIImage(systemName: "arrow.up")
    }
    
    struct ColorScheme
    {
        struct Styling
        {
            struct Background {
                static let surface: UIColor = .white
            }
            
            struct Tint
            {
                static let secondary: UIColor = .darkGrey
                static let statIcon: UIColor = .systemGreen
                static let primaryText: UIColor = .white
            }
            struct Border {
                static let subtle: UIColor = UIColor(white: 0.9, alpha: 1)
            }
            struct Shadow
            {
                static let standard: UIColor = .black
            }
        }
        
        struct App
        {
            static let background: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
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
        static let speedUnit = String(localized: "speedUnitKey", defaultValue: "MB/s")
    }
}

extension AppDesign {
    struct Fonts {
        static func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Sora-Regualr", size: size) ?? UIFont.systemFont(ofSize: size)
        }

        static func semiBold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Sora-SemiBold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        }
    }
}

