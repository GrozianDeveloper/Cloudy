//
//  AllVC.swift
//  TestSecondsVCCloudy
//
//  Created by Bogdan Grozyan on 12.01.2021.
//

import UIKit

class AllPagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {


    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backToMain: UIButton!
    
    var pages: [locationParam] = UserDefaults.standard.array(forKey: "pages") as? [locationParam] ?? [locationParam(name: "", lat: "", lon: "")]
    var arrayFromURL: [locationParam] = []
    var filteredData: [locationParam]! //For started tableView
    
    func decodePages() {
        if let pagesList = UserDefaults.standard.data(forKey: "pages") {
            let decoder = JSONDecoder()
            if let decodedPages = try? decoder.decode([locationParam].self, from: pagesList) {
                self.pages = decodedPages
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        decodePages()
        
        getFromFileCities()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(AllVcCell.nib(), forCellReuseIdentifier: AllVcCell.identifier)
        filteredData = pages
        tableView.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let encoder = JSONEncoder()
        if let encodedPages = try? encoder.encode(pages) {
            UserDefaults.standard.set(encodedPages, forKey: "pages")
        }
        
    }
    //toMainFromAllPages
    
    //MARK: URLSession
    func getFromFileCities() {
        let url = Bundle.main.url(forResource: "cities_20000", withExtension: "json")
        URLSession.shared.dataTask(with: url!, completionHandler: { [self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var json: [cityData]?
            do {
                json = try JSONDecoder().decode([cityData].self, from: data)
            }
            catch {
                print(error)
            }
            guard let result = json else {
                return
            }
            
            var abc = -1
            for a in 0...result.count - 1 {
                var cityName = result[a].city_name
                if cityName == "San Francisco" {
                    abc += 1
                    if abc >= 1 {
                        cityName = ""
                    }
                }
                if cityName != "" {
                    let outputLocation = locationParam(name: cityName, lat: "", lon: "")
                    self.arrayFromURL.append(outputLocation)
                }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AllVcCell.identifier, for: indexPath) as! AllVcCell
        
        cell.configure(with: filteredData[indexPath.row].name)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            pages.remove(at: indexPath.row)
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    //
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = addAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [add])
    }
    
    func addAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Add") { [self] (action, _, _) in
            let a = filteredData.remove(at: indexPath.row)
            pages.append(a)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
        }
        action.backgroundColor = .green
        return action
    }

    //MARK: SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = pages
        }
    else {
        for name in arrayFromURL {
            if name.name.lowercased().contains(searchText.lowercased()) {
            //if name.lowercased().contains(searchText.lowercased()) {
                //filteredData.append(name)
                //let a: locationParam = locationParam(name: name, coords: "")
                //filteredData.append(a)
                let a = locationParam(name: name.name, lat: "", lon: "")
                filteredData.append(a)
            }
        }
    }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        filteredData = pages
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
}
