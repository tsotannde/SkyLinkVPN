//
//  ServerSelectionViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//


import UIKit

//
//  ServerSelectionViewController.swift
//  SkyLink
//
//  Created by Adebayo Sotannde on 10/22/25.
//

//import UIKit
//
//final class ServerSelectionViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Hello, world!")
//        view.backgroundColor = .systemBackground
//    }
//}




import UIKit

class ServerSelectionViewController: UIViewController
{
    
    private var titleLabel: UILabel!
    private var searchContainerView: UIView!
    private var tableView: UITableView!
    private var expandedCountries = Set<IndexPath>()
    private var freeCountries: [Country] = []
    private var premiumCountries: [Country] = []
    
    private var visibleRows: [VisibleRow] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "#F7F7F9")
        constructUI()
        setupTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
      
    }
   
    private func constructUI()
    {
        // Create and add title label
        titleLabel = createTitleLabel()
        view.addSubview(titleLabel)

        // Create and add search container view
        searchContainerView = createSearchContainerView()
        view.addSubview(searchContainerView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            //titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupTableView()
    {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //Register Cells
        tableView.register(CountryCell.self, forCellReuseIdentifier: "ServerViewCell")
        tableView.register(ServerCell.self, forCellReuseIdentifier: "IndividualServerCell")
        
        view.insertSubview(tableView, belowSubview: searchContainerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func dismissKeyboard()
    {
        view.endEditing(true)
    }
}



extension ServerSelectionViewController: UITableViewDelegate, UITableViewDataSource
{
    
    private struct VisibleRow {
        enum RowType {
            case country(Country)
            case server(Server)
        }
        let type: RowType
        let section: Int
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Free section visible rows
            return visibleRows.filter { $0.section == 0 }.count
        } else {
            // Premium section visible rows
            return visibleRows.filter { $0.section == 1 }.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? "FREE LOCATIONS" : "PREMIUM LOCATIONS"
    }

    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVisibleRows = visibleRows.filter { $0.section == indexPath.section }
        let visibleRow = sectionVisibleRows[indexPath.row]
        
        switch visibleRow.type {
        case .country(let country):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServerViewCell", for: indexPath) as! CountryCell
            let flag = FlagManager.shared.getCountryFlagImage(country.name ?? "") ?? UIImage(systemName: "globe")
            let model = CountryCell.ViewModel(
                flagImage: flag,
                name: country.name ?? "Unknown",
                totalCapacity: 700,
                currentPeers: 50,
                showChevron: true,
                showCrown: country.requiresSubscription,
                isExpanded: expandedCountries.contains(indexPath)
            )
            cell.configure(with: model)
            return cell
            
        case .server(let server):
            let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualServerCell", for: indexPath) as! ServerCell
            let flag = FlagManager.shared.getCountryFlagImage(server.country ?? "") ?? UIImage(systemName: "globe")
            let model = ServerCell.ViewModel(
                flagImage: flag,
                city: server.city ?? "Unknown City",
                state: server.state ?? "Unknown",
                totalCapacity: server.capacity,
                currentPeers: server.currentCapacity, showCrown: true
            )
            cell.configure(with: model)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "Sora-SemiBold", size: 12) ?? .systemFont(ofSize: 12, weight: .semibold)
        header.textLabel?.textColor = UIColor.gray
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVisibleRows = visibleRows.filter { $0.section == indexPath.section }
        let visibleRow = sectionVisibleRows[indexPath.row]

        switch visibleRow.type {
        case .country(let country):
            guard let cell = tableView.cellForRow(at: indexPath) as? CountryCell else { return }
            
          
            
            
            // Delay deselection until UIKit finishes highlight
            DispatchQueue.main.async {
                tableView.deselectRow(at: indexPath, animated: false)
                cell.selectionStyle = .none
                cell.setHighlighted(false, animated: false)
                cell.setSelected(false, animated: false)
            }

            let isExpanding = !expandedCountries.contains(indexPath)
            if isExpanding {
                expandedCountries.insert(indexPath)
            } else {
                expandedCountries.remove(indexPath)
            }
            cell.setExpanded(isExpanding)

            // Get servers for this country
            let servers = Array(country.servers.values)
            let section = indexPath.section

            tableView.performBatchUpdates({
                // Rebuild visibleRows before updating the UI
                //rebuildVisibleRows(for: indexPath)

                if isExpanding {
                    let newIndexPaths = (0..<servers.count).map {
                        IndexPath(row: indexPath.row + 1 + $0, section: section)
                    }
                    tableView.insertRows(at: newIndexPaths, with: .fade)
                } else {
                    let removeIndexPaths = (0..<servers.count).map {
                        IndexPath(row: indexPath.row + 1 + $0, section: section)
                    }
                    tableView.deleteRows(at: removeIndexPaths, with: .fade)
                }
            }, completion: nil)

        case .server(let server):
            print("✅ Selected: \(server.city ?? "Unknown City"), \(server.state ?? "Unknown State") [\(server.publicIP ?? "Unavailable")]")
        }
    }
}



extension ServerSelectionViewController
{
    private func createTitleLabel() -> UILabel
    {
        let label = UILabel()
        label.text = "Choose server location"
        label.font = UIFont(name: "Sora-SemiBold", size: 20) ?? .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "SkyLinkBlack")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createSearchContainerView() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        container.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // --- Inner components ---

        // Search text field
        let searchTextField = UITextField()
        searchTextField.placeholder = "Search location"
        searchTextField.font = UIFont(name: "Sora-Regular", size: 16) ?? .systemFont(ofSize: 16)
        searchTextField.textColor = UIColor(named: "Neutral500") ?? UIColor.systemGray
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .clear
        searchTextField.translatesAutoresizingMaskIntoConstraints = false

        // Search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor(named: "Neutral500") ?? UIColor.systemGray
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .scaleAspectFit

        // Add subviews
        container.addSubview(searchTextField)
        container.addSubview(searchIcon)

        NSLayoutConstraint.activate([
            // Icon
            searchIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            searchIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 16),
            searchIcon.heightAnchor.constraint(equalToConstant: 16),

            // TextField
            searchTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            searchTextField.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -12)
        ])

        // Make container tappable to focus the text field
        let tapGesture = UITapGestureRecognizer(target: searchTextField, action: #selector(UITextField.becomeFirstResponder))
        container.addGestureRecognizer(tapGesture)

        return container
    }
}



