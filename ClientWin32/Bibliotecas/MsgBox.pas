unit MsgBox;

interface

uses
  Windows, Forms;

const
  MB_TIMEDOUT = 32000;

function MessageBoxTimeOut(hWnd: hWnd; lpText: PAnsiChar; lpCaption: PAnsiChar;
  uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall;
  external user32 name 'MessageBoxTimeoutA';

type
  TTiposMsgBox = (tmbInformacao, tmbAdvertencia, tmbErro);
  TRetornosMsgBox = (rmbSim, rmbNao, rmbCancelar);

procedure MsgBoxSimples(Msg: string; TipoMsgBox: TTiposMsgBox;
  HndWnd: THandle = 0);
function MsgBoxConfirmacao(Msg: string; HndWnd: THandle = 0;
  BotaoCancelar: Boolean = False): TRetornosMsgBox;

implementation

procedure AcertarHndWnd(var HndWnd: THandle);
begin
  try
    if HndWnd = 0 then
      HndWnd := Screen.ActiveForm.Handle;
  except
  end;
end;

function MsgBoxConfirmacao(Msg: string; HndWnd: THandle = 0;
  BotaoCancelar: Boolean = False): TRetornosMsgBox;
var
  Botoes: Integer;
  Retorno: Integer;
begin
  AcertarHndWnd(HndWnd);
  if BotaoCancelar then
    Botoes := MB_YESNOCANCEL
  else
    Botoes := MB_YESNO;
  Retorno := MessageBox(HndWnd, PChar(Msg), 'Confirmação',
    MB_ICONQUESTION or Botoes);
  case Retorno of
    ID_YES:
      Result := rmbSim;
    ID_NO:
      Result := rmbNao;
  else
    Result := rmbCancelar;
  end;
end;

procedure MsgBoxSimples(Msg: string; TipoMsgBox: TTiposMsgBox;
  HndWnd: THandle = 0);
const
  Captions: array [TTiposMsgBox] of PChar = ('Informação',
    'Advertência', 'Erro');
  Tipos: array [TTiposMsgBox] of Integer = (MB_ICONINFORMATION, MB_ICONWARNING,
    MB_ICONERROR);
begin
  AcertarHndWnd(HndWnd);
  MessageBox(HndWnd, PChar(Msg), Captions[TipoMsgBox], Tipos[TipoMsgBox]);
  Screen.Cursor := 0;
end;

end.
