//
//  ReminderCard.swift
//  selakata
//
//  Created by Anisa Amalia on 19/10/25.
//

import SwiftUI

struct ReminderCard: View {
    var body: some View {
        HStack(spacing: 16) {
            // icon
            Image(systemName: "bell.fill")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            // reminder
            VStack(alignment: .leading) {
                Text("Daily reminder!")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Don't forget to do your 15-minute auditory training today 👂✨")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
    }
}

