// part of employ.provider;

// class EmployApi {
//   final String baseUrl;
//   final dynamic headers = {
//     'Accept': 'application/json',
//     'Content-Type': 'application/json'
//   };

//   EmployApi({this.baseUrl = "https://6b83b040.ngrok.io"});

//   Future<List<AutoCompleteField>> autoComplete(
//     BuildContext context,
//     String query,
//   ) async {
//     Performer performer = WebsacoProvider.of(context).performance;
//     Crasher crashlytics = WebsacoProvider.of(context).crashlytics;
//     try {
//       http.Response response = await performer.traceRequest(
//         '$baseUrl/api/coproperties/autocomplete?query=$query',
//         HttpMethod.Get,
//       );
//       dynamic res = json.decode(response.body);
//       List<AutoCompleteField> list =[]
//       res.forEach((data) => list.add(AutoCompleteField.fromJson(data)));
//       return list;
//     } catch (e) {
//       crashlytics.report(e);
//       return null;
//     }
//   }

//   Future<String> getDocument(
//     String id,
//     String token,
//     BuildContext context,
//   ) async {
//     Performer performer = WebsacoProvider.of(context).performance;
//     Crasher crashlytics = WebsacoProvider.of(context).crashlytics;
//     Map<String, String> headers = <String, String>{
//       'Authorization': 'Bearer $token'
//     };
//     try {
//       crashlytics.log('document_get_pages');
//       http.Response response = await performer.traceRequest(
//         '$baseUrl/api/document/$id',
//         HttpMethod.Get,
//         headers: headers,
//       );
//       dynamic res = json.decode(response.body);
//       final String serverUrl = '$baseUrl/document/';
//       return res['docName'] != null
//           ? '${res['docName'].contains('http') ? '' : serverUrl}${res['docName']}'
//           : null;
//     } catch (e) {
//       crashlytics.report(e);
//       return null;
//     }
//   }

//   Future<dynamic> signin(
//     BuildContext context, {
//     required String user,
//     required String pass,
//     String coId,
//   }) async {
//     Performer performer = WebsacoProvider.of(context).performance;
//     Crasher crashlytics = WebsacoProvider.of(context).crashlytics;
//     try {
//       crashlytics.log('sign_in');
//       Map<String, String> payload = {'username': user, 'password': pass};
//       if (coId != null) payload['co_ownership'] = coId;
//       String body = jsonEncode(payload);
//       http.Response response = await performer.traceRequest(
//         '$baseUrl/api/login',
//         HttpMethod.Post,
//         body: body,
//         headers: headers,
//       );
//       dynamic res = json.decode(response.body);
//       return res;
//     } catch (e) {
//       crashlytics.report(e);
//       return null;
//     }
//   }
// }
