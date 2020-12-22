//
//  ProfilePickerExtensions.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import Foundation
import SwiftUI

extension PhotoPickerUtility {
    
    //MARK: functions
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let w = inputImage.size.width
        let h = inputImage.size.height
        profileImage = Image(uiImage: inputImage)
        
        inputW = w//.description
        inputH = h//.description
        theAspectRatio = w / h
        
        resetImageOriginAndScale()
    }
    
    func resetImageOriginAndScale() {
        
        withAnimation(.easeInOut){
            if theAspectRatio > screenAspect {
                profileW = UIScreen.main.bounds.width
                profileH = profileW / theAspectRatio
            } else {
                profileH = UIScreen.main.bounds.height
                profileW = profileH * theAspectRatio
            }
            currentAmount = 0
            finalAmount = 1
            currentPosition = .zero
            newPosition = .zero
            
        }
    }
    
    func HoleShapeMask() -> Path {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let insetRect = CGRect(x: inset, y: inset, width: UIScreen.main.bounds.width - ( inset * 2 ), height: UIScreen.main.bounds.height - ( inset * 2 ))
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: insetRect))
        return shape
    }
    
    
    func repositionImage() {
        
        //Screen width
        let w = UIScreen.main.bounds.width
        
        if theAspectRatio > screenAspect {
            profileW = UIScreen.main.bounds.width * finalAmount
            profileH = profileW / theAspectRatio
        } else {
            profileH = UIScreen.main.bounds.height * finalAmount
            profileW = profileH * theAspectRatio
        }
        
        //Screen width * zoom - the screen width / 2
        //shows us how much of the picture now extends t pothe left of the screen.
        horizontalOffset = (profileW - w ) / 2
        verticalOffset = ( profileH - w ) / 2
        
        if finalAmount > 4.0 {
            withAnimation{
                finalAmount = 4.0
            }
        }
        
        if profileW >= UIScreen.main.bounds.width {
            
            if newPosition.width > horizontalOffset {
                withAnimation(.easeInOut) {
                    newPosition = CGSize(width: horizontalOffset + inset, height: newPosition.height)
                    currentPosition = CGSize(width: horizontalOffset + inset, height: currentPosition.height)
                }
            }
            
            if newPosition.width < ( horizontalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: ( horizontalOffset * -1) - inset, height: newPosition.height)
                    currentPosition = CGSize(width: ( horizontalOffset * -1 - inset), height: currentPosition.height)
                }
            }
        } else {
            
            withAnimation(.easeInOut) {
                newPosition = CGSize(width: 0, height: newPosition.height)
                currentPosition = CGSize(width: 0, height: newPosition.height)
            }
        }
        
        if profileH >= UIScreen.main.bounds.width {
            
            if newPosition.height > verticalOffset {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                    currentPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                }
            }
            
            if newPosition.height < ( verticalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                    currentPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                }
            }
        } else {
            
            withAnimation (.easeInOut){
                newPosition = CGSize(width: newPosition.width, height: 0)
                currentPosition = CGSize(width: newPosition.width, height: 0)
            }
        }
        
        if profileW < UIScreen.main.bounds.width && theAspectRatio > screenAspect {
            resetImageOriginAndScale()
        }
        if profileH < UIScreen.main.bounds.height && theAspectRatio < screenAspect {
            resetImageOriginAndScale()
        }
    }
    
    func saveCroppedImage() {
        
        let scale = (inputImage?.size.width)! / profileW
        
        let xPos = ( ( ( profileW - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.width * -1 ) ) * scale
        let yPos = ( ( ( profileH - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.height * -1 ) ) * scale
        let radius = ( UIScreen.main.bounds.width - inset * 2 ) * scale
        
        croppedImage = Image(uiImage: imageWithImage(image: inputImage!, croppedTo: CGRect(x: xPos, y: yPos, width: radius, height: radius)))
        
        
        ///Debug maths
        print("Input: w \(inputW) h \(inputH)")
        print("Profile: w \(profileW) h \(profileH)")
        print("X Origin: \( ( ( profileW - UIScreen.main.bounds.width - inset ) / 2 ) + ( currentPosition.width  * -1 ) )")
        print("Y Origin: \( ( ( profileH - UIScreen.main.bounds.width - inset) / 2 ) + ( currentPosition.height  * -1 ) )")
        
        print("Scale: \(scale)")
        print("Profile:\(profileW) + \(profileH)" )
        print("Curent Pos: \(currentPosition.debugDescription)")
        print("Radius: \(radius)")
        print("x:\(xPos), y:\(yPos)")
    }
}
