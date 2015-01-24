//
//  File.swift
//  ios
//
//  Created by Jorge Izquierdo on 24/01/15.
//  Copyright (c) 2015 izqui. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    let db: [Item] = [Item(name: "2 de mayo", by: "Goya", type: "lamina", price: 180, image: "1"), Item(name: "Las meninas", by: "Velazquez", type: "cuadro", price: 150, image: "2"), Item(name: "Goya en Madrid", by: "Museo", type: "entrada", price: 181, image: "3"), Item(name: "Goya en Madrid", by: "Velazquez", type: "impresion", price: 1800000, image: "4"),  Item(name: "Las meninas", by: "Velazquez", type: "lamina", price: 150, image: "2"), Item(name: "2 de mayo", by: "Goya", type: "cuadro", price: 180, image: "1")]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "go" {
            (segue.destinationViewController as CheckoutVC).item = (sender! as Item)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.db.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MainCell
        cell.setItem(self.db[indexPath.row])
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("go", sender: self.db[indexPath.row])
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(536/2, 761/2)
    }
}

class MainCell: UICollectionViewCell {
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var typeLabel: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    func setItem(item: Item) {
        self.backgroundImageView.image = UIImage(named: item.image)
        self.typeLabel.image = UIImage(named: item.type)
        self.titleLabel.text = item.name
        self.authorLabel.text = item.by
        self.priceLabel.text = "\(item.price)€"
    }
}