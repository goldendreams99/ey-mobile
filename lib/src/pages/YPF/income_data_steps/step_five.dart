part of employ.pages;

class IncomeDataStepFive extends StatefulWidget {
  final Map<String, String>? stepFiveData;
  final ValueChanged<Map<String, String>?> onChanged;

  const IncomeDataStepFive({this.stepFiveData, required this.onChanged});

  @override
  IncomeDataStepFiveState createState() => IncomeDataStepFiveState();
}

class IncomeDataStepFiveState extends State<IncomeDataStepFive> {
  Map<String, dynamic>? stepFiveData;
  TextEditingController? locationController;
  TextEditingController? streetController;
  List<dynamic> americanCountries = [];
  // PlacesDetailsResponse? place;  // Disabled due to Places API removal
  dynamic street;
  bool loading = false;
  late CameraPosition _kGooglePlex;
  late Set<Marker> markers;
  GoogleMapController? mapController;
  // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);  // Disabled

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(target: LatLng(0.0, 0.0));
    getUserLocation().then((center) {
      _kGooglePlex = CameraPosition(target: center ?? LatLng(0.0, 0.0));
      if (mounted) setState(() {});
      // if (street != null) loadMap(street['id']);  // Disabled due to Places API removal
    });
    markers = Set<Marker>();
    stepFiveData = widget.stepFiveData ?? Map();
    street = widget.stepFiveData?['location'] != null
        ? jsonDecode(widget.stepFiveData!['location']!)
        : null;
    streetController = TextEditingController(
        text: street != null ? street['description'] : '');
    locationController = TextEditingController(
        text: widget.stepFiveData?['locationDetail'] ?? '');
  }

  @override
  void dispose() {
    locationController?.dispose();
    streetController?.dispose();
    super.dispose();
  }

  void change(String target, dynamic value) async {
    stepFiveData?[target] = value;
    widget.onChanged(stepFiveData as dynamic);
  }

  TextStyle get hintStyle => FONT.REGULAR.merge(
        TextStyle(color: COLOR.white.withOpacity(0.5), fontSize: 20.0),
      );

  TextStyle get labelStyle => FONT.SEMIBOLD.merge(
        TextStyle(
          color: COLOR.very_light_pink_five,
          fontSize: 11.0,
        ),
      );

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  void searchLocation() async {
    try {
      String? p = await resolveLocationDialog(context);
      if (p != null) {
        streetController = TextEditingController(text: p);
        stepFiveData!['location'] =
            jsonEncode({'id': '', 'description': p});
        widget.onChanged(stepFiveData as dynamic);
        loading = false;
        if (mounted) setState(() {});
        // Map functionality disabled due to Places API removal
      }
    } catch (e) {
      return;
    }
  }

  // Map functionality disabled due to Places API removal
  // void loadMap(String id) {
  //   _places.getDetailsByPlaceId(id).then((_place) {
  //     loading = false;
  //     place = _place;
  //     if (mounted) setState(() {});
  //   });
  // }

  // void onMapCreated(GoogleMapController gmcontroller) async {
  //   mapController = gmcontroller;
  //   final location = place?.result.geometry?.location;
  //   final lat = location?.lat ?? 0;
  //   final lng = location?.lng ?? 0;
  //   final center = LatLng(lat, lng);
  //   if (place?.result.id != null) {
  //     markers = <Marker>[
  //       Marker(
  //         markerId: MarkerId(place!.result.id!),
  //         position: center,
  //       ),
  //     ].toSet();
  //     if (mounted) setState(() {});
  //   }
  //   mapController?.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: center, zoom: 18.0),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkResponse(
              onTap: searchLocation,
              child: UnderlineTextField(
                height: calcSize(size, 51.0),
                margin: EdgeInsets.symmetric(vertical: 20.0),
                label: 'Calle',
                hint: 'Esmeralda 850, Buenos Aires',
                color: COLOR.white,
                type: TextInputType.text,
                insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                suffixIcon: EmployIcons.chevron_right,
                style: textStyle,
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                controller: streetController,
                enabled: false,
              ),
            ),
            UnderlineTextField(
              height: calcSize(size, 51.0),
              controller: locationController,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              label: 'Piso / Depto',
              hint: '5 A',
              color: COLOR.white,
              type: TextInputType.text,
              insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
              suffixIcon: EmployIcons.edit,
              style: textStyle,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              onChange: (text) => change('locationDetail', text),
            ),
            Container(
              child: SizedBox(
                height: calcSize(size, 180.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Vista del mapa deshabilitada\n(Google Places API removido)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
