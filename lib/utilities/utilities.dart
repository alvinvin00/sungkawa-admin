import 'package:intl/intl.dart';
import 'package:Sungkawa/model/post.dart';

class Utilities {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm');
  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('hh:mm a');
  var timeText = '';

  String convertTimestamp(int timestamp) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      timeText = format.format(date);
    } else {
//      if(diff.inDays == 1){
//        time = diff.inDays.toString() + ' HARI YANG LALU';
//        }
//        else{
//          time = diff.inDays.toString()+ ' HARI YANG LALU';
//      }
      timeText = diff.inDays.toString() + ' HARI YANG LALU';
    }
    return timeText;
  }


}
