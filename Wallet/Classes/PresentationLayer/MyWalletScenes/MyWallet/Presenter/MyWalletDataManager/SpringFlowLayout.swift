//
//  SpringFlowLayout.swift
//  Wallet
//
//  Created by Storiqa on 17/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SpringFlowLayout: UICollectionViewFlowLayout {
    var springDamping: CGFloat = 1
    
    override var collectionView: UICollectionView? {
        let collectionView = super.collectionView
        collectionView?.panGestureRecognizer.addTarget(self, action: #selector(handlePan(recognizer:)))
        return collectionView
    }
    
    private var animator: UIDynamicAnimator!
    private var addedBehaviors = [IndexPath: UIAttachmentBehavior]()
    private var topCellSnapshots = [IndexPath: UIView]()
    
    override init() {
        super.init()
        self.animator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.animator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    func setConfigureFlow(flow: UICollectionViewFlowLayout) {
        self.minimumLineSpacing = flow.minimumLineSpacing
        self.minimumInteritemSpacing = flow.minimumInteritemSpacing
        self.sectionInset = flow.sectionInset
        self.itemSize = flow.itemSize
        self.scrollDirection = flow.scrollDirection
        self.footerReferenceSize = flow.footerReferenceSize
        self.headerReferenceSize = flow.headerReferenceSize
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        guard let visibleItems = super.layoutAttributesForElements(in: visibleRect) else { return }
        
        for item in visibleItems {
            let indexPath = resolveIndexPath(for: item, in: collectionView)
            
            if let _ = self.addedBehaviors[indexPath] { continue }
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center.floored())
            behavior.length = 0
            behavior.damping = self.springDamping
            behavior.frequency = 1.0
            
            self.animator.addBehavior(behavior)
            self.addedBehaviors[indexPath] = behavior
        }
        
        stopCellsOnTop()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.animator.layoutAttributesForCell(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        stopCellsOnTop()
        
        guard let collectionView = self.collectionView else { return false }
        
        let contentOffset = collectionView.contentOffset.y + collectionView.contentInset.top
        let scrollDelta = newBounds.origin.y - collectionView.bounds.origin.y
        
        guard contentOffset < 0, scrollDelta < 0 else { return false }
        
        let resistanceFactor: CGFloat = 0.002
        let resistedScroll = abs(Float(scrollDelta * contentOffset * resistanceFactor))
        let simpleScroll = abs(Float(scrollDelta))
        let actualScroll = min(simpleScroll, resistedScroll)
        
        for behavior in self.animator.behaviors {
            guard let behavior = behavior as? UIAttachmentBehavior,
                let item = behavior.items.first as? UICollectionViewLayoutAttributes else { continue }
            
            let indexPath = resolveIndexPath(for: item, in: collectionView)
            let cellIndex = Float(indexPath.row)
            let delta = CGFloat(actualScroll * (cellIndex - 1) * 2)
            item.center.y += delta
            
            let newBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            self.animator.removeBehavior(behavior)
            self.animator.addBehavior(newBehavior)
        }
        
        return false
    }
}

extension SpringFlowLayout {
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            self.animator.removeAllBehaviors()
            addedBehaviors.forEach { (_, value) in
                self.animator.addBehavior(value)
            }
        default:
            break
        }
    }
    
    private func resolveIndexPath(for item: UICollectionViewLayoutAttributes, in collectionView: UICollectionView) -> IndexPath {
        if item.representedElementKind == UICollectionView.elementKindSectionFooter {
            let lastRow = collectionView.numberOfItems(inSection: 0)
            return IndexPath(row: lastRow, section: 0)
        }
        return item.indexPath
    }
    
    private func stopCellsOnTop() {
        guard let collectionView = self.collectionView else { return }
        
        let contentOffset = collectionView.contentOffset.y + collectionView.contentInset.top
        let contentInset = collectionView.contentInset.top
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let maxInset = contentInset - statusBarHeight
        
        for behavior in self.animator.behaviors {
            guard let behavior = behavior as? UIAttachmentBehavior,
                let item = behavior.items.first as? UICollectionViewLayoutAttributes else { continue }
            
            let indexPath = resolveIndexPath(for: item, in: collectionView)
            
            if contentOffset - maxInset >= item.frame.origin.y {
                if topCellSnapshots[indexPath] == nil,
                    let cell = collectionView.cellForItem(at: indexPath),
                    let snapshot = cell.snapshotView(afterScreenUpdates: false) {
                    snapshot.center = item.center
                    snapshot.frame.origin.y = statusBarHeight
                    topCellSnapshots[indexPath] = snapshot
                    collectionView.superview?.insertSubview(snapshot, belowSubview: collectionView)
                }
                
                item.isHidden = true
            } else if item.isHidden {
                if let snapshot = topCellSnapshots[indexPath] {
                    snapshot.removeFromSuperview()
                    topCellSnapshots.removeValue(forKey: indexPath)
                }
                item.isHidden = false
            }
            self.animator.updateItem(usingCurrentState: item)
        }
    }
}
