validateString(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(patttern);
  if (value.isEmpty) {
    return "Ingrese alguna letra para continuar";
  } else if (!regExp.hasMatch(value)) {
    return 'Por favor solo ingrese letras';
  } else if (value.length < 15) {
    return "Debe ingresar al menos 15 caracteres";
  }
  return null;
}

String? validateInteger(String? age) {
  String patttern = r'(^[0-9]*$)'; //comprobar si funciona
  RegExp regExp = RegExp(patttern);
  if (!regExp.hasMatch(age!)) {
    return "El precio requiere caracteres numéricos para continuar";
  } else if (age.isNotEmpty && age.length <= 3) {
    return null;
  } else {
    return "Precio no valido";
  }
}
