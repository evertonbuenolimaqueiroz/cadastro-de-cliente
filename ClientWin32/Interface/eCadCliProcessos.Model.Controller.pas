unit eCadCliProcessos.Model.Controller;

interface

uses Vcl.DBCtrls, cxDBEdit;

type
  iCadCliProcessos = Interface
    ['{EEB6AB01-9619-411C-A152-81A66BF7A259}']
    procedure ValidarNomeFantasia(Fantasia: String; edtdados: TDBEdit);
    procedure ValidarCPF(CPF: String; edtdados: TcxDBButtonEdit);
    procedure ValidarCNPJ(CNPJ: String; edtdados: TcxDBButtonEdit);
    procedure ValidarEmail(Email: String; edtdados: TDBEdit);
    procedure ValidarCep(CEP: String; edtdados: TcxDBButtonEdit);
  End;

implementation

end.
