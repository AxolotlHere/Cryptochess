import 'dart:io';
import 'dart:math';


String caesarCypher(String? data){
  String return_data = "";
  Random randomInst = Random();
  int key = randomInst.nextInt(5);
  List codeU = [];
  for(int i=0;i<data!.codeUnits.length;i++){
    codeU.add(data.codeUnits[i]+key);
  }
  for(var i in codeU){
    return_data+=String.fromCharCode(i);
  }
  return return_data;
}

String Atbash(String? data){
  String return_data = "";
  for(int i=0;i<data!.codeUnits.length;i++){
    if(data.codeUnits[i]>=97&&data.codeUnits[i]<=122){
      return_data+=String.fromCharCode(122-(data.codeUnits[i]-97));
    }else{
      return_data+=data[i];
    }
  }
  return return_data;
}

String rot13(String? data){
  String return_data = "";
  int key = 13;
  List codeU = [];
  for(int i=0;i<data!.codeUnits.length;i++){
    (data.codeUnits[i]>=97&&data.codeUnits[i]<=122)?codeU.add(data.codeUnits[i]+13):codeU.add(data.codeUnits[i]);
  }
  for(var i in codeU){
    return_data+=String.fromCharCode(i);
  }
  return return_data;
}
String Vigenere(String? text) {
  StringBuffer result = StringBuffer();
  String key = "ruylopez";
  int keyLength = key.length;
  int keyIndex = 0;

  for (int i = 0; i < text!.length; i++) {
    int charCode = text.codeUnitAt(i);
    int shift = key.codeUnitAt(keyIndex % keyLength);

    if (charCode >= 65 && charCode <= 90) {
      // Uppercase letters
      shift = shift - 97; // Convert key letter to shift value
      result.writeCharCode(((charCode - 65 + shift) % 26) + 65);
      keyIndex++;
    } else if (charCode >= 97 && charCode <= 122) {
      // Lowercase letters
      shift = shift - 97; // Convert key letter to shift value
      result.writeCharCode(((charCode - 97 + shift) % 26) + 97);
      keyIndex++;
    } else {
      // Keep non-alphabet characters unchanged
      result.write(text[i]);
    }
  }
  return result.toString();
}

String Affine(String? data){
  //function : 3x+2
  String return_data = "";
  for(int i=0;i<data!.codeUnits.length;i++){
    return_data+=String.fromCharCode(3*data.codeUnits[i]+2);
  }
  return return_data;
}
