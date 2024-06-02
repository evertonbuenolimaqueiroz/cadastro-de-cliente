unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    con: TFDConnection;
    qrycadcli: TFDQuery;
    qrycadcliID: TIntegerField;
    qrycadcliFANTASIA: TStringField;
    qrycadcliCPFCNPJ: TStringField;
    qrycadcliCEP: TStringField;
    qrycadcliENDERECO: TStringField;
    qrycadcliNUMERO: TStringField;
    qrycadcliCOMPLEMENTO: TStringField;
    qrycadcliBAIRRO: TStringField;
    qrycadcliCIDADE: TStringField;
    qrycadcliIBGE: TStringField;
    qrycadcliEMAIL: TStringField;
    qrycadcliTELEFONE: TStringField;
    qrycadcliESTADO: TStringField;
    procedure qrycadcliBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses eFuncoes.View.Controller;

{$R *.dfm}

procedure TDM.qrycadcliBeforePost(DataSet: TDataSet);
begin
  if not TFuncoes.New.ValidarCamposRequerido(qrycadcli) then
    Abort;
end;

end.
