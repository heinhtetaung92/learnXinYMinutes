//
//  ProgrammingLanguageCell.swift
//  LearnXinYMin
//
//  Created by Hein Htet on 10/4/20.
//  Copyright © 2020 Hein Htet. All rights reserved.
//

import UIKit

class ProgrammingLanguageCell: UITableViewCell {

    @IBOutlet weak var programmingLabel: UILabel!
    @IBOutlet weak var languageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        languageCollectionView.delegate = dataSourceDelegate
        languageCollectionView.dataSource = dataSourceDelegate
        languageCollectionView.tag = row
        languageCollectionView.reloadData()
        print("Reload Collection View")
    }
    
}
