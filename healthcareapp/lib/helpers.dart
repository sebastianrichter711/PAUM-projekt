import 'dart:math';

final Map<int,String> daysOfWeek = {
  1:"Pn",
  2:"Wt",
  3:"Śr",
  4:"Cz",
  5:"Pt",
  6:"Sb",
  7:"Nd",
};

int randBetween(int min, int max) {
  return Random().nextInt(max-min) + min;
}

String formatNumber(int number){

 
  return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

