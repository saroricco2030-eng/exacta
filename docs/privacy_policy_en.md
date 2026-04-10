# Exacta Privacy Policy

**Last updated: April 10, 2026**

Exacta ("the App") values user privacy. This policy clearly explains how the App handles user information.

## 1. Core Principle: Fully Local Storage

The App **does not transmit a single byte of user data to any external server**. All photos, memos, GPS coordinates, project information, and hash chains captured by users are stored only in the device's internal storage.

The App does NOT use:
- User accounts / sign-up / login
- Backend servers / cloud sync
- Advertising SDKs / trackers / analytics tools
- Third-party data sharing or sale

## 2. Information Collected (Stored Only on Device)

With user consent, the App processes the following information only on the device:

### 2-1. Camera Data
- **Purpose**: Photo and video capture
- **Storage Location**: Device internal storage (`/Android/data/com.exacta.app/`)
- **External Transmission**: None

### 2-2. Location Information (Optional)
- **Purpose**: Burn GPS coordinates and address into photo stamps
- **Storage Location**: Inside photo pixels + device SQLite DB
- **External Transmission**: None
- **Note**: When Secure Capture mode is enabled, no location information is collected or stored.

### 2-3. Photo Library Access
- **Purpose**: Select logo image for stamps; optionally add captured photos to the system gallery
- **External Transmission**: None

### 2-4. Microphone (Video Capture Only)
- **Purpose**: Record audio for videos
- **Storage Location**: Embedded only in the video file on the device
- **External Transmission**: None

## 3. When You Explicitly Share

User data leaves the device only in these cases:
- Tap "Share" button → user-selected app (KakaoTalk, Email, Messages, etc.)
- "Export" menu → ZIP/PDF file generated, user chooses where to save

In all such cases, the system share sheet is involved and the App never transmits anything autonomously.

## 4. Data Retention and Deletion

- All data remains on the device until the user explicitly deletes it within the App.
- Uninstalling the App immediately deletes all photos, metadata, and hash chains from the device.
- The App imposes no data retention period; the user is the sole owner of their data.

## 5. Children's Privacy

The App is not directed at children under 13 and does not knowingly collect personal information from children.

## 6. Security

The App applies the following security measures:
- Code obfuscation (release build)
- ProGuard / R8 code shrinking
- Secure Capture mode: complete EXIF location stripping + separate folder isolation
- Photo integrity verification via SHA-256 hash chain
- NTP time sync to prevent device clock manipulation

## 7. User Rights

You may at any time:
- Delete photos directly within the App
- Uninstall the App to permanently erase all data
- Revoke any granted permissions in your system settings

## 8. Changes to This Policy

This policy may be updated. The "Last updated" date at the top of this page reflects the latest revision.

## 9. Contact

For questions about this privacy policy:
- GitHub Issues: https://github.com/saroricco2030-eng/exacta/issues

---

*Exacta v1.7.0 — saroricco2030-eng*
