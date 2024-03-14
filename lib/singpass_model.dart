// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Cpfcontributions? uinfin;
  Cpfcontributions? name;
  Edulevel? sex;
  Edulevel? race;
  Edulevel? nationality;
  Cpfcontributions? dob;
  Cpfcontributions? email;
  Mobileno? mobileno;
  Regadd? regadd;
  Edulevel? housingtype;
  Edulevel? hdbtype;
  Edulevel? marital;
  Edulevel? edulevel;
  NoaBasic? noaBasic;
  Cpfcontributions? ownerprivate;
  Cpfcontributions? cpfcontributions;
  Cpfbalances? cpfbalances;

  Welcome({
    this.uinfin,
    this.name,
    this.sex,
    this.race,
    this.nationality,
    this.dob,
    this.email,
    this.mobileno,
    this.regadd,
    this.housingtype,
    this.hdbtype,
    this.marital,
    this.edulevel,
    this.noaBasic,
    this.ownerprivate,
    this.cpfcontributions,
    this.cpfbalances,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    uinfin: json["uinfin"] == null ? null : Cpfcontributions.fromJson(json["uinfin"]),
    name: json["name"] == null ? null : Cpfcontributions.fromJson(json["name"]),
    sex: json["sex"] == null ? null : Edulevel.fromJson(json["sex"]),
    race: json["race"] == null ? null : Edulevel.fromJson(json["race"]),
    nationality: json["nationality"] == null ? null : Edulevel.fromJson(json["nationality"]),
    dob: json["dob"] == null ? null : Cpfcontributions.fromJson(json["dob"]),
    email: json["email"] == null ? null : Cpfcontributions.fromJson(json["email"]),
    mobileno: json["mobileno"] == null ? null : Mobileno.fromJson(json["mobileno"]),
    regadd: json["regadd"] == null ? null : Regadd.fromJson(json["regadd"]),
    housingtype: json["housingtype"] == null ? null : Edulevel.fromJson(json["housingtype"]),
    hdbtype: json["hdbtype"] == null ? null : Edulevel.fromJson(json["hdbtype"]),
    marital: json["marital"] == null ? null : Edulevel.fromJson(json["marital"]),
    edulevel: json["edulevel"] == null ? null : Edulevel.fromJson(json["edulevel"]),
    noaBasic: json["noa-basic"] == null ? null : NoaBasic.fromJson(json["noa-basic"]),
    ownerprivate: json["ownerprivate"] == null ? null : Cpfcontributions.fromJson(json["ownerprivate"]),
    cpfcontributions: json["cpfcontributions"] == null ? null : Cpfcontributions.fromJson(json["cpfcontributions"]),
    cpfbalances: json["cpfbalances"] == null ? null : Cpfbalances.fromJson(json["cpfbalances"]),
  );

  Map<String, dynamic> toJson() => {
    "uinfin": uinfin?.toJson(),
    "name": name?.toJson(),
    "sex": sex?.toJson(),
    "race": race?.toJson(),
    "nationality": nationality?.toJson(),
    "dob": dob?.toJson(),
    "email": email?.toJson(),
    "mobileno": mobileno?.toJson(),
    "regadd": regadd?.toJson(),
    "housingtype": housingtype?.toJson(),
    "hdbtype": hdbtype?.toJson(),
    "marital": marital?.toJson(),
    "edulevel": edulevel?.toJson(),
    "noa-basic": noaBasic?.toJson(),
    "ownerprivate": ownerprivate?.toJson(),
    "cpfcontributions": cpfcontributions?.toJson(),
    "cpfbalances": cpfbalances?.toJson(),
  };
}

class Cpfbalances {
  Cpfcontributions? oa;
  Cpfcontributions? ma;
  Cpfcontributions? sa;
  Cpfcontributions? ra;

  Cpfbalances({
    this.oa,
    this.ma,
    this.sa,
    this.ra,
  });

