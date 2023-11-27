class Classe {
  int nbreEtud;
  String nomClass;
  int? codClass;

  Classe(this.nbreEtud, this.nomClass, [this.codClass]);

  Map<String, dynamic> toJson() {
    return {
      'codClass': codClass,
      'nomClass': nomClass,
      'nbreEtud': nbreEtud,
    };
  }
}
