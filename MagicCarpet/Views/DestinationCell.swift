//
//  DestinationCell.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI

struct DestinationCell: View {
    let destination: Destination
    
    var body: some View {
        HStack {
            AppetizerRemoteImage(urlString: destination.imgURL)
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                Text(destination.city)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(destination.state)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .padding(.leading)
        }
    }
}

