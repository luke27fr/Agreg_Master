/// Stub for non-web platforms — gtag is not available.
void sendGtagPurchase({
  required String transactionId,
  required double value,
  required String currency,
  required List<Map<String, Object>> items,
}) {}
