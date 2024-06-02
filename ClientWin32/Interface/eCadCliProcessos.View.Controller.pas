unit eCadCliProcessos.View.Controller;

interface

uses eCadCliProcessos.Model.Controller, MsgBox, ACBrValidador, Vcl.DBCtrls,
  SysUtils, cxDBEdit;

Type
  TCadCliProcessos = Class(TInterfacedObject, iCadCliProcessos)
  private
    ValidaDados: TACBrValidador;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iCadCliProcessos;
    procedure ValidarNomeFantasia(Fantasia: String; edtdados: TDBEdit);
    procedure ValidarCPF(CPF: String; edtdados: TcxDBButtonEdit);
    procedure ValidarCNPJ(CNPJ: String; edtdados: TcxDBButtonEdit);
    procedure ValidarEmail(Email: String; edtdados: TDBEdit);
    procedure ValidarCep(CEP: String; edtdados: TcxDBButtonEdit);
  end;

implementation

{ TCadCliProcessos }

constructor TCadCliProcessos.Create;
begin
  ValidaDados := TACBrValidador.Create(nil);
  ValidaDados.IgnorarChar := './-';
end;

destructor TCadCliProcessos.Destroy;
begin
  FreeAndNil(ValidaDados);
  inherited;
end;

class function TCadCliProcessos.New: iCadCliProcessos;
begin
  Result := Self.Create;
end;

procedure TCadCliProcessos.ValidarCep(CEP: String; edtdados: TcxDBButtonEdit);
begin
  ValidaDados.TipoDocto := docCEP;
  ValidaDados.Documento := CEP;

  if not ValidaDados.Validar then
  begin
    msgboxsimples('CEP inv�lido.', tmbAdvertencia);
    edtdados.SetFocus;
    abort;
  end;
end;

procedure TCadCliProcessos.ValidarCNPJ(CNPJ: String; edtdados: TcxDBButtonEdit);
begin
  if not((Length(CNPJ) = 11) or (Length(CNPJ) = 14)) then
  begin
    msgboxsimples('CNPJ inv�lido.', tmbAdvertencia);
    edtdados.SetFocus;
    abort;
  end;

  if Length(edtdados.Text) = 14 then
  begin
    ValidaDados.TipoDocto := docCNPJ;
    ValidaDados.Documento := CNPJ;

    if not ValidaDados.Validar then
    begin
      msgboxsimples('CNPJ inv�lido.', tmbAdvertencia);
      edtdados.SetFocus;
      abort;
    end;
  end;
end;

procedure TCadCliProcessos.ValidarCPF(CPF: String; edtdados: TcxDBButtonEdit);
begin
  if not((Length(CPF) = 11) or (Length(CPF) = 14)) then
  begin
    msgboxsimples('CPF inv�lido.', tmbAdvertencia);
    edtdados.SetFocus;
    abort;
  end;

  if Length(edtdados.Text) = 11 then
  begin
    ValidaDados.TipoDocto := docCPF;
    ValidaDados.Documento := CPF;

    if not ValidaDados.Validar then
    begin
      msgboxsimples('CPF inv�lido.', tmbAdvertencia);
      edtdados.SetFocus;
      abort;
    end;
  end;
end;

procedure TCadCliProcessos.ValidarEmail(Email: String; edtdados: TDBEdit);
begin
  ValidaDados.TipoDocto := docEmail;
  ValidaDados.Documento := Email;

  if not ValidaDados.Validar then
  begin
    msgboxsimples('Email inv�lido.', tmbAdvertencia);
    edtdados.SetFocus;
    abort;
  end;
end;

procedure TCadCliProcessos.ValidarNomeFantasia(Fantasia: String;
  edtdados: TDBEdit);
begin
  if Fantasia.IsEmpty then
  begin
    msgboxsimples('Nome Fantasia n�o informado.', tmbAdvertencia);
    edtdados.SetFocus;
    abort;
  end;
end;

end.
