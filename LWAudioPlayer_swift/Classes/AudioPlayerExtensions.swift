//
// AudioPlayerExtensions.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import UIKit

// MARK: - UIImage Extensions

public extension UIImage {

    /// Apply overlay color to image
    func withOverlayColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: size))

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - UIView Extensions

public extension UIView {

    /// Find superview of specified class type
    func superView<T: UIView>(ofType type: T.Type) -> T? {
        var responder: UIResponder? = self
        while let current = responder {
            if let view = current as? T {
                return view
            }
            responder = current.next
        }
        return nil
    }

    /// Handle rotation to interface orientation
    func rotationToInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        for subview in subviews {
            subview.rotationToInterfaceOrientation(orientation)
        }
    }
}

// MARK: - UIResponder Extensions

public extension UIResponder {

    /// Find responder of specified class type
    func responder<T: UIResponder>(ofType type: T.Type) -> T? {
        var responder: UIResponder? = self
        while let current = responder {
            if let found = current as? T {
                return found
            }
            responder = current.next
        }
        return nil
    }
}
