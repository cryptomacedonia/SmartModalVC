//
//  IgorBottomOptions.swift
//  templates1
//
//  Created by Igor Jovcevski on 23.7.22.
//

import Foundation
import UIKit

extension UIView { // experimental
    
    func allConstraints()->[NSLayoutConstraint] {
        
        var views = [self]
        var view = self
        while let superview = view.superview {
            
            views.append(superview)
            view = superview
        }
        
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
            constraint.secondItem as? UIView == self
        }
    }
    
    func widthAsPointsConstraints()->[NSLayoutConstraint] {
        
        return self.allConstraints()
            .filter({
                ( $0.firstItem as? UIView == self && $0.secondItem == nil )
            })
            .filter({
                $0.firstAttribute == .width && $0.secondAttribute == .notAnAttribute
            })
    }
    
    func widthAsFractionOfAnotherViewConstraints()->[NSLayoutConstraint] {
        
        func _bothviews(_ c: NSLayoutConstraint)->Bool {
            if c.firstItem == nil { return false }
            if c.secondItem == nil { return false }
            if !c.firstItem!.isKind(of: UIView.self) { return false }
            if !c.secondItem!.isKind(of: UIView.self) { return false }
            return true
        }
        
        func _ab(_ c: NSLayoutConstraint)->Bool {
            return _bothviews(c)
            && c.firstItem as? UIView == self
            && c.secondItem as? UIView != self
            && c.firstAttribute == .width
        }
        
        func _ba(_ c: NSLayoutConstraint)->Bool {
            return _bothviews(c)
            && c.firstItem as? UIView != self
            && c.secondItem as? UIView == self
            && c.secondAttribute == .width
        }
        
        // note that .relation could be anything: and we don't mind that
        
        return self.allConstraints()
            .filter({ _ab($0) || _ba($0) })
    }
    
    func xPositionConstraints()->[NSLayoutConstraint] {
        
        return self.allConstraints()
            .filter({
                return $0.firstAttribute == .centerX || $0.secondAttribute == .centerX
            })
    }
}

extension NSLayoutConstraint {
    
    // typical routine to "change" multiplier fraction...
    
    @discardableResult
    func changeToNewConstraintWith(multiplier:CGFloat) -> NSLayoutConstraint {
        
        //NSLayoutConstraint.deactivate([self])
        self.isActive = false
        
        let nc = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        nc.priority = priority
        nc.shouldBeArchived = self.shouldBeArchived
        nc.identifier = self.identifier
        
        //NSLayoutConstraint.activate([nc])
        nc.isActive = true
        return nc
    }
}

public struct BottomSheetOptionsStruct {
  public  let title:String
  public  let icon:String
  public  let action:((String)->())?
    public init(title:String, icon:String, action: ((String)->())?) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    
}
extension UIViewController {
    
    
    private static var footer:UIView? = UIView()
    private static var overlayView:UIView? = UIView()
    private static var optionsVisible:Bool = false

