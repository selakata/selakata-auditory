//
//  LevelView.swift
//  selakata
//
//  Created by ais on 10/11/25.
//

import SwiftUI

struct LevelView: View {
    let levels: [LevelData]
    let moduleLabel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Exercises")
                    .font(.app(.headline))
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Image(systemName: "folder")
                    Text("\(levels.count) Levels")
                        .font(.app(.body))
                }
                .foregroundStyle(Color.green)
            }
            
            ForEach(levels) { level in
                LevelRowView(
                    level: level,
                    moduleLabel: moduleLabel
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

//#Preview {
//    LevelView(
//        levels: LevelData.dummyList,
//        moduleLabel: "Matematika"
//    )
//}
