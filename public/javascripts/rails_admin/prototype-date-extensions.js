DateFormat = Class.create();
Object.extend(DateFormat, {
  MONTH_NAMES: ['January','February','March','April','May','June','July','August','September','October','November','December','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
  DAY_NAMES: ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
  LZ: function(x) {return(x<0||x>9?"":"0")+x},
  compareDates: function(date1,dateformat1,date2,dateformat2) {
    var d1=DateFormat.parseFormat(date1,dateformat1);
    var d2=DateFormat.parseFormat(date2,dateformat2);
    if (d1==0 || d2==0) return -1;
    else if (d1 > d2) return 1;
    return 0;
  },
  format: function(date,format) {
    format=format+"";
    var result="";
    var i_format=0;
    var c="";
    var token="";
    var y=date.getYear()+"";
    var M=date.getMonth()+1;
    var d=date.getDate();
    var E=date.getDay();
    var H=date.getHours();
    var m=date.getMinutes();
    var s=date.getSeconds();
    var yyyy,yy,MMM,MM,dd,hh,h,mm,ss,ampm,HH,H,KK,K,kk,k;
    // Convert real date parts into formatted versions
    var value=new Object();
    if (y.length < 4) {y=""+(y-0+1900);}
    value["y"]=""+y;
    value["yyyy"]=y;
    value["yy"]=y.substring(2,4);
    value["M"]=M;
    value["MM"]=DateFormat.LZ(M);
    value["MMM"]=DateFormat.MONTH_NAMES[M-1];
    value["NNN"]=DateFormat.MONTH_NAMES[M+11];
    value["d"]=d;
    value["dd"]=DateFormat.LZ(d);
    value["E"]=DateFormat.DAY_NAMES[E+7];
    value["EE"]=DateFormat.DAY_NAMES[E];
    value["H"]=H;
    value["HH"]=DateFormat.LZ(H);
    if (H==0){value["h"]=12;}
    else if (H>12){value["h"]=H-12;}
    else {value["h"]=H;}
    value["hh"]=DateFormat.LZ(value["h"]);
    if (H>11){value["K"]=H-12;} else {value["K"]=H;}
    value["k"]=H+1;
    value["KK"]=DateFormat.LZ(value["K"]);
    value["kk"]=DateFormat.LZ(value["k"]);
    if (H > 11) { value["a"]="PM"; }
    else { value["a"]="AM"; }
    value["m"]=m;
    value["mm"]=DateFormat.LZ(m);
    value["s"]=s;
    value["ss"]=DateFormat.LZ(s);
    while (i_format < format.length) {
      c=format.charAt(i_format);
      token="";
      while ((format.charAt(i_format)==c) && (i_format < format.length))
        token += format.charAt(i_format++);
      if (value[token] != null) result += value[token];
      else result += token;
    }
    return result;
  },
  _isInteger: function(val) {
    var digits="1234567890";
    for (var i=0; i < val.length; i++)
      if (digits.indexOf(val.charAt(i))==-1) return false;
    return true;
  },
  _getInt: function(str,i,minlength,maxlength) {
    for (var x=maxlength; x>=minlength; x--) {
      var token=str.substring(i,i+x);
      if (token.length < minlength) return null;
      if (DateFormat._isInteger(token)) return token;
    }
    return null;
  },
  parseFormat: function(val,format) {
    val=val+"";
    format=format+"";
    var i_val=0;
    var i_format=0;
    var c="";
    var token="";
    var token2="";
    var x,y;
    var now=new Date();
    var year=now.getYear();
    var month=now.getMonth()+1;
    var date=1;
    var hh=now.getHours();
    var mm=now.getMinutes();
    var ss=now.getSeconds();
    var ampm="";

    while (i_format < format.length) {
      // Get next token from format string
      c=format.charAt(i_format);
      token="";
      while ((format.charAt(i_format)==c) && (i_format < format.length))
        token += format.charAt(i_format++);
      // Extract contents of value based on format token
      if (token=="yyyy" || token=="yy" || token=="y") {
        if (token=="yyyy") x=4;y=4;
        if (token=="yy") x=2;y=2;
        if (token=="y") x=2;y=4;
        year=DateFormat._getInt(val,i_val,x,y);
        if (year==null) return 0;
        i_val += year.length;
        if (year.length==2) {
          if (year > 70) year=1900+(year-0);
          else year=2000+(year-0);
        }
      } else if (token=="MMM"||token=="NNN") {
        month=0;
        for (var i=0; i<DateFormat.MONTH_NAMES.length; i++) {
          var month_name=DateFormat.MONTH_NAMES[i];
          if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) {
            if (token=="MMM"||(token=="NNN"&&i>11)) {
              month=i+1;
              if (month>12) month -= 12;
              i_val += month_name.length;
              break;
            }
          }
        }
        if ((month < 1)||(month>12)) return 0;
      } else if (token=="EE"||token=="E") {
        for (var i=0; i<DateFormat.DAY_NAMES.length; i++) {
          var day_name=DateFormat.DAY_NAMES[i];
          if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) {
            i_val += day_name.length;
            break;
          }
        }
      } else if (token=="MM"||token=="M") {
        month=DateFormat._getInt(val,i_val,token.length,2);
        if(month==null||(month<1)||(month>12)) return 0;
        i_val+=month.length;
      } else if (token=="dd"||token=="d") {
        date=DateFormat._getInt(val,i_val,token.length,2);
        if(date==null||(date<1)||(date>31)) return 0;
        i_val+=date.length;
      } else if (token=="hh"||token=="h") {
        hh=DateFormat._getInt(val,i_val,token.length,2);
        if(hh==null||(hh<1)||(hh>12)) return 0;
        i_val+=hh.length;
      } else if (token=="HH"||token=="H") {
        hh=DateFormat._getInt(val,i_val,token.length,2);
        if(hh==null||(hh<0)||(hh>23)) return 0;
        i_val+=hh.length;
      } else if (token=="KK"||token=="K") {
        hh=DateFormat._getInt(val,i_val,token.length,2);
        if(hh==null||(hh<0)||(hh>11)) return 0;
        i_val+=hh.length;
      } else if (token=="kk"||token=="k") {
        hh=DateFormat._getInt(val,i_val,token.length,2);
        if(hh==null||(hh<1)||(hh>24)) return 0;
        i_val+=hh.length;hh--;
      } else if (token=="mm"||token=="m") {
        mm=DateFormat._getInt(val,i_val,token.length,2);
        if(mm==null||(mm<0)||(mm>59)) return 0;
        i_val+=mm.length;
      } else if (token=="ss"||token=="s") {
        ss=DateFormat._getInt(val,i_val,token.length,2);
        if(ss==null||(ss<0)||(ss>59)) return 0;
        i_val+=ss.length;
      } else if (token=="a") {
        if (val.substring(i_val,i_val+2).toLowerCase()=="am") ampm="AM";
        else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") ampm="PM";
        else return 0;
        i_val+=2;
      } else {
        if (val.substring(i_val,i_val+token.length)!=token) return 0;
        else i_val+=token.length;
      }
    }
    // If there are any trailing characters left in the value, it doesn't match
    if (i_val != val.length) return 0;
    // Is date valid for month?
    if (month==2) {
      // Check for leap year
      if (((year%4==0)&&(year%100 != 0)) || (year%400==0)) { // leap year
        if (date > 29) return 0;
      } else if (date > 28) {
        return 0;
      }
    }
    if ((month==4)||(month==6)||(month==9)||(month==11))
      if (date > 30) return 0;
    // Correct hours value
    if (hh<12 && ampm=="PM") hh=hh-0+12;
    else if (hh>11 && ampm=="AM") hh-=12;
    var newdate=new Date(year,month-1,date,hh,mm,ss);
    return newdate;
  },
  parse: function(val, format) {
    if (format) {
      return DateFormat.parseFormat(val, format);
    } else {
      var preferEuro=(arguments.length==2)?arguments[1]:false;
      var generalFormats=new Array('y-M-d','MMM d, y','MMM d,y','y-MMM-d','d-MMM-y','MMM d');
      var monthFirst=new Array('M/d/y','M-d-y','M.d.y','MMM-d','M/d','M-d');
      var dateFirst =new Array('d/M/y','d-M-y','d.M.y','d-MMM','d/M','d-M');
      var checkList=[generalFormats,preferEuro?dateFirst:monthFirst,preferEuro?monthFirst:dateFirst];
      var d=null;
      for (var i=0; i<checkList.length; i++) {
        var l=checkList[i];
        for (var j=0; j<l.length; j++) {
          d=DateFormat.parseFormat(val,l[j]);
          if (d!=0) return new Date(d);
        }
      }
      return null;
    }
  }
});

DateFormat.prototype = {
  initialize: function(format) { this.format = format; },
  parse: function(value) { return DateFormat.parseFormat(value, this.format); },
  format: function(value) { return DateFormat.format(value, this.format); }
}

Date.prototype.format = function(format) {
  return DateFormat.format(this, format);
}
