//
//  HomeViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController
{
    internal let gridButton = createGridButton()
    internal let premiumButton = createPremiumButton()

    
    internal let downloadCard = createDownloadCard()
    internal let uploadCard = createUploadCard()
    internal let selectedServerView = SelectedServerView()

   
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        

        hideNavigationBar()
        setBackgroundColor()
        constructUserInterface()
        updateSelectedServerView()
        
        temp()
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
  
    
   
   
}

//MARK: - Temporary
extension HomeViewController
{
    func temp()
    {
        // Add Start, Stop, and Sign Out buttons
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = UIColor.systemGreen
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        let stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.backgroundColor = UIColor.systemRed
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.cornerRadius = 12
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)

        let signOutButton = UIButton(type: .system)
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = UIColor.systemGray
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 12
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)

        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(signOutButton)

        // Layout: stack vertically below uploadCard
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: uploadCard.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 44),

            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 16),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            stopButton.heightAnchor.constraint(equalTo: startButton.heightAnchor),

            signOutButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 16),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            signOutButton.heightAnchor.constraint(equalTo: startButton.heightAnchor)
        ])
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
        print("Start button tapped")
    }

    @objc func stopButtonTapped() {
        print("Stop button tapped")
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