 public   func hideOptions(completion:@escaping  ()->()){
        var topConstraint: NSLayoutConstraint?
        //let footer = self.view.viewWithTag(922062922062)
        // print(  footer?.allConstraints())
        topConstraint =  UIViewController.footer?.allConstraints().filter {$0.identifier == "OptionsFooter"}.first
        topConstraint?.isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //            self.tabBarController?.tabBar.layer.zPosition = 0
            self.tabBarController?.tabBar.isHidden = false
            topConstraint?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: {
                UIViewController.overlayView?.alpha = 0.0
                /// Introduces half alpha and forces a layout pass
                //                       backgroundView.alpha = 0.5
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
                
            }) { (complete) in
                UIViewController.overlayView?.removeFromSuperview()
                UIViewController.optionsVisible = false
                //                       topConstraint?.isActive = false
                UIViewController.footer!.removeFromSuperview()
                completion()
                
                //                       self.optionsDidOpen?()
                
            }
        }
        
    }
 public   func hideOptions() {
        var topConstraint: NSLayoutConstraint?
        //let footer = self.view.viewWithTag(922062922062)
        // print(  footer?.allConstraints())
        topConstraint =  UIViewController.footer?.allConstraints().filter {$0.identifier == "OptionsFooter"}.first
        // LETS FIND OUR FOOTER VIEW TOP CONSTRAINT WHICH WILL HAVE TO BE BROUGHT BACK TO TOUCHING THE BOTTOM AGAIN!
        topConstraint?.isActive = true
        // LETS ANIMATE THAT MOVE
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //            self.tabBarController?.tabBar.layer.zPosition = 0
            self.tabBarController?.tabBar.isHidden = false
            topConstraint?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: {
                UIViewController.overlayView?.alpha = 0.0
                
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
                
            }) { (complete) in
                // LETS KEEP THIS FOR FUTURE USE REFERENCE !
                UIViewController.overlayView?.removeFromSuperview()
                UIViewController.optionsVisible = false
                //                       topConstraint?.isActive = false
                UIViewController.footer!.removeFromSuperview()
                
                
              
                
            }
        }
        
    }
    
    
  public  func showWithOptions(optionsVC:OptionsCompatibleVC? = nil,headerLabel:String? =  nil,options:[BottomSheetOptionsStruct]) {
        
        if  UIViewController.optionsVisible {
            hideOptions()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showWithOptions(optionsVC: optionsVC, options: options)
            }
            return
        }
        
        
        // setup full screen overlayview - its full screen with black color with some alpha for transparency , will handle the touches to dismiss the bottom view when clicked
        
        UIViewController.overlayView = UIView(frame: self.view.frame) // make it same size and origin as screen
        UIViewController.overlayView?.backgroundColor = .black // setup background color
        UIViewController.overlayView?.alpha = 0.0 // make alpha 0 to begin with.. when options come out it will be changed
        self.view.addSubview( UIViewController.overlayView!) // add this view to controller main view as subview
        UITapGestureRecognizer(addToView:  UIViewController.overlayView!) { [self] in // create gesture recognizer for tap and pass it a closure on click
            hideOptions()
        }
        
        
        
        
        
      var optionsVC = optionsVC ?? IgorBottomSheetOptionsController.loadFromNibBottomMenu() // load custom vc which holds the tableview .. or it could be anything else if needed to be changed or used in another app
      if let tableView  = (optionsVC as? UIViewController)!.view.findViewsPod(subclassOf: UITableView.self).first {
            
          if (min(CGFloat(65 * options.count + 90 ), 500.0)) == 500.0 {
              tableView.isScrollEnabled = true
          }
          else {
              tableView.isScrollEnabled = false
          }
            
          
      }
        var topConstraint: NSLayoutConstraint?
      (optionsVC as? IgorBottomSheetOptionsController)?.headerLabel.text = headerLabel
        optionsVC.options = options
        UIViewController.footer = UIView()  // create footer view with 0 size frame
        UIViewController.footer?.backgroundColor = .clear // remove back color.. this ill need to be transdparent , so we can have rounded corners working!
        UIViewController.footer?.translatesAutoresizingMaskIntoConstraints = false // get rid of auto  resize mask , we'll go with constraints on this one
        view.addSubview(UIViewController.footer!) // lets also add this base view to controller main view ..its still 0 size !
      // lets define its frame thru constraints!
      UIViewController.footer?.heightAnchor.constraint(equalToConstant: min(CGFloat(65 * options.count + 90 ), 500.0)).isActive = true // HEIGHT DEPENDS ON THE NUMBER OF OPTIONS PASSED!
        UIViewController.footer?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true // leading on the left is attached to 0 left position on main view
        UIViewController.footer?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true // trailing on the right is attached to 0 right position on main view
        topConstraint =  UIViewController.footer?.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        // top constraint will change in time, to start with its setup to touch the bottom of the screen , thus still invisible to user!!!
        topConstraint?.isActive = true
        topConstraint?.identifier = "OptionsFooter" // lets keep track of this constraint for future reference ! when we will hide it we need this
      
      self.configureChildViewControllerForBottomMenu(childController: optionsVC as! UIViewController, onView: UIViewController.footer)
      // lets go back to our optionsVC which will be added as child , plus its view as subview of the FOOTER which we created above !!!!
        self.tabBarController?.tabBar.isHidden = true // since in TB we use tabs on bottom, we need to hide them when showing our footer!
        self.view.bringSubviewToFront(UIViewController.footer!)
        self.view.layoutIfNeeded()
        //        print(footer.frame)
        
        // lets animate our top constraint which for now is touching the bottom.. it will be changed and animated as per options count !!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            topConstraint!.constant = -min(CGFloat(65 * options.count + 90 ), 500.0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, animations: {
                UIViewController.overlayView?.alpha = 0.3
                // lets bring the overlay alpha ON!!!
                /// Introduces half alpha and forces a layout pass
                //                       backgroundView.alpha = 0.5
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
                
            }) { (complete) in
                UIViewController.optionsVisible = true
                // lets change this so we know the state in future!!!
                //                       self.optionsDidOpen?()
                
            }
        }
    }
}

extension UIViewController {
    func configureChildViewControllerForBottomMenu(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
    }
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        let container = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height), size: CGSize(width: self.view.frame.width, height: 300)))
        
        
        //pin 100 points from the top of the super
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

extension UIViewController {
    static func loadFromNibBottomMenu() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle:  Bundle(for: IgorBottomSheetOptionsController.self))
        }
        
        return instantiateFromNib()
    }
    
    
}
extension UIView {
    func findViewsPod<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}

class CustomFooter:UIView {
    
}
