class SiteSettingsResonseModel {
  final SiteSettingModel? data;

  SiteSettingsResonseModel({this.data});

  factory SiteSettingsResonseModel.fromJson(Map<String, dynamic> json) {
    return SiteSettingsResonseModel(
      data: SiteSettingModel.fromJson(json['data']),
    );
  }
}

class SiteSettingModel {
  final String? contactPhone;
  final String? contactEmail;
  final String? address;
  final Socials? socials;
  final Apps? apps;

  SiteSettingModel({
    this.contactPhone,
    this.contactEmail,
    this.address,
    this.socials,
    this.apps,
  });

  factory SiteSettingModel.fromJson(Map<String, dynamic> json) {
    return SiteSettingModel(
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      address: json['address'],
      socials: Socials.fromJson(json['socials']),
      apps: Apps.fromJson(json['apps']),
    );
  }
}

class Apps {
  final String? googlePlay;
  final String? appstore;

  Apps({this.googlePlay, this.appstore});

  factory Apps.fromJson(Map<String, dynamic> json) {
    return Apps(googlePlay: json['googlePlay'], appstore: json['appstore']);
  }
}

class Socials {
  final String? linkedin;
  final String? x;
  final String? instagram;
  final String? facebook;

  Socials({this.linkedin, this.x, this.instagram, this.facebook});

  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      linkedin: json['linkedin'],
      x: json['x'],
      instagram: json['instagram'],
      facebook: json['facebook'],
    );
  }
}
