import 'package:json_annotation/json_annotation.dart';

part 'nutrition_data.g.dart';

@JsonSerializable()
class NutritionData {
  final String alimento;
  final String estado;
  final WeightData peso;
  final VolumeData volumen;
  final PortionData portion;
  final NutritionInfoData nutricion;
  final String costoApiTotal;
  final int tokensUsados;

  NutritionData({
    required this.alimento,
    required this.estado,
    required this.peso,
    required this.volumen,
    required this.portion,
    required this.nutricion,
    required this.costoApiTotal,
    required this.tokensUsados,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) =>
      _$NutritionDataFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionDataToJson(this);
}

@JsonSerializable()
class WeightData {
  final double valor;
  final String unidad;
  final String margenError;

  WeightData({
    required this.valor,
    required this.unidad,
    required this.margenError,
  });

  factory WeightData.fromJson(Map<String, dynamic> json) =>
      _$WeightDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeightDataToJson(this);
}

@JsonSerializable()
class VolumeData {
  final double valor;
  final String unidad;
  final String margenError;

  VolumeData({
    required this.valor,
    required this.unidad,
    required this.margenError,
  });

  factory VolumeData.fromJson(Map<String, dynamic> json) =>
      _$VolumeDataFromJson(json);
  Map<String, dynamic> toJson() => _$VolumeDataToJson(this);
}

@JsonSerializable()
class PortionData {
  final String volume;
  final String weight;
  final String householdMeasure;
  final String errorMargin;

  PortionData({
    required this.volume,
    required this.weight,
    required this.householdMeasure,
    required this.errorMargin,
  });

  factory PortionData.fromJson(Map<String, dynamic> json) =>
      _$PortionDataFromJson(json);
  Map<String, dynamic> toJson() => _$PortionDataToJson(this);
}

@JsonSerializable()
class NutritionInfoData {
  final double kilocaloriesPer100g;
  final double proteinsPer100g;
  final double fatsPer100g;
  final double carbohydratesPer100g;
  final double fiberPer100g;

  NutritionInfoData({
    required this.kilocaloriesPer100g,
    required this.proteinsPer100g,
    required this.fatsPer100g,
    required this.carbohydratesPer100g,
    required this.fiberPer100g,
  });

  factory NutritionInfoData.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoDataFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInfoDataToJson(this);
}
