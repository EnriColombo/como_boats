import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/boat.dart';

class BoatService {
  static Future<List<Boat>> fetchBoats() async {
    final boatsData = await Supabase.instance.client
        .from('boats')
        .select('*, companies(*), boat_images(*)');
    return (boatsData as List)
        .map((boatData) => Boat.fromJson(boatData))
        .toList();
  }
}