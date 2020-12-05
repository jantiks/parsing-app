//
//  ViewController.swift
//  project7
//
//  Created by Tigran on 12/1/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        }else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "credits", style: .plain, target: self, action: #selector(creditsTapped))
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url){
                    //we're OK to parse
                    self?.parse(json: data)
                    
                }else {
                    self?.showError()
                }
            }else {
                self?.showError()
            }
        }
        
    }
    
    @objc func searchTapped() {
        filteredPetitions.removeAll()
        let ac = UIAlertController(title: "type key word", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        let action = UIAlertAction(title: "Search", style: .default){
            [weak self, weak ac]  _ in
            if let text = ac?.textFields?[0].text {
                for i in 0..<(self?.petitions.count)!{
                    if (self?.petitions[i].title.lowercased().contains(text.lowercased()))! {
                        self?.filteredPetitions.append((self?.petitions[i])!)
                    }else { continue }
                }
                self?.tableView.reloadData()
                
            }
        }
        ac.addAction(action)
        present(ac,animated: true)
    }
    
    @objc func creditsTapped() {
        let ac = UIAlertController(title: "data is comming from White House Api", message:nil , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac,animated: true)
        
    }
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonpetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonpetitions.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()

            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = petitions.count
        
        if !filteredPetitions.isEmpty{
            rows = filteredPetitions.count
        }
       
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var petition = petitions[indexPath.row]
        if !filteredPetitions.isEmpty{
            petition = filteredPetitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

