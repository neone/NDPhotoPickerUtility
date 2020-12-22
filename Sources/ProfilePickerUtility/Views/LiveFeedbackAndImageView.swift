//
//  LiveFeedbackAndImageView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI

struct LiveFeedbackAndImageView: View {
    @Binding var finalAmount: CGFloat
    @Binding var inputW: CGFloat
    @Binding var inputH: CGFloat
    @Binding var profileW: CGFloat
    @Binding var profileH: CGFloat
    @Binding var newPosition: CGSize
    
    var body: some View {
        VStack {
            Text("zoom:\(finalAmount, specifier: "%.2f")")
            Text("Input: \(inputW, specifier: "%.2f") x \(inputH, specifier: "%.2f")")
            Text("Profile: \(profileW, specifier: "%.2f") x \(profileH, specifier: "%.2f")")
            Text("Offset x: \(newPosition.width, specifier: "%.2f") y: \(newPosition.height, specifier: "%.2f")")
        }
        .foregroundColor(.systemYellow)
        .padding(.top, 50)
    }
}

struct LiveFeedbackAndImageView_Previews: PreviewProvider {
    static var previews: some View {
        LiveFeedbackAndImageView(finalAmount: .constant(0.0), inputW: .constant(0.0), inputH: .constant(0.0), profileW: .constant(0.0), profileH: .constant(0.0), newPosition: .constant(CGSize(width: 0.0, height: 0.0)))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .background(Color(.darkGray))
            .environment(\.colorScheme, .dark)
    }
}
