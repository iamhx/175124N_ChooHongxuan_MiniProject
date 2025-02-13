import 'package:flutter/material.dart';
import '/main.dart';
import '/models/station.dart';
import '/models/station_data.dart';
import '/station_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeView();
}

class _HomeView extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  final _transformationController = TransformationController();

  final List<Station> stations = [
    Station(code: 'NS1', name: 'Jurong East', x: 113, y: 343.5),
    Station(code: 'NS2', name: 'Bukit Batok', x: 117, y: 297.5),
    Station(code: 'NS3', name: 'Bukit Gombak', x: 117, y: 261.5),
    Station(code: 'NS4', name: 'Choa Chu Kang', x: 116, y: 222),
    Station(code: 'NS5', name: 'Yew Tee', x: 118, y: 179),
    Station(code: 'NS7', name: 'Kranji', x: 118, y: 139),
    Station(code: 'NS8', name: 'Marisiling', x: 139, y: 93),
    Station(code: 'NS9', name: 'Woodlands', x: 190, y: 84),
    Station(code: 'NS10', name: 'Admiralty', x: 228, y: 84.5),
    Station(code: 'NS11', name: 'Sembawang', x: 259.5, y: 84.5),
    Station(code: 'NS12', name: 'Canberra', x: 291, y: 84.5),
    Station(code: 'NS13', name: 'Yishun', x: 324, y: 95),
    Station(code: 'NS14', name: 'Khatib', x: 341, y: 115),
    Station(code: 'NS15', name: 'Yio Chu Kang', x: 345.5, y: 139),
    Station(code: 'NS16', name: 'Ang Mo Kio', x: 345.5, y: 163),
    Station(code: 'NS17', name: 'Bishan', x: 340, y: 191),
    Station(code: 'NS18', name: 'Braddell', x: 345.5, y: 208),
    Station(code: 'NS19', name: 'Toa Payoh', x: 345.5, y: 231),
    Station(code: 'NS20', name: 'Novena', x: 331.5, y: 258),
    Station(code: 'NS21', name: 'Newton', x: 312.5, y: 278),
    Station(code: 'NS22', name: 'Orchard', x: 292, y: 312.5),
    Station(code: 'NS23', name: 'Somerset', x: 309.5, y: 338.5),
    Station(code: 'NS24', name: 'Dhoby Ghaut', x: 338, y: 367),
    Station(code: 'NS25', name: 'City Hall', x: 388, y: 423),
    Station(code: 'NS26', name: 'Raffles Place', x: 388, y: 446),
    Station(code: 'NS27', name: 'Marina Bay', x: 396, y: 483),
    Station(code: 'NS28', name: 'Marina South Pier', x: 422, y: 502.5),
  ];

  Widget _buildStationMarker(Station station) {
    return Positioned(
      left: station.x,
      top: station.y,
      child: GestureDetector(
        onTap: () => _showStationDetails(station),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }

  void _showStationDetails(Station station) {
    final details = StationData.getStationDetailsOrDefault(station.code);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailsView(station: details),
      ),
    );
  }

  @override
  void initState() {
    // Center the system map on initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(context).size;
      final Matrix4 matrix = Matrix4.identity();
      matrix.translate(-screenSize.width / 2);
      _transformationController.value = matrix;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const MainAppBar(
          title: "Home",
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                constrained: false,
                child: Stack(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: Image.asset(
                        'assets/systemmap.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    ...stations.map(_buildStationMarker)
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
