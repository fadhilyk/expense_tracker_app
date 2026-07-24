import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const kategoriWarna = <int, Color>{
  1: Color(0xFF3B82F6),
  2: Color(0xFF8B5CF6),
  3: Color(0xFFF59E0B),
  4: Color(0xFF10B981),
  5: Color(0xFFEC4899),
  6: Color(0xFF6366F1),
  7: Color(0xFF14B8A6),
  8: Color(0xFFF97316),
  9: Color(0xFF06B6D4),
};

Color warnaKategori(int kategoriId) {
  return kategoriWarna[kategoriId] ?? AppColors.slateGrey;
}
