unit eFuncoes.View.Controller;

interface

uses eFuncoes.Model.Controller, Forms, SysUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, MsgBox;

Type
  TFuncoes = Class(TInterfacedObject, iFuncoes)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iFuncoes;
    procedure CentralizarFormularioNoMultiMonitor(Form: TForm);
    function fFormata(Texto: string; Caracter: string; Posicao: string;
      Tamanho: Integer; Upper: Boolean = true): string;
    function ValidarCamposRequerido(FD: TFDQuery): Boolean;
    function fRemoveFormatoCarEsp(Texto: string): string;
  end;

implementation

{ TFuncoes }

function TFuncoes.ValidarCamposRequerido(FD: TFDQuery): Boolean;
var
  i: Integer;
  lmensagem: string;
begin
  lmensagem := '';
  Result := true;
  for i := 0 to FD.FieldCount - 1 do
    if FD.Fields[i].Required then
    begin
      if (trim(FD.Fields[i].AsString) = '') then
      begin
        if lmensagem = '' then
          lmensagem := lmensagem +
            '* Campo(s) Obrigat�rio(s) n�o Preenchido(s): ' + #13 + #10 + #13 +
            #10 + '- ' + FD.Fields[i].DisplayName + ' ' + #13 + #10
        else
          lmensagem := lmensagem + '- ' + FD.Fields[i].DisplayName + ' ' +
            #13 + #10;
        Result := False;
      end;
    end;
  if lmensagem <> '' then
  Begin
    msgboxsimples(lmensagem, tmbadvertencia);
    Result := False;
  End;
end;

procedure TFuncoes.CentralizarFormularioNoMultiMonitor(Form: TForm);
var
  i: Integer;
  TotalWidth, TotalHeight, MinLeft, MinTop: Integer;
begin
  TotalWidth := 0;
  TotalHeight := 0;
  MinLeft := Screen.Monitors[0].Left;
  MinTop := Screen.Monitors[0].Top;

  // Calcula a largura total e a altura total da �rea de todos os monitores
  for i := 0 to Screen.MonitorCount - 1 do
  begin
    with Screen.Monitors[i] do
    begin
      if Left < MinLeft then
        MinLeft := Left;
      if Top < MinTop then
        MinTop := Top;
      if Left + Width > TotalWidth then
        TotalWidth := Left + Width;
      if Top + Height > TotalHeight then
        TotalHeight := Top + Height;
    end;
  end;

  // Ajusta as dimens�es totais considerando os monitores mais � esquerda e acima
  TotalWidth := TotalWidth - MinLeft;
  TotalHeight := TotalHeight - MinTop;

  // Centraliza o formul�rio
  Form.Left := ((TotalWidth - Form.Width) div 2) + MinLeft;
  Form.Top := ((TotalHeight - Form.Height) div 2) + MinTop;
end;

constructor TFuncoes.Create;
begin

end;

destructor TFuncoes.Destroy;
begin

  inherited;
end;

function TFuncoes.fFormata(Texto, Caracter, Posicao: string; Tamanho: Integer;
  Upper: Boolean): string;
var
  Y: Integer;
  f: string;
Begin

  f := Texto;
  Posicao := uppercase(Posicao);

  if (length(Texto)) > Tamanho then
  begin
    f := Copy(Texto, 1, Tamanho);
  end;

  for Y := 1 to Tamanho - (length(Texto)) do
  Begin

    if (Posicao = 'E') or (Posicao = 'e') then
    begin
      f := Caracter + f;
    end
    else if (Posicao = 'C') or (Posicao = 'c') then
    begin
      f := Caracter + f + Caracter;
      if Y >= ((Tamanho - length(Texto)) / 2) then
        Break;
    end
    else
    begin
      f := f + Caracter;
    end;
  End;

  if Upper then
    Result := uppercase(f)
  else
    Result := f;
End;

class function TFuncoes.New: iFuncoes;
begin
  Result := Self.Create;
end;

function TFuncoes.fRemoveFormatoCarEsp(Texto: string): string;
var
  Aux: string;
begin

  Aux := Texto;
  Aux := StringReplace(Aux, '/', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ',', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '.', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ':', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '-', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '(', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ')', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '-', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '*', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '&', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '%', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '$', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '#', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '@', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '!', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '_', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '=', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '+', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '"', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '`', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '�', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ';', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '<', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '>', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ',', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '{', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '}', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '[', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, ']', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '\', '', [rfReplaceAll]);

  fRemoveFormatoCarEsp := Aux;

end;

end.
