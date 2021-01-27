//
//  TableViewCell.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 20.11.2020.
//

import UIKit

class TableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        @IBOutlet var collectionView: UICollectionView!

    
    var bit = [HourlyDataWeatherbit]()

        override func awakeFromNib() {
            super.awakeFromNib()
            collectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

        static let identifier = "TableViewCell"

        static func nib() -> UINib {
            return UINib(nibName: "TableViewCell",
                         bundle: nil)
        }

    func configure(with bit: [HourlyDataWeatherbit]) {
        
        self.bit = bit
        
            collectionView.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 94, height: 350)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return bit.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
            cell.configure(with: bit[indexPath.row])
            return cell
        }
        
    }


