//
//  ViewController.swift
//  LearnXinYMin
//
//  Created by Hein Htet on 10/4/20.
//  Copyright © 2020 Hein Htet. All rights reserved.
//

import UIKit
import Firebase

class PLanguagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    let db = Firestore.firestore()
    
    var pLanguages: [PLanguage] = []
    
    var selectedPLanaguage: PLanguage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UINib(nibName: K.cellName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        loadProgrammingLanguages()
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.goToWebView {
            
            if selectedPLanaguage != nil {
                let vc = segue.destination as! WebViewController
                vc.programmingKey = selectedPLanaguage?.langKey
            }
            
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        loadProgrammingLanguages()
    }
    
    func loadProgrammingLanguages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.popularity, descending: true)
            .addSnapshotListener { querySnapshot, error in
                self.pLanguages = []
                
                if let e = error {
                    print(e)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let name = data[K.FStore.nameField] as? String,
                                let langKey = data[K.FStore.keyField] as? String,
                                let langs = data[K.FStore.langsField] as? [String]{
                                
                                let plang = PLanguage(key: doc.documentID, name: name, langKey: langKey, langs: langs)
                                self.pLanguages.append(plang)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                        }
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
        }
    }

}

extension PLanguagesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pLanguages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = pLanguages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellProgrammingIdentifier, for: indexPath) as! ProgrammingLanguageCell
        cell.programmingLabel.text = obj.name
        
        return cell
    }
    
    func getLanguageLabel(name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.textAlignment = .center
        return label
    }

}

extension PLanguagesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPLanaguage = pLanguages[indexPath.row]
        
        updatePopularity(plang: pLanguages[indexPath.row])
        performSegue(withIdentifier: K.goToWebView, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableCell = cell as? ProgrammingLanguageCell else {
            return
        }
        tableCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func updatePopularity(plang: PLanguage) {
        let ref = db.collection(K.FStore.collectionName)
            .document(plang.key)

        ref.getDocument { document,error in
            if let data = document?.data() {
                let currentPopularity = data[K.FStore.popularity] as! Int
                
                ref.updateData([
                    K.FStore.popularity: currentPopularity + 1
                ])
                
            }
    
        
        }
        
    }
    
}

extension PLanguagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let plang = pLanguages[collectionView.tag]
        print("Collection list count is \(plang.langs.count)")
        return plang.langs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Collection is about to create")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellLanguageIdentifier, for: indexPath) as! LanguageCell
        cell.languageLabel.text = pLanguages[collectionView.tag].langs[indexPath.row]
        
        print("Collection item is \(pLanguages[collectionView.tag].langs[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plang = pLanguages[collectionView.tag]
        print("Selected Item at \(indexPath.row) and value is \(plang.langs[indexPath.row])")
    }
    
}

