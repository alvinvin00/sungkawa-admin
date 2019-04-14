import 'package:intl/intl.dart';

class Utilities {
  String convertTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var difer = date.difference(now);
    var time = '';

    if (difer.inSeconds <=0 || difer.inSeconds >0 && difer.inMinutes ==0 ||
    difer.inMinutes >0 && difer.inHours == 0 || difer.inHours > 0 && difer.inDays ==0){
      time = format.format(date);
    }else{
      if(difer.inDays == 1){
        time = difer.inDays.toString() + 'HARI YANG LALU';
        }
        else{
          time = difer.inDays.toString()+ 'HARI YANG LALU';
      }
    }
      return time;
  }
}