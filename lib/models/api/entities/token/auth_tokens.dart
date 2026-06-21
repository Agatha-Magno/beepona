import 'package:nectracker/interfaces/json/i_json.dart';

class AuthTokensModel implements IJson {
  String? token;
  String? refreshToken;

  AuthTokensModel({
    this.token,
    this.refreshToken,
  });

  @override
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      AuthTokensModel(
        token: json['token'],
        refreshToken: json['refreshToken'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
      };
}
