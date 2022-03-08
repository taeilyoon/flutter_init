class Argument {
  String? packageName;
  String? iosPackageName;
  String? androidPackageName;
  String? appName;
  String? icon;
  Permission? permission;

  Argument(
      {this.packageName,
      this.iosPackageName,
      this.androidPackageName,
      this.appName,
      this.icon,
      this.permission});

  Argument.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    iosPackageName = json['iosPackageName'];
    androidPackageName = json['androidPackageName'];
    appName = json['appName'];
    icon = json['icon'];
    permission = json['permission'] != null
        ? new Permission.fromJson(json['permission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageName'] = this.packageName;
    data['iosPackageName'] = this.iosPackageName;
    data['androidPackageName'] = this.androidPackageName;
    data['appName'] = this.appName;
    data['icon'] = this.icon;
    if (this.permission != null) {
      data['permission'] = this.permission!.toJson();
    }
    return data;
  }
}

class Permission {
  String? camera;

  Permission({this.camera});

  Permission.fromJson(Map<String, dynamic> json) {
    camera = json['camera'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['camera'] = this.camera;
    return data;
  }
}
