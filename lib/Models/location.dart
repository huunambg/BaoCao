import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
class Location_Provider extends ChangeNotifier {

  String _curren_address ="";
  // int?  _distance ;
  int? _meter ;
  void set__curren_address()async{
    //_curren_address ="khong thay";
    _curren_address  = await getAddressFromCoordinates();
    notifyListeners();
  }

  String current_address ()=> _curren_address;

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    var statusalway = await Permission.locationAlways.request();
    if (status.isDenied) {
      print("Bạn phai cấp quyền vị trí");
    }
        if (statusalway.isDenied) {
      print("Bạn phai cấp quyền vị trí");
    }

  }
  Future<String> getAddressFromCoordinates() async {
    await _requestLocationPermission();
    Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
    );
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String name =
            placemark.name ?? ''; // Tên ngách (tức là tên đường hoặc số nhà)
        String street = placemark.thoroughfare ?? ''; // Tên đường
        String subLocality = placemark.subLocality ?? ''; // Xã/phường
        String locality = placemark.locality ?? ''; // Quận/huyện
        String administrativeArea =
            placemark.administrativeArea ?? ''; // Tỉnh/thành phố
        String country = placemark.country ?? ''; // Quốc gia

        String fullAddress =
            '$name, $street, $subLocality, $locality, $administrativeArea, $country';
      //  print(fullAddress);
        return fullAddress;
      } else {
        return 'Chưa tìm thấy.';
      }
    } catch (e) {
      return 'Chưa tìm thấy.';
    }
  }

  meter ()=>_meter;

}
