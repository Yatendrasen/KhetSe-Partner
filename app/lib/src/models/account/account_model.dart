class Accounts {
  final List<Account> accounts;

  Accounts({
    required this.accounts,
  });

  addAll(Account account){
    this.accounts.add(account);
  }

}

class Account {
  int? id;
  String name;
  String? description;
  String url;
  String consumerKey;
  String consumerSecret;
  String? logo;
  int selected;

  Account({
    this.id,
    required this.name,
    required this.url,
    this.description,
    required this.consumerKey,
    required this.consumerSecret,
    this.logo,
    required this.selected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id == null ? null : id,
      'name': name,
      'description': description == null ? null : description,
      'url': url,
      'consumerkey': consumerKey,
      'consumerSecret': consumerSecret,
      'logo': logo == null ? '' : logo,
      'selected': selected,
    };
  }
}