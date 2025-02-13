import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/main.dart';
import '/models/station_details.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsView extends StatefulWidget {
  final StationDetails station;

  const StationDetailsView({super.key, required this.station});

  @override
  State<StationDetailsView> createState() => _StationDetailsViewState();
}

class _StationDetailsViewState extends State<StationDetailsView> {
  late GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MainAppBar(title: "${widget.station.code} - ${widget.station.name}"),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset(
            widget.station.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.station.address,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.station.latitude,
                        widget.station.longitude,
                      ),
                      zoom: 15,
                    ),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    zoomControlsEnabled: true,
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.station.code),
                        position: LatLng(
                          widget.station.latitude,
                          widget.station.longitude,
                        ),
                      ),
                    },
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${widget.station.latitude},${widget.station.longitude}',
                      );
                      try {
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          throw 'Could not launch maps';
                        }
                      } catch (e) {
                        debugPrint('Error launching maps: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open Google Maps'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Open in Google Maps'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nearby Amenities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.station.nearbyAmenities.map(
                  (amenity) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $amenity',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
