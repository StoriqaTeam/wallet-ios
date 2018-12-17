//
//  BouncyLayout.swift
//  Wallet
//
//  Created by Storiqa on 10/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable all

import UIKit

class BouncyLayout: UICollectionViewFlowLayout {
    
    enum BounceStyle {
        case subtle
        case regular
        case prominent
        
        var damping: CGFloat {
            switch self {
            case .subtle: return 0.8
            case .regular: return 0.7
            case .prominent: return 0.5
            }
        }
        
        var frequency: CGFloat {
            switch self {
            case .subtle: return 2
            case .regular: return 1.5
            case .prominent: return 1
            }
        }
    }
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    private var damping: CGFloat = BounceStyle.regular.damping
    private var frequency: CGFloat = BounceStyle.regular.frequency
    
    convenience init(style: BounceStyle) {
        self.init()
        
        damping = style.damping
        frequency = style.frequency
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
        itemSize = CGSize(width: 350, height: 240)
    }
    
    override func prepare() {
        super.prepare()
        guard let view = collectionView,
            let attributes = super.layoutAttributesForElements(in: view.bounds)?
                .compactMap({ $0.copy() as? UICollectionViewLayoutAttributes }) else { return }

        oldBehaviors(for: attributes).forEach { animator.removeBehavior($0) }
        newBehaviors(for: attributes).forEach { animator.addBehavior($0, damping, frequency) }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = collectionView else { return false }
        
        animator.behaviors.forEach {
            guard let behavior = $0 as? UIAttachmentBehavior, let item = behavior.items.first else { return }
            update(behavior: behavior, and: item, in: view, for: newBounds)
            animator.updateItem(usingCurrentState: item)
        }
        return view.bounds.width != newBounds.width
    }
    
    func setConfigureFlow(flow: UICollectionViewFlowLayout) {
        self.minimumLineSpacing = flow.minimumLineSpacing
        self.minimumInteritemSpacing = flow.minimumInteritemSpacing
        self.sectionInset = flow.sectionInset
        self.itemSize = flow.itemSize
        self.scrollDirection = flow.scrollDirection
    }
}


// MARK: - Private methods

extension BouncyLayout {
    private func oldBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = attributes.map { $0.indexPath }
        return animator.behaviors.compactMap {
            guard let behavior = $0 as? UIAttachmentBehavior,
                let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else { return nil }
            return indexPaths.contains(itemAttributes.indexPath) ? nil : behavior
        }
    }
    
    private func newBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = animator.behaviors.compactMap {
            (($0 as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath
        }
        return attributes.compactMap {
            indexPaths.contains($0.indexPath) ? nil : UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center.floored())
        }
    }
    
    private func update(behavior: UIAttachmentBehavior, and item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x, dy: bounds.origin.y - view.bounds.origin.y)
        let resistance = CGVector(dx: abs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / 1000,
                                  dy: abs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / 1000)
        
        switch scrollDirection {
        case .horizontal:
            item.center.x += delta.dx < 0 ?
                max(delta.dx, delta.dx * resistance.dx) :
                min(delta.dx, delta.dx * resistance.dx)
        case .vertical:
            item.center.y += delta.dy < 0 ?
                max(delta.dy, delta.dy * resistance.dy) :
                min(delta.dy, delta.dy * resistance.dy)
        }
        
        item.center.flooredInPlace()
    }
    
}


extension UIDynamicAnimator {
    
    open func addBehavior(_ behavior: UIAttachmentBehavior, _ damping: CGFloat, _ frequency: CGFloat) {
        behavior.damping = damping
        behavior.frequency = frequency
        addBehavior(behavior)
    }
}

extension CGPoint {
    
    func floored() -> CGPoint {
        return CGPoint(x: floor(x), y: floor(y))
    }
    
    mutating func flooredInPlace() {
        self = floored()
    }
}
