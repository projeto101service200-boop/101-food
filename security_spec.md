# Security Specification: Velox Delivery

## 1. Data Invariants
- An Order cannot exist without a `customerId` mapping to the authenticated user.
- A Product can only be created/edited by the `ownerId` of the associated Restaurant.
- A Rider can only update the status of an Order to 'delivering' or 'delivered' if they are assigned as the `riderId`.
- Admin fields (like `role` or `status`) cannot be modified by the user themselves.

## 2. The "Dirty Dozen" Payloads (Red Team Test)

### P1: Identity Spoofing (Create User as Admin)
```json
{
  "uid": "victim_uid",
  "role": "admin",
  "status": "active"
}
```
**Expected:** PERMISSION_DENIED (Users cannot set their own role or other's role).

### P2: Price Manipulation (Update Order Total)
```json
{
  "total": 0.01
}
```
**Expected:** PERMISSION_DENIED (Order totals are immutable or managed by backend).

### P3: Status Hijack (Customer updates order to 'delivered')
```json
{
  "status": "delivered"
}
```
**Expected:** PERMISSION_DENIED (Only riders/restaurant can update status to 'delivered').

### P4: Cross-Restaurant Product Edit
```json
{
  "restaurantId": "other_restaurant_id",
  "price": 1.00
}
```
**Expected:** PERMISSION_DENIED (Product edits restricted to restaurant owner).

### P5: Massive String Injection (Resource Poisoning)
```json
{
  "name": "A".repeat(1000000)
}
```
**Expected:** PERMISSION_DENIED (Size limits enforced on all strings).

### P6: Unauthorized Order View (Global Scannability)
```json
// Query: db.collection('orders').get()
```
**Expected:** PERMISSION_DENIED (Queries must be restricted by customerId, restaurantId, or riderId).

### P7: Ghost Field Injection (Shadow Update)
```json
{
  "isVerified": true,
  "bypassPayment": true
}
```
**Expected:** PERMISSION_DENIED (Strict key validation in `affectedKeys().hasOnly()`).

### P8: Orphaned Order (Missing Restaurant)
```json
{
  "restaurantId": "non_existent_id",
  "total": 50.0
}
```
**Expected:** PERMISSION_DENIED (Relational existence check via `exists()`).

### P9: PII Disclosure (Read Private User Data)
```json
// Path: /users/other_user_id
```
**Expected:** PERMISSION_DENIED (Users can only read their own profile).

### P10: Unauthorized Rider Assignment
```json
{
  "riderId": "attacker_uid"
}
```
**Expected:** PERMISSION_DENIED (Assignment only via admin or auto-assign logic).

### P11: Expired Coupon usage
```json
{
  "couponId": "expired_id"
}
```
**Expected:** PERMISSION_DENIED (Validation helper checks temporal bounds).

### P12: Self-Promotion (Updating role to "rider" or "restaurant")
```json
{
  "role": "rider"
}
```
**Expected:** PERMISSION_DENIED (Roles are immutable via client).

## 3. Test Runner (Draft)
A `firestore.rules.test.ts` will be implemented to verify these.
