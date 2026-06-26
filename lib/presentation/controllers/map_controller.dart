import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

class MapController extends GetxController {
  
  final Rx<LatLng?> technicianPosition = Rx<LatLng?>(null);
  final Rx<LatLng?> destinationPosition = Rx<LatLng?>(null);
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxBool isNavigating = false.obs;
  final RxString estimatedTime = ''.obs;
  final RxString destinationAddress = ''.obs;
  final RxDouble distanceKm = 0.0.obs;

  Timer? _movementTimer;
  int _routeIndex = 0;
  final Random _rng = Random();

  
  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  @override
  void onClose() {
    _movementTimer?.cancel();
    super.onClose();
  }

  
  Future<void> _initLocation() async {
    
    technicianPosition.value = const LatLng(30.2700, -97.7500);
  }

  
  void navigateTo({
    required double lat,
    required double lng,
    required String address,
  }) {
    destinationPosition.value = LatLng(lat, lng);
    destinationAddress.value = address;
    isNavigating.value = true;

    _buildRoute(
      technicianPosition.value ?? const LatLng(30.2700, -97.7500),
      LatLng(lat, lng),
    );

    _estimateTime();
    _startSimulatedMovement();
  }

  
  void _buildRoute(LatLng start, LatLng end) {
    routePoints.clear();
    _routeIndex = 0;

    
    const steps = 20;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      
      final jitter = i > 0 && i < steps ? (_rng.nextDouble() - 0.5) * 0.002 : 0.0;
      routePoints.add(LatLng(
        start.lat + (end.lat - start.lat) * t + jitter,
        start.lng + (end.lng - start.lng) * t + jitter,
      ));
    }
  }

  
  void _estimateTime() {
    final start = technicianPosition.value;
    final end = destinationPosition.value;
    if (start == null || end == null) return;

    final dist = _haversineKm(start, end);
    distanceKm.value = dist;
    final mins = (dist / 40 * 60).round(); 
    estimatedTime.value = '$mins min';
  }

  
  void _startSimulatedMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_routeIndex >= routePoints.length - 1) {
        isNavigating.value = false;
        estimatedTime.value = 'Arrived';
        _movementTimer?.cancel();
        return;
      }
      _routeIndex++;
      technicianPosition.value = routePoints[_routeIndex];
      final remaining = routePoints.length - 1 - _routeIndex;
      final minsLeft = (remaining * 2 / 60).ceil();
      estimatedTime.value = minsLeft > 0 ? '$minsLeft min' : 'Arriving...';
    });
  }

  
  void stopNavigation() {
    _movementTimer?.cancel();
    isNavigating.value = false;
    destinationPosition.value = null;
    routePoints.clear();
    estimatedTime.value = '';
    destinationAddress.value = '';
  }

  
  Future<void> fetchRealLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      technicianPosition.value = LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('[MapController] GPS error: $e');
    }
  }

  
  double _haversineKm(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = _deg2rad(b.lat - a.lat);
    final dLon = _deg2rad(b.lng - a.lng);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(a.lat)) * cos(_deg2rad(b.lat)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(x), sqrt(1 - x));
    return r * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  
  static const pi = 3.141592653589793;

  double sin(double x) => _sin(x);
  double cos(double x) => _cos(x);
  double sqrt(double x) => _sqrt(x);
  double atan2(double y, double x) => _atan2(y, x);

  double _sin(double x) {
    
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }

  double _cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + pi;
    if (x < 0 && y < 0) return _atan(y / x) - pi;
    if (x == 0 && y > 0) return pi / 2;
    if (x == 0 && y < 0) return -pi / 2;
    return 0;
  }

  double _atan(double x) {
    return x - (x * x * x) / 3 + (x * x * x * x * x) / 5;
  }
}
