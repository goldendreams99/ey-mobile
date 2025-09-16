part of employ.provider;

class Performer {
  final FirebasePerformance _performer = FirebasePerformance.instance;

  Future<void> trace(
    String name,
    Function cb,
    dynamic processValue, {
    String? attName,
    dynamic attValue,
  }) async {
    final Trace trace = _performer.newTrace(name);
    if (attName != null) trace.putAttribute(attName, attValue);
    await trace.start();
    cb(processValue);
    await trace.stop();
  }

  Future<http.Response> traceRequest(
    String url,
    HttpMethod method, {
    dynamic body,
    dynamic headers,
  }) async {
    MetricHttpClient client = MetricHttpClient();
    return await client.send(url, method, body: body, headers: headers);
  }
}

class MetricHttpClient {
  final http.Client _inner = http.Client();

  Future<http.Response> send(
    String url,
    HttpMethod method, {
    dynamic body,
    dynamic headers,
  }) async {
    final FirebasePerformance _performer = FirebasePerformance.instance;
    final HttpMetric metric = _performer.newHttpMetric(url, method);
    await metric.start();
    http.Response response;
    try {
      switch (method) {
        case HttpMethod.Get:
          response = await _inner.get(Uri.parse(url), headers: headers);
          break;
        case HttpMethod.Delete:
          response = await _inner.delete(Uri.parse(url), headers: headers);
          break;
        case HttpMethod.Put:
          response =
              await _inner.put(Uri.parse(url), headers: headers, body: body);
          break;
        case HttpMethod.Patch:
          response =
              await _inner.patch(Uri.parse(url), headers: headers, body: body);
          break;
        case HttpMethod.Post:
          response =
              await _inner.post(Uri.parse(url), headers: headers, body: body);
          break;
        default:
          response = await _inner.get(Uri.parse(url), headers: headers);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }
    return response;
  }
}
