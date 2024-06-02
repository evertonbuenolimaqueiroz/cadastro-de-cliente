unit eEndereco.View.Controller;

interface

uses eEndereco.Model.Controller, ACBrCEP, Windows, Winapi.Messages, SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics, ACBrIBGE,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Cep4D,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  IdHTTP, ActiveX, ComObj, WinSock, IdSSLOpenSSL, IdURI, MsgBox;

Type
  TEndereco = Class(TInterfacedObject, iEndereco)
  private

  public
    constructor Create;
    destructor Destroy; override;
    class function New: iEndereco;
    procedure ConsultarCep(ACEP: String; out Logradouro: String;
      out Bairro: String; out IBGE: String; out Cidade: String;
      out Estado: String);
  end;

implementation

{ TEndereco }

procedure TEndereco.ConsultarCep(ACEP: String; out Logradouro, Bairro, IBGE,
  Cidade, Estado: String);
var
  LAddress: ICep4DModelAddress;
  msgError: String;
  ACBrIBGE: TACBrIBGE;
  ACBrCEP: TACBrCEP;
  iBuscaCep: Integer;
const
  DmsgError: String =
    'Não foi possível a consulta do endereço em servidores externos.' +
    sLineBreak + 'Por favor, continue o cadastro do endereço manualmente!';

  Procedure GetCep(sAddressType, vAddress, vDistrict, vIBGE, vCity,
    vState: String);
  begin
    //AddressType := sAddressType;
    Logradouro := sAddressType + ' ' + vAddress;
    Bairro := vDistrict;
    IBGE := vIBGE;
    Cidade := vCity;
    Estado := vState;
  end;

begin
  ACBrCEP := TACBrCEP.Create(nil);
  ACBrIBGE := TACBrIBGE.Create(nil);

  try
    ACBrIBGE.IgnorarCaixaEAcentos := True;
    ACEP := StringReplace(ACEP, '-', '', [rfReplaceAll]);

{$REGION 'CEP4D'}
    try
      LAddress := GetCep4D.ZipCode(ACEP).Search;

      if not(LAddress.Address = EmptyStr) then
      begin
        GetCep(LAddress.AddressType, LAddress.Address, LAddress.District,
          LAddress.IbgeCode.ToString, LAddress.City, LAddress.State);
        exit;
      end;
{$ENDREGION}
{$REGION 'WSCORREIOS'}
      ACBrCEP.WebService := wsCorreios;
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);

      if iBuscaCep > 0 then
        if not(Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
        Begin
          ACBrIBGE.IgnorarCaixaEAcentos := True;
          ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
            ACBrCEP.Enderecos[0].UF);
          ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
            .CodMunicipio.ToString;

          GetCep('', ACBrCEP.Enderecos[0].Logradouro,
            ACBrCEP.Enderecos[0].Bairro,
            ACBrIBGE.Cidades[0].CodMunicipio.ToString,
            ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
          exit;
        end;
{$ENDREGION}
{$REGION 'WSVIACEP'}
      ACBrCEP.WebService := wsViaCep;
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);

      if iBuscaCep > 0 then
        if not(Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
        Begin
          ACBrIBGE.IgnorarCaixaEAcentos := True;
          ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
            ACBrCEP.Enderecos[0].UF);
          ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
            .CodMunicipio.ToString;

          GetCep('', ACBrCEP.Enderecos[0].Logradouro,
            ACBrCEP.Enderecos[0].Bairro,
            ACBrIBGE.Cidades[0].CodMunicipio.ToString,
            ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
          exit;
        end;
{$ENDREGION}
{$REGION 'WSCORREIOSSIGEP'}
      ACBrCEP.WebService := wsCorreiosSIGEP;
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);

      if iBuscaCep > 0 then
        if not(Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
        Begin
          ACBrIBGE.IgnorarCaixaEAcentos := True;
          ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
            ACBrCEP.Enderecos[0].UF);
          ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
            .CodMunicipio.ToString;

          GetCep('', ACBrCEP.Enderecos[0].Logradouro,
            ACBrCEP.Enderecos[0].Bairro,
            ACBrIBGE.Cidades[0].CodMunicipio.ToString,
            ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
          exit;
        end;
{$ENDREGION}
{$REGION 'wsRepublicaVirtual'}
      ACBrCEP.WebService := wsRepublicaVirtual;
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);

      if iBuscaCep > 0 then
        if not(Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
        Begin
          ACBrIBGE.IgnorarCaixaEAcentos := True;
          ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
            ACBrCEP.Enderecos[0].UF);
          ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
            .CodMunicipio.ToString;

          GetCep('', ACBrCEP.Enderecos[0].Logradouro,
            ACBrCEP.Enderecos[0].Bairro,
            ACBrIBGE.Cidades[0].CodMunicipio.ToString,
            ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
          exit;
        end;
{$ENDREGION}
    except
      MsgBoxSimples(DmsgError, tmbAdvertencia);
    end;
  finally
    FreeAndNil(ACBrCEP);
    FreeAndNil(ACBrIBGE);
  end;
end;

constructor TEndereco.Create;
begin

end;

destructor TEndereco.Destroy;
begin

  inherited;
end;

class function TEndereco.New: iEndereco;
begin
  Result := Self.Create;
end;

end.
