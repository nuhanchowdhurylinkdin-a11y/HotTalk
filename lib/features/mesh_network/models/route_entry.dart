class RouteEntry {
  final String destinationId;
  final String nextHopId;
  final int hopCount;

  RouteEntry({
    required this.destinationId,
    required this.nextHopId,
    required this.hopCount,
  });
}