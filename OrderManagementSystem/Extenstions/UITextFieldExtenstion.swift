//
//  UITextFieldExtenstion.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    func addPreviousNextDoneToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil, onNext: (target: Any, action: Selector)? = nil, onPrevious: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let onNext = onNext ?? (target: self, action: #selector(onNextButtonTapped))
        let onPrevious = onPrevious ?? (target: self, action: #selector(onPreviousButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Previous", style: .plain, target: onNext.target, action: onPrevious.action),
            UIBarButtonItem(title: "Next", style: .plain, target: onNext.target, action: onNext.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    @objc func onNextButtonTapped() {
        
        let nextTag = self.tag + 1
        
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes
            {
                if scene.activationState == .foregroundActive
                {
                    let rootVC = ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window!!.rootViewController
                    if let viewController = rootVC?.presentedViewController {
                        if let nextResponder = viewController.view.viewWithTag(nextTag){
                            nextResponder.becomeFirstResponder()
                        }
                    } else {
                        if let nextResponder = rootVC?.view.viewWithTag(nextTag){
                            nextResponder.becomeFirstResponder()
                        }
                    }
                }
            }
        } else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view.viewWithTag(nextTag)?.becomeFirstResponder()
        }
    }
    
    @objc func onPreviousButtonTapped() {
        let nextTag = self.tag - 1
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes
            {
                if scene.activationState == .foregroundActive
                {
                    let rootVC = ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window!!.rootViewController
                    if let viewController = rootVC?.presentedViewController {
                        if let previousResponder = viewController.view.viewWithTag(nextTag){
                            previousResponder.becomeFirstResponder()
                        }
                    } else {
                        if let previousResponder = rootVC?.view.viewWithTag(nextTag){
                            previousResponder.becomeFirstResponder()
                        }
                    }
                }
            }
        } else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view.viewWithTag(nextTag)?.becomeFirstResponder()
        }

    }

}
