import 'dart:js_interop';

@JS('gtag')
external void _gtag(JSString command, JSString eventName, JSAny params);

@JS('JSON.parse')
external JSAny _jsonParse(JSString json);

void sendGtagPurchase({
  required String transactionId,
  required double value,
  required String currency,
  required List<Map<String, Object>> items,
}) {
  final itemsJson = StringBuffer('[');
  for (var i = 0; i < items.length; i++) {
    if (i > 0) itemsJson.write(',');
    final item = items[i];
    itemsJson.write('{');
    itemsJson.write('"item_id":"${item['item_id']}",');
    itemsJson.write('"item_name":"${item['item_name']}",');
    itemsJson.write('"price":${item['price']},');
    itemsJson.write('"currency":"${item['currency']}",');
    itemsJson.write('"quantity":${item['quantity']}');
    itemsJson.write('}');
  }
  itemsJson.write(']');

  final json = '{'
      '"transaction_id":"$transactionId",'
      '"value":$value,'
      '"currency":"$currency",'
      '"items":${itemsJson.toString()}'
      '}';

  _gtag('event'.toJS, 'purchase'.toJS, _jsonParse(json.toJS));
}
