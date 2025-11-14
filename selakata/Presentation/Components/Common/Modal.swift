import SwiftUI

struct Modal: View {
    var image: Image
    var title: String
    var description: String
    var ctaText: String? = nil
    var onCtaTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 12)

                // TITLE
                VStack(spacing: 12) {
                    Text(title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    if !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }

                if let cta = ctaText, let action = onCtaTap {
                    Button(action: action) {
                        Text(cta)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.Primary._500)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }

            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal, 32)
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: true)
    }
}


#Preview {
    ZStack {
        Modal(
            image: Image("mascot"),
            title: "Complete Previous Module",
            description: "Finish the previous module to unlock this one!",
            ctaText: "Continue",
            onCtaTap: {}
        )
    }
}
