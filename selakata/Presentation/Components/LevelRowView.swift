import SwiftUI

struct LevelRowView: View {
    let level: Level
    let moduleLabel: String

    var questionCategory: QuestionCategory {
        switch moduleLabel {
        case "identification":
            return .identification
        case "discrimination":
            return .discrimination
        case "comprehension":
            return .comprehension
        case "competing_speaker":
            return .competingSpeaker
        default:
            return .identification
        }
    }

    var body: some View {
        NavigationLink{
            QuizView(levelId: level.id)
        }label: {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 2, height: 32)
                        .offset(y: -32)
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 2, height: 32)
                        .offset(y: 32)
                    Circle()
                        .fill(.primary)
                        .frame(width: 18, height: 18).padding(16)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8).padding(16)
                }.frame(maxWidth: 24)

                Spacer().frame(width: 8)

                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(level.isActive ? Color.white : Color.gray)
                            .frame(width: 50, height: 50)

                        if level.isActive {
                            Image(systemName: "play.fill")
                                .foregroundColor(.primary)
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }

                    Text(level.label)
                        .font(.app(.headline))
                        .bold()
                        .foregroundColor(Color.white)

                    Spacer()
                }
                .frame(maxHeight: 75)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.primary)
                )
            }

        }
    }
}
//
//#Preview {
//    VStack(spacing: 12) {
//        LevelRowView(
//            level: QuizData.dummyModule[0].levelList[0],
//            moduleLabel: "Identification"
//        )
//    }
//    .padding()
//}
