//
//  IgorDataReturningVC.swift
//  testdataentry1
//
//  Created by Igor Jovcevski on 2.9.22.
//

import Foundation



import UIKit

public protocol VCThatReturnsData {
    var returnValueClosure:((Any)->())? { get set }
}

extension UIViewController {
    private static var fooVCView:UIView? = UIView()
    private static var overlayView:UIView? = UIView()
    private static var dataReturningVCVisible:Bool = false
    
    public    func hideSmartVC(completion:(()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tabBarController?.tabBar.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: {
                UIViewController.overlayView?.alpha = 0.0
                UIViewController.fooVCView?.alpha = 0.0
                
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
                
            }) { (complete) in
                // LETS KEEP THIS FOR FUTURE USE REFERENCE !
                UIViewController.overlayView?.removeFromSuperview()
                UIViewController.dataReturningVCVisible = false
                UIViewController.fooVCView!.removeFromSuperview()
                completion?()
            }
        }
        
    }
    public    func showDataReturningVC(optionsVC:VCThatReturnsData , width:Int, height:Int  , originatingView:UIView?,completion:  ((Any)->())? ) throws {
        
        
     
        
      
        if  UIViewController.dataReturningVCVisible {
            hideSmartVC()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                try!  self.showDataReturningVC(optionsVC: optionsVC, width: width, height:height,originatingView: originatingView, completion: completion)
            }
            return
        }
        var optionsVC = optionsVC
        optionsVC.returnValueClosure = completion
        // setup full screen overlayview - its full screen with black color with some alpha for transparency , will handle the touches to dismiss the bottom view when clicked
        UIViewController.overlayView = UIView(frame: self.view.frame) // make it same size and origin as screen
        UIViewController.overlayView?.backgroundColor = .black // setup background color
        UIViewController.overlayView?.alpha = 0.0 // make alpha 0 to begin with.. when options come out it will be changed
        self.view.addSubview( UIViewController.overlayView!) // add this view to controller main view as subview
        
        UITapGestureRecognizer(addToViewDatareturningVC:  UIViewController.overlayView!) { [self] in // create gesture recognizer for tap and pass it a closure on click
            hideSmartVC()
        }
        var centeredConstraintY: NSLayoutConstraint?
        var centeredConstraintX: NSLayoutConstraint?
        var widthConstraint:NSLayoutConstraint?
        var heightConstraint:NSLayoutConstraint?
        UIViewController.fooVCView = UIView()  // create footer view with 0 size frame
        UIViewController.fooVCView?.alpha = 0.0
        UIViewController.fooVCView?.backgroundColor = .clear // remove back color.. this ill need to be transdparent , so we can have rounded corners working!
        UIViewController.fooVCView?.translatesAutoresizingMaskIntoConstraints = false // get rid of auto  resize mask , we'll go with constraints on this one
        view.addSubview(UIViewController.fooVCView!) // lets also add this base view to controller main view ..its still 0 size !
        // lets define its frame thru constraints!
        
        // this may be tricky !! the view may be subview of another view.. we need the frame in common view!! self.view
        
        if let originatingView = originatingView {
            
            let  originatingViewFrame = self.view.convert(originatingView.frame, from: originatingView.superview)
            //            print("originatingViewFrame converted frame ",originatingViewFrame)
            //            print("originatingView original frame",originatingView.frame)
            widthConstraint = UIViewController.fooVCView?.widthAnchor.constraint(equalToConstant: originatingView.frame.width)
            heightConstraint = UIViewController.fooVCView?.heightAnchor.constraint(equalToConstant: originatingView.frame.height)
            centeredConstraintX = UIViewController.fooVCView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: originatingViewFrame.origin.x)
            centeredConstraintY = UIViewController.fooVCView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: originatingViewFrame.origin.y)
            widthConstraint?.isActive = true
            heightConstraint?.isActive = true
            centeredConstraintX?.isActive = true
            centeredConstraintY?.isActive = true
            
        }
        //track of this constraint for future reference ! when we will hide it we need this
        self.configureChildViewControllerForDataReturningVC(childController: optionsVC as! UIViewController, onView: UIViewController.fooVCView)
        // lets go back to our optionsVC which will be added as child , plus its view as subview of the FOOTER which we created above !!!!
        self.tabBarController?.tabBar.isHidden = true // since in TB we use tabs on bottom, we need to hide them when showing our footer!
        self.view.bringSubviewToFront(UIViewController.fooVCView!)
        self.view.layoutIfNeeded()
        // lets animate our top constraint which for now is touching the bottom.. it will be changed and animated as per options count !!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            heightConstraint?.constant = CGFloat(height)
            widthConstraint?.constant = CGFloat(width)
            centeredConstraintY?.constant = (self.view.frame.size.height  - CGFloat(height) ) / 2
            centeredConstraintX?.constant = (self.view.frame.size.width  - CGFloat(width) ) / 2
            UIView.animate(withDuration:0.35 , delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: {
                UIViewController.overlayView?.alpha = 0.3
                UIViewController.fooVCView?.alpha = 1.0
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
                
            }) { (complete) in
                UIViewController.dataReturningVCVisible = true
                // lets change this so we know the state in future!!!
                //                       self.optionsDidOpen?()
                
            }
        }
    }
}

extension UIViewController {
    func configureChildViewControllerForDataReturningVC(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqualDataReturningVC(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
    }
    
    
    func constrainViewEqualDataReturningVC(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}




extension UIGestureRecognizer {
    @discardableResult convenience init(addToViewDatareturningVC targetView: UIView,
                                        closure: @escaping () -> Void) {
        self.init()
        
        GestureTargetDataReturningVC.add(gesture: self,
                                         closure: closure,
                                         toView: targetView)
    }
}

fileprivate class GestureTargetDataReturningVC: UIView {
    class ClosureContainer {
        weak var gesture: UIGestureRecognizer?
        let closure: (() -> Void)
        
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
    }
    
    var containers = [ClosureContainer]()
    
    convenience init() {
        self.init(frame: .zero)
        isHidden = true
    }
    
    class func add(gesture: UIGestureRecognizer, closure: @escaping () -> Void,
                   toView targetView: UIView) {
        let target: GestureTargetDataReturningVC
        if let existingTarget = existingTarget(inTargetView: targetView) {
            target = existingTarget
        } else {
            target = GestureTargetDataReturningVC()
            targetView.addSubview(target)
        }
        let container = ClosureContainer(closure: closure)
        container.gesture = gesture
        target.containers.append(container)
        
        gesture.addTarget(target, action: #selector(GestureTargetDataReturningVC.target(gesture:)))
        targetView.addGestureRecognizer(gesture)
    }
    
    class func existingTarget(inTargetView targetView: UIView) -> GestureTargetDataReturningVC? {
        for subview in targetView.subviews {
            if let target = subview as? GestureTargetDataReturningVC {
                return target
            }
        }
        return nil
    }
    
    func cleanUpContainers() {
        containers = containers.filter({ $0.gesture != nil })
    }
    
    @objc func target(gesture: UIGestureRecognizer) {
        cleanUpContainers()
        
        for container in containers {
            guard let containerGesture = container.gesture else {
                continue
            }
            
            if gesture === containerGesture {
                container.closure()
            }
        }
    }
}
