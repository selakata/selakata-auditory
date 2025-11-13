import SwiftUI

struct ErrorStateView: View {
    var image: String = "mascot"
    var title: String = "Oops! Something went wrong"
    var description: String = "Please try again later."
    var ctaText: String? = nil
    var onCtaTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            // MARK: - Image
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .padding(.top, 40)

            // MARK: - Title
            Text(title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            // MARK: - Description
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            // MARK: - CTA Button (conditional)
            if let ctaText = ctaText, let onCtaTap = onCtaTap {
                UtilsButton(
                    title: ctaText,
                    variant: .primary,
                    action: onCtaTap
                )
                .padding(.horizontal, 40)
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    VStack(spacing: 40) {
        ErrorStateView()

        ErrorStateView(
            title: "No Internet Connection",
            description: "Please check your connection and try again.",
            ctaText: "Retry",
            onCtaTap: {
                print("Retry tapped")
            }
        )
    }
}
