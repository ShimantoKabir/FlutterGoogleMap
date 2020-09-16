import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyGoogleMap extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MyGoogleMap();
  }
}

class _MyGoogleMap extends State<MyGoogleMap> {

  LatLng _markerPosition = LatLng(23.758095, 90.390063);
  GoogleMapController _gpc;
  Location _location = Location();
  Set<Marker> _markers = Set<Marker>();

  TextEditingController latTECtl = TextEditingController();
  TextEditingController lngTECtl = TextEditingController();
  TextEditingController nameTECtl = TextEditingController();

  @override
  void initState() {
    nameTECtl.text = "MD. Abdullah Al Shahariar Kabir";
    super.initState();
  }

  void _onMyMapCreated(GoogleMapController googleMapController) {
    _markers.add(Marker(
      markerId: MarkerId('id'),
      position: _markerPosition,
    ));

    _gpc = googleMapController;

    _location.onLocationChanged.listen((LocationData currentLocation) {
      _markerPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _gpc.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _markerPosition, zoom: 15)));

      setState(() {
        latTECtl.text = '${currentLocation.latitude}';
        lngTECtl.text = '${currentLocation.longitude}';
        _markers.removeWhere((m) => m.markerId.value == 'id');
        _markers.add(Marker(
            markerId: MarkerId('id'),
            position: _markerPosition,
            onTap: _onMarkerTab));
      });

      print("total marker = ${_markers.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: _markerPosition, zoom: 10),
          onMapCreated: _onMyMapCreated,
          myLocationEnabled: true,
          markers: _markers,
        )
      ]),
    );
  }

  void _onMarkerTab() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Position',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )),
        content: Wrap(children: <Widget>[
          Text('Latitude'),
          TextField(
            controller: latTECtl,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0,10,0,0),
              child: Text('Longitude')
          ),
          TextField(
            controller: lngTECtl,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text('Name')
          ),
          TextField(
            controller: nameTECtl,
          ),
        ]),
        actions: <Widget>[
          FlatButton(child: Text('Send'), onPressed: _onSendClick)
        ],
      ),
    );
  }

  void _onSendClick() {
    print(
        'Latitude = ${latTECtl.text}, Longitude = ${lngTECtl.text}, Name = ${nameTECtl.text}');
    Navigator.of(context).pop(false);
  }

  @override
  void dispose() {
    super.dispose();
    latTECtl.dispose();
    lngTECtl.dispose();
    nameTECtl.dispose();
  }
}
