/*
 * Copyright (c) 2019. Libre de droit
 */

/// Utilisé dans differente class ne pas modifier les constructeurs
class Car {
  String _make;
  String model;
  String color;
  String _imageSrc;

  // Optionnal
  Car.optional(this._make, [this.model]) {
    print('Car is $_make $model');
  }

  Car(this._make, {this.model, this.color}) {
    print('Car is $_make ${getOptional(model)} ${getOptional(color)}');
  }

  Car.picture(this._make, this.model, this._imageSrc);

  String getOptional(String value) {
    return value == null ? '' : value;
  }

  @override
  operator ==(other) =>
      (other is Car) && (_make == other._make) && (model == other.model);

  @override
  int get hashCode => _make.hashCode ^ model.hashCode;

  String get imageSrc => _imageSrc;

  String get make => _make;
}
