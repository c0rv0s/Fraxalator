//
//  FeedLayout.swift
//  Opio-Assist
//
//  Created by Nathan Mueller on 5/15/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import UIKit

protocol FeedLayoutDelegate {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth:CGFloat) -> CGFloat
    // 2. Method to ask the delegate for the height of the annotation text
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class FeedLayoutAttributes:UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var photoHeight: CGFloat = 0.0
    
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! FeedLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? FeedLayoutAttributes {
            if( attributtes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}


class FeedLayout: UICollectionViewLayout {
    //1. Pinterest Layout Delegate
    var delegate:FeedLayoutDelegate!
    
    //2. Configurable properties
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    //3. Array to keep a cache of attributes.
    private var cache = [FeedLayoutAttributes]()
    
    //4. Content height and size
    private var contentHeight:CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    /*
    override class func layoutAttributesClass() -> AnyClass {
        return FeedLayoutAttributes.self
    }
    */
    override func prepare() {
        // 1. Only calculate once
        if cache.isEmpty {
            
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // 3. Iterates through the list of items in the first section
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                let width = columnWidth - cellPadding*2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding - 50
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                let attributes = FeedLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6. Updates the collection view content height
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    /*
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
