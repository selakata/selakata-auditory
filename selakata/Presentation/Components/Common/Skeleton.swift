import SwiftUI

struct SkeletonView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 8
    var color: Color = Color.gray.opacity(0.3)
    var blinkOpacity: Double = 0.4
    var animationDuration: Double = 0.8

    @State private var animate = false

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .opacity(animate ? blinkOpacity : 1.0)
            .animation(
                .linear(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            // default (height 16, flexible width)
            SkeletonView()
                .frame(height: 16)

            // fixed width, custom height
            SkeletonView(width: 120, height: 20, cornerRadius: 6)

            // avatar-like circle
            SkeletonView(width: 64, height: 64, cornerRadius: 32)

            // longer line
            SkeletonView(height: 14)
                .frame(maxWidth: 300)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
