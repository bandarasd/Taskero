//
//  PrivacyPolicyView.swift
//  Taskero
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode

    private let sections: [(title: String, body: String)] = [
        ("Information We Collect", "We collect information you provide directly to us, including your name, phone number, email address, and location when you use our services. We also collect usage data such as service history, device identifiers, and interaction logs to improve the app experience."),
        ("How We Use Your Information", "Your information is used to provide, personalize, and improve our services; process transactions; send notifications; and ensure platform safety. We do not sell your personal data to third parties."),
        ("Data Sharing", "We share your information only with service providers (workers) as necessary to fulfill your bookings, and with trusted third-party vendors who assist in operating our platform under strict confidentiality agreements."),
        ("Location Data", "We collect precise location data to match you with nearby workers and provide accurate service pricing. You can control location permissions through your device settings."),
        ("Payment Data", "Payment card details are processed by our PCI-DSS compliant payment partners. Taskero does not store your full card numbers on its servers."),
        ("Your Rights", "You have the right to access, correct, or delete your personal data. Contact us at privacy@taskero.com or through the Help Center to exercise your rights."),
        ("Data Retention", "We retain your data for as long as your account is active or as needed to provide services. You can request deletion of your account and associated data at any time."),
        ("Security", "We use industry-standard encryption (TLS 1.3) and security measures to protect your information. However, no system is completely secure, so we cannot guarantee absolute security."),
        ("Changes to This Policy", "We may update this policy periodically. We'll notify you of material changes via email or in-app notification. Continued use of the app after changes constitutes acceptance."),
        ("Contact Us", "For questions about this Privacy Policy, reach us at privacy@taskero.com or through the Help Center in the app.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text("Privacy Policy").font(.headline).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Last updated: January 1, 2026")
                        .font(.caption).foregroundColor(.gray)

                    Text("Taskero respects your privacy. This policy explains what data we collect, how we use it, and your rights regarding your personal information.")
                        .font(.subheadline).foregroundColor(.secondary)

                    ForEach(sections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.subheadline).fontWeight(.bold)
                            Text(section.body)
                                .font(.subheadline).foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
                    }
                    Spacer().frame(height: 80)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

#Preview { PrivacyPolicyView() }
