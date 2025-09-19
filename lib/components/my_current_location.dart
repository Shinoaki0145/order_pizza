import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';

class LocationNotifier extends ChangeNotifier {
  double baseLat = 10.76314, baseLong = 106.6821889;
  String _curLocation = "";
  String _deliveryTime = "";
  double _distance = 0;
  String get curLocation => _curLocation;
  String get deliveryTime => _deliveryTime;
  double get shipFee => getShipFee();

  void updateLocation(String newLocation) {
    _curLocation = newLocation;
  }

  double getShipFee() {
    if (_distance == 0) return 0;

    double baseFee = 0.5;
    double baseDist = 3;
    if (_distance <= baseDist) return baseFee;

    double dist = _distance - baseDist;
    double fee = baseFee;
    while (dist > 0) {
      fee += .15;
      dist -= 1;
    }
    return fee;
  }

  Future<bool> getDeliveryTime() async{
    double destLat, destLong;
    try {
      List<Location> locations = await locationFromAddress(_curLocation);
      destLat = locations[0].latitude;
      destLong = locations[0].longitude;
    }
    on NoResultFoundException {
      return false;
    }

    const APIKEY = String.fromEnvironment('ORS_API_KEY', defaultValue: '');
    try {
      final postData = await Dio().post(
          "https://api.openrouteservice.org/v2/matrix/cycling-regular",
          data: {
            "locations": [[baseLong, baseLat],[destLong, destLat]],
            "metrics": ["distance", "duration"],
            "units": "km"
          },
          options: Options(
              headers: {
                "Authorization" : APIKEY,
              }
          )
      );
      _deliveryTime = (postData.data['durations'][0][1] / 60).toStringAsFixed(0);
      _distance = postData.data['distances'][0][1];
    }
    on DioException {
      return false;
    }
    notifyListeners();
    return true;
  }

  void clearDelivery() {
    _curLocation = "";
    _deliveryTime = "";
    _distance = 0;
  }
}

class MyCurrentLocation extends StatefulWidget {
  const MyCurrentLocation({super.key});

  @override
  State<MyCurrentLocation> createState() => _MyCurrentLocationState();
}

class _MyCurrentLocationState extends State<MyCurrentLocation> {
  String currentAddress = "";

  final TextEditingController _controller = TextEditingController();

  void openLocationSearchBox(BuildContext context) {
    _controller.text = currentAddress; // gán địa chỉ hiện tại vào ô nhập

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your location"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Enter your location",
          ),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // save button
          MaterialButton(
            onPressed: () async{
              Navigator.pop(context);
              setState(() {
                currentAddress = _controller.text; // cập nhật địa chỉ
              });
              final noti = context.read<LocationNotifier>();
              noti.updateLocation(currentAddress);
              if (!await noti.getDeliveryTime() && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Location unknown"))
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver now",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                // address
                Text(
                  currentAddress, // hiển thị địa chỉ được cập nhật
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // drop down menu
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
