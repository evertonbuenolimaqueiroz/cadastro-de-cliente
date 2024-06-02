unit uBuscaCEPConsolare;

interface

uses ACBrCEP, Windows, Winapi.Messages, SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, ACBrIBGE,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Cep4D,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  IdHTTP, ActiveX, ComObj, WinSock, IdSSLOpenSSL, IdURI;

Type
  TCepConsolare = class(TACBrCEP)
  private
    { private declarations }
    FAddressType: String;
    FAddress: String;
    FDistrict: String;
    FIBGE: String;
    FCity: String;
    FSate: String;
    FState: String;
    procedure SetAddress(const Value: String);
    procedure SetAddressType(const Value: String);
    procedure SetCity(const Value: String);
    procedure SetDistrict(const Value: String);
    procedure SetIBGE(const Value: String);
    procedure SetState(const Value: String);
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create();
    destructor Destroy; override;
    procedure BuscarPorCEPConsolare(ACEP: String);
  published
    { published declarations }
    property AddressType: String read FAddressType write SetAddressType;
    property Address: String read FAddress write SetAddress;
    property District: String read FDistrict write SetDistrict;
    property IBGE: String read FIBGE write SetIBGE;
    property City: String read FCity write SetCity;
    property State: String read FState write SetState;
  end;

procedure ConsolareBuscaCep(ACEP: String; out Logradouro: String;
  out Bairro: String; out IBGE: String; out Cidade: String; out Estado: String);

implementation

{ TCepConsolare }

uses Gz.MSG;

procedure TCepConsolare.BuscarPorCEPConsolare(ACEP: String);
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
    AddressType := sAddressType;
    Address := vAddress;
    District := vDistrict;
    IBGE := vIBGE;
    City := vCity;
    State := vState;
    { edtDDD.Text := LAddress.DDD.ToString;
      edtLatitude.Text := LAddress.Latitude.ToString;
      edtLongitude.Text := LAddress.Longitude.ToString; }
  end;