  factory Cpfbalances.fromJson(Map<String, dynamic> json) => Cpfbalances(
    oa: json["oa"] == null ? null : Cpfcontributions.fromJson(json["oa"]),
    ma: json["ma"] == null ? null : Cpfcontributions.fromJson(json["ma"]),
    sa: json["sa"] == null ? null : Cpfcontributions.fromJson(json["sa"]),
    ra: json["ra"] == null ? null : Cpfcontributions.fromJson(json["ra"]),
  );

  Map<String, dynamic> toJson() => {
    "oa": oa?.toJson(),
    "ma": ma?.toJson(),
    "sa": sa?.toJson(),
    "ra": ra?.toJson(),
  };
}

class Cpfcontributions {
  DateTime? lastupdated;
  String? source;
  Classification? classification;
  dynamic value;
  bool? unavailable;
  List<History>? history;

  Cpfcontributions({
    this.lastupdated,
    this.source,
    this.classification,
    this.value,
    this.unavailable,
    this.history,
  });

  factory Cpfcontributions.fromJson(Map<String, dynamic> json) => Cpfcontributions(
    lastupdated: json["lastupdated"] == null ? null : DateTime.parse(json["lastupdated"]),
    source: json["source"],
    classification: classificationValues.map[json["classification"]]!,
    value: json["value"],
    unavailable: json["unavailable"],
    history: json["history"] == null ? [] : List<History>.from(json["history"]!.map((x) => History.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lastupdated": "${lastupdated!.year.toString().padLeft(4, '0')}-${lastupdated!.month.toString().padLeft(2, '0')}-${lastupdated!.day.toString().padLeft(2, '0')}",
    "source": source,
    "classification": classificationValues.reverse[classification],
    "value": value,
    "unavailable": unavailable,
    "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toJson())),
  };
}

enum Classification {
  C
}

final classificationValues = EnumValues({
  "C": Classification.C
});

class History {
  Areacode? date;
  Areacode? employer;
  Amount? amount;
  Areacode? month;

  History({
    this.date,
    this.employer,
    this.amount,
    this.month,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    date: json["date"] == null ? null : Areacode.fromJson(json["date"]),
    employer: json["employer"] == null ? null : Areacode.fromJson(json["employer"]),
    amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
    month: json["month"] == null ? null : Areacode.fromJson(json["month"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toJson(),
    "employer": employer?.toJson(),
    "amount": amount?.toJson(),
    "month": month?.toJson(),
  };
}

class Amount {
  int? value;

  Amount({
    this.value,
  });

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
  };
}

class Areacode {
  String? value;

  Areacode({
    this.value,
  });

  factory Areacode.fromJson(Map<String, dynamic> json) => Areacode(
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
  };
}

class Edulevel {
  DateTime? lastupdated;
  String? code;
  String? source;
  Classification? classification;
  String? desc;

  Edulevel({
    this.lastupdated,
    this.code,
    this.source,
    this.classification,
    this.desc,
  });

  factory Edulevel.fromJson(Map<String, dynamic> json) => Edulevel(
    lastupdated: json["lastupdated"] == null ? null : DateTime.parse(json["lastupdated"]),
    code: json["code"],
    source: json["source"],
    classification: classificationValues.map[json["classification"]]!,
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "lastupdated": "${lastupdated!.year.toString().padLeft(4, '0')}-${lastupdated!.month.toString().padLeft(2, '0')}-${lastupdated!.day.toString().padLeft(2, '0')}",
    "code": code,
    "source": source,
    "classification": classificationValues.reverse[classification],
    "desc": desc,
  };
}

class Mobileno {
  DateTime? lastupdated;
  String? source;
  Classification? classification;
  Areacode? areacode;
  Areacode? prefix;
  Areacode? nbr;

  Mobileno({
    this.lastupdated,
    this.source,
    this.classification,
    this.areacode,
    this.prefix,
    this.nbr,
  });

  factory Mobileno.fromJson(Map<String, dynamic> json) => Mobileno(
    lastupdated: json["lastupdated"] == null ? null : DateTime.parse(json["lastupdated"]),
    source: json["source"],
    classification: classificationValues.map[json["classification"]]!,
    areacode: json["areacode"] == null ? null : Areacode.fromJson(json["areacode"]),
    prefix: json["prefix"] == null ? null : Areacode.fromJson(json["prefix"]),
    nbr: json["nbr"] == null ? null : Areacode.fromJson(json["nbr"]),
  );

  Map<String, dynamic> toJson() => {
    "lastupdated": "${lastupdated!.year.toString().padLeft(4, '0')}-${lastupdated!.month.toString().padLeft(2, '0')}-${lastupdated!.day.toString().padLeft(2, '0')}",
    "source": source,
    "classification": classificationValues.reverse[classification],
    "areacode": areacode?.toJson(),
    "prefix": prefix?.toJson(),
    "nbr": nbr?.toJson(),
  };
}

class NoaBasic {
  Areacode? yearofassessment;
  DateTime? lastupdated;
  Amount? amount;
  String? source;
  Classification? classification;

  NoaBasic({
    this.yearofassessment,
    this.lastupdated,
    this.amount,
    this.source,
    this.classification,
  });

  factory NoaBasic.fromJson(Map<String, dynamic> json) => NoaBasic(
    yearofassessment: json["yearofassessment"] == null ? null : Areacode.fromJson(json["yearofassessment"]),
    lastupdated: json["lastupdated"] == null ? null : DateTime.parse(json["lastupdated"]),
    amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
    source: json["source"],
    classification: classificationValues.map[json["classification"]]!,
  );

  Map<String, dynamic> toJson() => {
    "yearofassessment": yearofassessment?.toJson(),
    "lastupdated": "${lastupdated!.year.toString().padLeft(4, '0')}-${lastupdated!.month.toString().padLeft(2, '0')}-${lastupdated!.day.toString().padLeft(2, '0')}",
    "amount": amount?.toJson(),
    "source": source,
    "classification": classificationValues.reverse[classification],
  };
}

class Regadd {
  Country? country;
  Areacode? unit;
  Areacode? street;
  DateTime? lastupdated;
  Areacode? block;
  String? source;
  Areacode? postal;
  Classification? classification;
  Areacode? floor;
  String? type;
  Areacode? building;

  Regadd({
    this.country,
    this.unit,
    this.street,
    this.lastupdated,
    this.block,
    this.source,
    this.postal,
    this.classification,
    this.floor,
    this.type,
    this.building,
  });

  factory Regadd.fromJson(Map<String, dynamic> json) => Regadd(
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    unit: json["unit"] == null ? null : Areacode.fromJson(json["unit"]),
    street: json["street"] == null ? null : Areacode.fromJson(json["street"]),
    lastupdated: json["lastupdated"] == null ? null : DateTime.parse(json["lastupdated"]),
    block: json["block"] == null ? null : Areacode.fromJson(json["block"]),
    source: json["source"],
    postal: json["postal"] == null ? null : Areacode.fromJson(json["postal"]),
    classification: classificationValues.map[json["classification"]]!,
    floor: json["floor"] == null ? null : Areacode.fromJson(json["floor"]),
    type: json["type"],
    building: json["building"] == null ? null : Areacode.fromJson(json["building"]),
  );

  Map<String, dynamic> toJson() => {
    "country": country?.toJson(),
    "unit": unit?.toJson(),
    "street": street?.toJson(),
    "lastupdated": "${lastupdated!.year.toString().padLeft(4, '0')}-${lastupdated!.month.toString().padLeft(2, '0')}-${lastupdated!.day.toString().padLeft(2, '0')}",
    "block": block?.toJson(),
    "source": source,
    "postal": postal?.toJson(),
    "classification": classificationValues.reverse[classification],
    "floor": floor?.toJson(),
    "type": type,
    "building": building?.toJson(),
  };
}

class Country {
  String? code;
  String? desc;

  Country({
    this.code,
    this.desc,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json["code"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "desc": desc,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
