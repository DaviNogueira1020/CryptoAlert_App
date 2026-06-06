enum AlertType{
  above,
  below,
}

extension AlertTypeExtension on AlertType{
  String get value{
    switch(this){
      case AlertType.above:
        return 'above';
      case AlertType.below:
        return 'below';
    }
  }

  static AlertType fromString(String value){
    switch(value){
      case 'above':
        return AlertType.above;
      case 'below':
        return AlertType.below;
      default:
        throw Exception('Invalid alert type');  
    }
  }
}