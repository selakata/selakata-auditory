//
//  PrivacyNoticeView.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import SwiftUI

struct PrivacyNoticeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("SelaKata is committed to protect your privacy and personal data.")
                
                Text("This Privacy Notice explains how we collect, use, process, and safeguard your information when you use the SelaKata app, particularly features involving AI Auditory Training and Personal Voice Cloning.")
                
                Text("By using SelaKata, you acknowledge that you have read, understood, and agreed to the terms of this Privacy Notice.")
                
                Text("SelaKata is a non-clinical AI-powered auditory training application designed to help individuals with partial hearing loss improve their listening comprehension and cognitive auditory ability through adaptive sound-based exercises that simulate real-life environments and conversations.")

                
                HeadingView(title: "Information We Collect")
                SubHeadingView(title: "a. Voice and Audio Data")
                BulletPointView(text: "Audio samples you voluntarily record for creating your personalized synthetic voice.")
                BulletPointView(text: "Technical metadata (e.g., duration, frequency range, audio quality) required for accurate voice generation.")
                BulletPointView(text: "Your baseline hearing assessment results (PTA/SNR) used to tailor auditory training difficulty.")
                BulletPointView(text: "Your recorded voice data is used solely for training and personalization within SelaKata. It is not used for advertising, commercial purposes, or any unrelated AI training.")

                
                SubHeadingView(title: "b. Account and Profile Information")
                BulletPointView(text: "When you sign in using Apple ID or Google Account, we receive your verified name, email address, and authentication token.")
                BulletPointView(text: "Your account allows us to synchronize your exercise progress and maintain data continuity across devices.")

                
                SubHeadingView(title: "c. Usage and Technical Information")
                BulletPointView(text: "Data about how you use the app (training progress, scores, time spent, exercise frequency).")
                BulletPointView(text: "Device details (model, OS version, app version).")
                BulletPointView(text: "Diagnostic logs and crash reports to help us improve performance and reliability.")
                
                
                SubHeadingView(title: "d. Cloud Data Storage")
                BulletPointView(text: "All user data — including progress history, test results, and personalized voice models — are securely stored and synchronized via Apple CloudKit using encrypted communication channels.")

                
                HeadingView(title: "How We Use Your Information")
                Text("We use your information only for purposes directly related to your use of SelaKata, including:")
                BulletPointView(text: "Generating and maintaining your personalized synthetic voice for auditory training sessions.")
                BulletPointView(text: "Delivering adaptive listening exercises and tracking progress over time.")
                BulletPointView(text: "Improving accuracy, responsiveness, and realism of multi-talker voice simulations.")
                BulletPointView(text: "Ensuring synchronization of your data across signed-in devices.")
                BulletPointView(text: "Conducting anonymized analysis for research and product improvement.")
                BulletPointView(text: "Your voice data will never be used to create general AI models, shared with advertisers, or made publicly available.")
                
                
                HeadingView(title: "Data Retention and Security")
                BulletPointView(text: "Your voice recordings, training history, and hearing assessment data are stored as long as your account remains active.")
                BulletPointView(text: "You may delete your account at any time, and your associated data (including your cloned voice) will be permanently removed within 30 days.")
                BulletPointView(text: "We may retain anonymized, non-identifiable data for statistical analysis and system improvement.")
                BulletPointView(text: "Secure authentication via Apple Sign-In.")
                BulletPointView(text: "Cloud-level encryption and access control through Apple CloudKit.")

                
                HeadingView(title: "Your Rights")
                Text("You have the right to:")
                BulletPointView(text: "Access and review your stored data.")
                BulletPointView(text: "Request correction or deletion of personal data.")
                BulletPointView(text: "Export or permanently delete your data from our systems.")
                
            }
            .padding(.horizontal, 35)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Privacy notice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

private struct HeadingView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2.weight(.bold))
            .padding(.top, 8)
            .foregroundStyle(Color.accent)
    }
}

private struct SubHeadingView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline.weight(.semibold))
    }
}

private struct BulletPointView: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "circle.fill")
                .foregroundStyle(Color.accent)
                .font(.caption)
            Text(text)
        }
        .padding(.leading, 8)
    }
}

#Preview {
    NavigationStack {
        PrivacyNoticeView()
    }
}