begin
  ACBrCEP := TACBrCEP.Create(nil);
  ACBrIBGE := TACBrIBGE.Create(nil);

  try
    ACBrIBGE.IgnorarCaixaEAcentos := True;

    {$REGION 'CEP4D'}
    try
      LAddress := GetCep4D.ZipCode(ACEP).Search;
      msgError := EmptyStr;
    except
      //on e: exception do
      //  msgError := DmsgError;
    end;

    if not(LAddress.Address = EmptyStr) then
    begin
      GetCep(LAddress.AddressType, LAddress.Address, LAddress.District,
        LAddress.IbgeCode.ToString, LAddress.City, LAddress.State);
      exit;
    end;
    {$ENDREGION}

    {$REGION 'WSCORREIOS'}
    ACBrCEP.WebService := wsCorreios;

    try
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);
      msgError := EmptyStr;
    except
      on e: exception do
        msgError := DmsgError;
    end;

    if iBuscaCep > 0 then
      if not (Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
      Begin
        ACBrIBGE.IgnorarCaixaEAcentos := True;
        ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
          ACBrCEP.Enderecos[0].UF);
        ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
          .CodMunicipio.ToString;

        GetCep('', ACBrCEP.Enderecos[0].Logradouro, ACBrCEP.Enderecos[0].Bairro,
          ACBrIBGE.Cidades[0].CodMunicipio.ToString,
          ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
        exit;
      end;
    {$ENDREGION}

    {$REGION 'WSVIACEP'}
    ACBrCEP.WebService := wsViaCep;

    try
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);
      msgError := EmptyStr;
    except
      on e: exception do
        msgError := DmsgError;
    end;

    if iBuscaCep > 0 then
      if not (Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
      Begin
        ACBrIBGE.IgnorarCaixaEAcentos := True;
        ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
          ACBrCEP.Enderecos[0].UF);
        ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
          .CodMunicipio.ToString;

        GetCep('', ACBrCEP.Enderecos[0].Logradouro, ACBrCEP.Enderecos[0].Bairro,
          ACBrIBGE.Cidades[0].CodMunicipio.ToString,
          ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
        exit;
      end;
    {$ENDREGION}

    {$REGION 'WSCORREIOSSIGEP'}
    ACBrCEP.WebService := wsCorreiosSIGEP;

    try
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);
      msgError := EmptyStr;
    except
      on e: exception do
        msgError := DmsgError;
    end;

    if iBuscaCep > 0 then
      if not (Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
      Begin
        ACBrIBGE.IgnorarCaixaEAcentos := True;
        ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
          ACBrCEP.Enderecos[0].UF);
        ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
          .CodMunicipio.ToString;

        GetCep('', ACBrCEP.Enderecos[0].Logradouro, ACBrCEP.Enderecos[0].Bairro,
          ACBrIBGE.Cidades[0].CodMunicipio.ToString,
          ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
        exit;
      end;
    {$ENDREGION}

    {$REGION 'wsRepublicaVirtual'}
    ACBrCEP.WebService := wsRepublicaVirtual;

    try
      iBuscaCep := ACBrCEP.BuscarPorCEP(ACEP);
      msgError := EmptyStr;
    except
      on e: exception do
        msgError := DmsgError;
    end;

    if iBuscaCep > 0 then
      if not (Trim(ACBrCEP.Enderecos[0].IBGE_Municipio) = EmptyStr) then
      Begin
        ACBrIBGE.IgnorarCaixaEAcentos := True;
        ACBrIBGE.BuscarPorNome(ACBrCEP.Enderecos[0].Municipio,
          ACBrCEP.Enderecos[0].UF);
        ACBrCEP.Enderecos[0].IBGE_Municipio := ACBrIBGE.Cidades[0]
          .CodMunicipio.ToString;

        GetCep('', ACBrCEP.Enderecos[0].Logradouro, ACBrCEP.Enderecos[0].Bairro,
          ACBrIBGE.Cidades[0].CodMunicipio.ToString,
          ACBrCEP.Enderecos[0].Municipio, ACBrCEP.Enderecos[0].UF);
        exit;
      end;
    {$ENDREGION}

    if msgError <> EmptyStr then
      MsgBoxAlerta(msgError);
  finally
    FreeAndNil(ACBrCEP);
    FreeAndNil(ACBrIBGE);
  end;
end;

constructor TCepConsolare.Create;
begin

end;

destructor TCepConsolare.Destroy;
begin

  inherited;
end;

procedure TCepConsolare.SetAddress(const Value: String);
begin
  FAddress := Value;
end;

procedure TCepConsolare.SetAddressType(const Value: String);
begin
  FAddressType := Value;
end;

procedure TCepConsolare.SetCity(const Value: String);
begin
  FCity := Value;
end;

procedure TCepConsolare.SetDistrict(const Value: String);
begin
  FDistrict := Value;
end;

procedure TCepConsolare.SetIBGE(const Value: String);
begin
  FIBGE := Value;
end;

procedure TCepConsolare.SetState(const Value: String);
begin
  FState := Value;
end;

procedure ConsolareBuscaCep(ACEP: String; out Logradouro: String;
  out Bairro: String; out IBGE: String; out Cidade: String; out Estado: String);
var
  Cep: TCepConsolare;
begin
  if ACEP = EmptyStr then
    exit;

  if Length(ACEP) < 8 then
  begin
    MsgBoxAlerta('CEP informado inválido.');
    exit;
  end;

  Cep := TCepConsolare.Create;

  try
    Cep.BuscarPorCEPConsolare(ACEP);
    Logradouro := Cep.Address;
    Bairro := Cep.District;
    IBGE := Cep.IBGE;
    Cidade := Cep.City;
    Estado := Cep.State
  finally
    FreeAndNil(Cep);
  end;
end;

end.
