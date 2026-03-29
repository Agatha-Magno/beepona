enum ProdutoEnum {
  mel,
  propolis,
  outros;

  /// Retorna o rótulo amigável para a UI
  static String toLabel(ProdutoEnum produto) {
    switch (produto) {
      case ProdutoEnum.mel:
        return 'Mel';
      case ProdutoEnum.propolis:
        return 'Própolis';
      case ProdutoEnum.outros:
        return 'Outros';
    }
  }

  /// Retorna o valor técnico para a API
  static String toValue(ProdutoEnum produto) {
    switch (produto) {
      case ProdutoEnum.mel:
        return 'mel';
      case ProdutoEnum.propolis:
        return 'propolis';
      case ProdutoEnum.outros:
        return 'outros';
    }
  }

  /// Converte uma string (da UI ou API) para o enum
  static ProdutoEnum toEnum(String produto) {
    final clean = produto.toLowerCase();
    switch (clean) {
      case 'mel':
        return ProdutoEnum.mel;
      case 'própolis':
      case 'propolis':
        return ProdutoEnum.propolis;
      case 'outros':
        return ProdutoEnum.outros;
      default:
        throw ArgumentError('Produto inválido: $produto');
    }
  }

  /// Mantido por retrocompatibilidade temporária, mapeando para o rótulo da UI
  @Deprecated('Use toLabel ou toValue')
  static String fromEnum(ProdutoEnum produto) => toLabel(produto);
}