import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';



class LocationService extends GetxService {
  
  final Rx<Map<String, double>?> currentPosition =
      Rx<Map<String, double>?>(null);
  final RxBool isTracking = false.obs;

  
  StreamController<Map<String, double>>? _trackingController;
  Timer? _trackingTimer;
  final math.Random _random = math.Random();

  
  static const double _baseLat = 37.7749;
  static const double _baseLng = -122.4194;

  
  double _currentLat = _baseLat;
  double _currentLng = _baseLng;

  
  @override
  void onClose() {
    stopTracking();
    _trackingController?.close();
    super.onClose();
  }

  
  
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('[LocationService] requestPermission error: $e');
      
      return true;
    }
  }

  
  Future<bool> hasPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      return true; 
    }
  }

  
  
  
  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      
      final lat = _baseLat + (_random.nextDouble() - 0.5) * 0.001;
      final lng = _baseLng + (_random.nextDouble() - 0.5) * 0.001;

      final position = {
        'latitude': lat,
        'longitude': lng,
        'accuracy': 8.0 + _random.nextDouble() * 5.0, 
        'altitude': 12.0,
        'speed': 0.0,
        'heading': _random.nextDouble() * 360.0,
      };

      currentPosition.value = position;
      _currentLat = lat;
      _currentLng = lng;

      return position;
    } catch (e) {
      debugPrint('[LocationService] getCurrentLocation error: $e');
      return null;
    }
  }

  
  
  
  Stream<Map<String, double>> startTracking() {
    if (isTracking.value) {
      return _trackingController!.stream;
    }

    _trackingController = StreamController<Map<String, double>>.broadcast();
    isTracking.value = true;

    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!isTracking.value) return;

      
      _currentLat += (_random.nextDouble() - 0.5) * 0.0005; 
      _currentLng += (_random.nextDouble() - 0.5) * 0.0005;

      final position = {
        'latitude': _currentLat,
        'longitude': _currentLng,
        'accuracy': 5.0 + _random.nextDouble() * 10.0,
        'altitude': 12.0,
        'speed': 1.2 + _random.nextDouble() * 3.5, 
        'heading': _random.nextDouble() * 360.0,
      };

      currentPosition.value = position;
      _trackingController?.add(position);
    });

    
    getCurrentLocation().then((pos) {
      if (pos != null && isTracking.value) {
        _trackingController?.add(pos);
      }
    });

    return _trackingController!.stream;
  }

  
  void stopTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
    isTracking.value = false;
    _trackingController?.close();
    _trackingController = null;
  }

  
  
  
  Future<String> getAddressFromCoords(double lat, double lng) async {
    
    await Future.delayed(const Duration(milliseconds: 300));

    final mockAddresses = [
      '1 Market Street, San Francisco, CA 94105',
      '100 California Street, San Francisco, CA 94111',
      '555 Mission Street, San Francisco, CA 94105',
      '345 Spear Street, San Francisco, CA 94105',
      '201 Third Street, San Francisco, CA 94103',
      '800 Market Street, San Francisco, CA 94102',
      '1 Montgomery Street, San Francisco, CA 94104',
      '600 Battery Street, San Francisco, CA 94111',
      '475 Sansome Street, San Francisco, CA 94111',
      '50 Fremont Street, San Francisco, CA 94105',
    ];

    
    final index = (lat * 1000 + lng * 1000).abs().round() % mockAddresses.length;
    return mockAddresses[index];
  }

  
  
  
  double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadiusKm = 6371.0;

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.pow(math.sin(dLng / 2), 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180.0;

  
  double? get latitude => currentPosition.value?['latitude'];
  double? get longitude => currentPosition.value?['longitude'];

  String get positionText {
    final pos = currentPosition.value;
    if (pos == null) return 'Location unknown';
    return '${pos['latitude']!.toStringAsFixed(4)}, '
        '${pos['longitude']!.toStringAsFixed(4)}';
  }
}
