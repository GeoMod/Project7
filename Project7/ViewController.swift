//
//  ViewController.swift
//  Project7
//
//  Created by Daniel O'Leary on 3/6/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                // the call to 'return' will only be reached if the parse(json:) was Not reached.
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    @IBAction func creditsButtonBarItem(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Credits:", message: "Data provided by; We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Great", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonBarItem(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Filter Petitions", message: "containing words", preferredStyle: .alert)
        ac.addTextField()
        
        let searchItem = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] search in
            guard let searchPetition = ac?.textFields?[0].text else { return }
            // Moved to background thread
//            self?.search(item: searchPetition)
            self?.performSelector(inBackground: #selector(self?.search(item:)), with: searchPetition)
        }
        ac.addAction(searchItem)
        present(ac, animated: true, completion: nil)
        
    }
    
    
    @objc func search(item: String) {
        var foundObjects = [Petition]()
        
        for i in filteredPetitions {
            if i.title.contains(item) || i.body.contains(item) {
                foundObjects.append(i)
            }
        }
        filteredPetitions = foundObjects
        // Move back to foreground and reload the TableView
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count // petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row] // petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row] // petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func showError() {
        let ac = UIAlertController(title: "Error Loading", message: "There was an error loading data from the web.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dang", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
}

