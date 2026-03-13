/// Stub for non-web platforms — gtag is not available.
void sendGtagPurchase({
  required String transactionId,
  required double value,
  required String currency,
  required List<Map<String, Object>> items,
}) {}

/// Stub for non-web platforms — sends a generic gtag event.
void sendGtagEvent({
  required String eventName,
  required Map<String, Object> parameters,
}) {}
