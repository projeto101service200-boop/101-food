# Velox Delivery Platform

A high-performance, multivendor delivery platform built with React, Vite, and Firebase. This platform is organized into 4 main modules to handle the entire delivery lifecycle.

## Modules

1. **Customer App (`/customer`)**
   - Location-based restaurant discovery.
   - Menu browsing and product selection.
   - Real-time cart management and order placement.
   - Order tracking and rider status.

2. **Restaurant Vendor App (`/restaurant`)**
   - Order management dashboard (New, Preparing, Ready).
   - Kitchen workflow optimization.
   - Menu and availability management.
   - Store status control (Open/Closed).

3. **Rider App (`/rider`)**
   - Online/Offline toggle for delivery requests.
   - Live navigation and pickup/delivery flows.
   - Earnings tracking and delivery history.
   - In-app communication with customers and vendors.

4. **Admin Web Dashboard (`/admin`)**
   - Platform-wide analytics and revenue tracking.
   - Vendor and Rider approval queue.
   - Global user management.
   - System settings and delivery fee configurations.

## Tech Stack

- **Frontend:** React 19, Vite, Tailwind CSS 4.
- **Backend:** Firebase (Firestore, Auth, Storage).
- **Animation:** Motion (framer-motion).
- **Charts:** Recharts (D3-powered).
- **Icons:** Lucide React.

## Setup Instructions

1. **Environment Variables**:
   Copy `.env.example` to `.env` and fill in your Firebase credentials.
   ```env
   VITE_FIREBASE_API_KEY=...
   VITE_FIREBASE_AUTH_DOMAIN=...
   VITE_FIREBASE_PROJECT_ID=...
   ```

2. **Firebase Rules**:
   Ensure `firestore.rules` are deployed to your Firebase project.

3. **Running the App**:
   ```bash
   npm install
   npm run dev
   ```

4. **Access Modules**:
   Open the development URL and use the **Module Selector** landing page to switch between the different stakeholder views.

## Security

The platform uses **Hardened Firestore Rules** implementing:
- Attribute-Based Access Control (ABAC).
- Action-based update patterns with `affectedKeys()`.
- Identity verification via Firebase Auth claims.
- Strict size and type validation on all writes.
