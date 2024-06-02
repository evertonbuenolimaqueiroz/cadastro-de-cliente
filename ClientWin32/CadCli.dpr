program CadCli;

uses
  Vcl.Forms,
  uCadCliente in 'uCadCliente.pas' {fCadCli},
  eEndereco.Model.Controller in 'Interface\eEndereco.Model.Controller.pas',
  eEndereco.View.Controller in 'Interface\eEndereco.View.Controller.pas',
  uDM in 'Modulos\uDM.pas' {DM: TDataModule},
  eFuncoes.Model.Controller in 'Interface\eFuncoes.Model.Controller.pas',
  eFuncoes.View.Controller in 'Interface\eFuncoes.View.Controller.pas',
  eCadCliProcessos.Model.Controller in 'Interface\eCadCliProcessos.Model.Controller.pas',
  eCadCliProcessos.View.Controller in 'Interface\eCadCliProcessos.View.Controller.pas',
  UCNPJWS in 'Bibliotecas\UCNPJWS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfCadCli, fCadCli);
  Application.Run;
end.
