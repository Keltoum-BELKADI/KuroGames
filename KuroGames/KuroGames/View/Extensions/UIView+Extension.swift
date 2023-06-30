//
//  UIView+Extension.swift
//  MyGameStore
//
//  Created by Kel_Jellysh on 07/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: COnstraints of GifImage
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
    }
    
    //MARK: methods to add Gradient Layer
    func addGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = colors.map{$0.cgColor}
        gradient.locations = [0.5,1]
        self.layer.sublayers?.removeAll()
        gradient.removeFromSuperlayer()
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    //the size adapts according to the device
    func sizeWithTheDevice() -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 200
        case .pad:
            return 300
        case .unspecified:
            return 200
        default:
            break
        }
        return 200
    }
    //MARK: AddShadow
    func setUpShadow(color: CGColor, cell: UIView, width: CGFloat, height: CGFloat) {
        cell.layer.shadowOpacity = 1
        cell.layer.shadowColor = color
        cell.layer.shadowOffset = CGSize(width: width, height: height)
        cell.layer.shadowRadius = 5
    }
    
    //MARK: UIConstraints
    func backgroundImage(view: UIView, multiplier: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: view.widthAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: multiplier),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
 
    func tableViewConstraints(view: UIView, constant: CGFloat ) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    func addGameStackConstraints(view: UIView){
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    func addLoaderConstraints(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}

