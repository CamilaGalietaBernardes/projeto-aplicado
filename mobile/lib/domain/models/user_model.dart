// lib/domain/user_model.dart

class UserModel {
  final int id;
  final String nome;
  final String email;
  final String? funcao;
  final String? setor;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.funcao,
    this.setor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,

      funcao: json['funcao'] as String?,
      setor: json['setor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'funcao': funcao,
      'setor': setor,
    };
  }
}
