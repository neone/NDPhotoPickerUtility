//
//  ShowPhotoPickerButton.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI

struct ShowPhotoPickerButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.custom("system", size: 45))
                .opacity(0.9)
                .foregroundColor(.white)
            
            Image(systemName: "photo.on.rectangle")
                .imageScale(.medium)
                .foregroundColor(.black)
        }
    }
}

struct ShowPhotoPickerButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowPhotoPickerButton()
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .background(Color(.darkGray))
            .environment(\.colorScheme, .dark)
    }
}
