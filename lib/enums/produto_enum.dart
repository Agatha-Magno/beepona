enum ProdutoEnum {
    mel,
    propolis,
    outros;

    static String fromEnum(ProdutoEnum produto) {
        switch (produto) {
            case ProdutoEnum.mel:
                return 'Mel';
            case ProdutoEnum.propolis:
                return 'Própolis';
            case ProdutoEnum.outros:
                return 'Outros';
        }
    }

    static ProdutoEnum toEnum(String produto) {
        switch (produto) {
            case 'Mel':
                return ProdutoEnum.mel;
            case 'Própolis':
                return ProdutoEnum.propolis;
            case 'Outros':
                return ProdutoEnum.outros;
            default:
                throw ArgumentError('Produto inválido');
        }
    }
}