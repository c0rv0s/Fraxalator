//
//  pickInstrument.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 7/23/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class pickInstrument: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var colView: UICollectionView!
    var collectionItems = ["Piano", "Pop Celesta", "Marimba", "Synth Bass"]
    
    var selectedSet : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 150, left: 0, bottom: 50, right: 0)
        
        layout.itemSize = CGSize(width: 175, height: 175)
        
        colView!.contentInset = UIEdgeInsets(top: 23, left: 40, bottom: 40, right: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSet = (indexPath as NSIndexPath).row
        //self.performSegue(withIdentifier: "InfoDetailSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        /*
        if (segue!.identifier == "InfoDetailSeg") {
            let viewController:FirstViewController = segue!.destinationViewController as! FirstViewController
            
            viewController.set = collectionItems[selectedSet]
        }
 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath) as! TitleCell
        cell.cellLabel = self.collectionItems[(indexPath as NSIndexPath).row]
        cell.title.text = cell.cellLabel
        
        return cell
    }
}
