unit uCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  cxControls, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, HTMLText, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls, cxContainer,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxDBEdit, MsgBox, JvComponentBase,
  JvEnterTab, ACBrBase, ACBrValidador, MaskUtils, System.RegularExpressions;

type
  TfCadCli = class(TForm)
    pnmenu: TPanel;
    btnnovo: TcxButton;
    btneditar: TcxButton;
    btnexcluir: TcxButton;
    Panel4: TPanel;
    btnsalvar: TcxButton;
    btncancelar: TcxButton;
    Panel5: TPanel;
    ds: TDataSource;
    pgviscad: TPageControl;
    tsconsulta: TTabSheet;
    cxGridConsulta: TcxGrid;
    cxGridTableViewConsulta: TcxGridDBTableView;
    cxGridLevelConsulta: TcxGridLevel;
    tscadastro: TTabSheet;
    pccadastro: TPageControl;
    pncadastro: TPanel;
    edthtmltop: THTMLStaticText;
    sbcad: TScrollBox;
    pncadcli: TPanel;
    lblnome: TLabel;
    edtfantasia: TDBEdit;
    Label1: TLabel;
    spendereco: TShape;
    lblcep: TLabel;
    lblfantasia: TLabel;
    edtendereco: TDBEdit;
    lblnumero: TLabel;
    edtnumero: TDBEdit;
    lblcomplemento: TLabel;
    edtcomplemento: TDBEdit;
    lblbairro: TLabel;
    edtbairro: TDBEdit;
    lblcidade: TLabel;
    edtcidade: TDBEdit;
    lblibge: TLabel;
    edtibge: TDBEdit;
    lblemail: TLabel;
    edtemail: TDBEdit;
    lbltelefone: TLabel;
    edttelefone: TDBEdit;
    edtcep: TcxDBButtonEdit;
    cxGridTableViewConsultaID: TcxGridDBColumn;
    cxGridTableViewConsultaFANTASIA: TcxGridDBColumn;
    cxGridTableViewConsultaCPFCNPJ: TcxGridDBColumn;
    cxGridTableViewConsultaCEP: TcxGridDBColumn;
    cxGridTableViewConsultaENDERECO: TcxGridDBColumn;
    cxGridTableViewConsultaNUMERO: TcxGridDBColumn;
    cxGridTableViewConsultaCOMPLEMENTO: TcxGridDBColumn;
    cxGridTableViewConsultaBAIRRO: TcxGridDBColumn;
    cxGridTableViewConsultaCIDADE: TcxGridDBColumn;
    cxGridTableViewConsultaIBGE: TcxGridDBColumn;
    cxGridTableViewConsultaEMAIL: TcxGridDBColumn;
    cxGridTableViewConsultaTELEFONE: TcxGridDBColumn;
    lblobrigatorio01: TLabel;
    lblobrigatorio02: TLabel;
    lblobrigatorio03: TLabel;
    JvEnterAsTab: TJvEnterAsTab;
    lbluf: TLabel;
    edtuf: TDBEdit;
    edtcpfcnpj: TcxDBButtonEdit;
    procedure dsStateChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnnovoClick(Sender: TObject);
    procedure btneditarClick(Sender: TObject);
    procedure btnexcluirClick(Sender: TObject);
    procedure btnsalvarClick(Sender: TObject);
    procedure btncancelarClick(Sender: TObject);
    procedure pgviscadChange(Sender: TObject);
    procedure edtcepPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure edttelefoneChange(Sender: TObject);
    procedure edtcepPropertiesChange(Sender: TObject);
    procedure edtcpfcnpjPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGridTableViewConsultaCellDblClick
      (Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    procedure ValidarDados;
  public
    { Public declarations }
  end;

var
  fCadCli: TfCadCli;

implementation

{$R *.dfm}

uses eFuncoes.View.Controller, uDM, eEndereco.View.Controller,
  eCadCliProcessos.View.Controller, UCNPJWS;

procedure TfCadCli.btncancelarClick(Sender: TObject);
begin
  try
    ds.DataSet.cancel;
    pgviscad.ActivePageIndex := 0;
    cxGridTableViewConsulta.ApplyBestFit();
  except
    on e: exception do
    begin
      msgboxsimples('[005] - Falha: ' + e.Message, tmbAdvertencia);
    end;
  end;

end;

procedure TfCadCli.btneditarClick(Sender: TObject);
begin
  try
    if ds.DataSet.IsEmpty then
    begin
      msgboxsimples('Selecione um cliente para editar.', tmbAdvertencia);
      pgviscad.ActivePageIndex := 0;
      exit;
    end;

    ds.DataSet.Edit;
    pgviscad.ActivePageIndex := 1;
    edtcpfcnpj.SetFocus;
  except
    on e: exception do
    begin
      msgboxsimples('[002] - Falha: ' + e.Message, tmbAdvertencia);
    end;
  end;

end;

procedure TfCadCli.btnexcluirClick(Sender: TObject);
begin
  try
    if ds.DataSet.IsEmpty then
      exit;

    if MsgBoxConfirmacao('Deseja Excluir o Registro Selecionado?') = rmbNao then
      exit;
    ds.DataSet.Delete;
    pgviscad.ActivePageIndex := 0;
  except
    on e: exception do
    begin
      msgboxsimples('[003] - Falha: ' + e.Message, tmbAdvertencia);
    end;
  end;
end;

procedure TfCadCli.btnnovoClick(Sender: TObject);
begin
  try
    ds.DataSet.Insert;
    pgviscad.ActivePageIndex := 1;
    edtcpfcnpj.SetFocus;
  except
    on e: exception do
    begin
      msgboxsimples('[001] - Falha: ' + e.Message, tmbAdvertencia);
    end;
  end;
end;

procedure TfCadCli.btnsalvarClick(Sender: TObject);
begin
  ValidarDados;

  try
    ds.DataSet.post;
    pgviscad.ActivePageIndex := 0;
    ds.DataSet.Close;
    ds.DataSet.Open;
    cxGridTableViewConsulta.ApplyBestFit();
  except
    on e: exception do
    begin
      msgboxsimples('[004] - Falha: ' + e.Message, tmbAdvertencia);
    end;
  end;

end;

procedure TfCadCli.cxGridTableViewConsultaCellDblClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if ds.DataSet.IsEmpty then
    exit;

  btneditarClick(nil)
end;

procedure TfCadCli.dsStateChange(Sender: TObject);
var
  html: TStrings;
begin
  html := TStringList.Create;
  try
    html.Text := '<b>C�digo: </b> ' + TFuncoes.new.fformata
      (ds.DataSet.fieldByname('id').AsString, '0', 'E', 6) +
      ' <b> Descri��o: </b>' + ds.DataSet.fieldByname('fantasia').AsString;
    edthtmltop.HTMLText := html;
  finally
    freeandnil(html);
  end;

  btnnovo.Enabled := not(ds.DataSet.State in [dsinsert, dsedit]);
  btneditar.Enabled := not(ds.DataSet.State in [dsinsert, dsedit]);
  btnexcluir.Enabled := not(ds.DataSet.State in [dsinsert, dsedit]);
  btnsalvar.Enabled := ds.DataSet.State in [dsinsert, dsedit];
  btncancelar.Enabled := ds.DataSet.State in [dsinsert, dsedit]
end;

procedure TfCadCli.edtcepPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var
  Endereco, Bairro, IBGE, Cidade, UF: String;
begin
  TCadCliProcessos.new.ValidarCep(edtcep.Text, edtcep);

  TEndereco.new.ConsultarCep(edtcep.Text, Endereco, Bairro, IBGE, Cidade, UF);

  edtendereco.Text := Endereco;
  ds.DataSet.fieldByname('endereco').AsString := Endereco;
  edtbairro.Text := Bairro;
  ds.DataSet.fieldByname('bairro').AsString := Bairro;
  edtibge.Text := IBGE;
  ds.DataSet.fieldByname('ibge').AsString := IBGE;
  edtcidade.Text := Cidade;
  ds.DataSet.fieldByname('cidade').AsString := Cidade;
  edtuf.Text := UF;
  ds.DataSet.fieldByname('estado').AsString := UF;
  edtnumero.SetFocus;
end;

procedure TfCadCli.edtcepPropertiesChange(Sender: TObject);
var
  TextoSemFormatacao, TextoOriginal: string;
  CursorPos, Diferenca: Integer;
begin
  TextoOriginal := edtcep.Text;
  CursorPos := edtcep.SelStart;
  TextoSemFormatacao := TRegEx.Replace(TextoOriginal, '[^\d]', '');

  if Length(TextoSemFormatacao) > 5 then
    TextoSemFormatacao := Copy(TextoSemFormatacao, 1, 5) + '-' +
      Copy(TextoSemFormatacao, 6, 3)
  else
    TextoSemFormatacao := Copy(TextoSemFormatacao, 1,
      Length(TextoSemFormatacao));

  edtcep.Text := TextoSemFormatacao;
  Diferenca := Length(TextoSemFormatacao) - Length(TextoOriginal);
  edtcep.SelStart := CursorPos + Diferenca;
  if (CursorPos > 5) and (TextoOriginal[CursorPos - 1] = '-') and (Diferenca < 0)
  then
    edtcep.SelStart := CursorPos - 1;
end;

procedure TfCadCli.edtcpfcnpjPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var
  LEmpresa: TEmpresaClass;
  ie: TInscricoes_estaduaisClass;
begin
  LEmpresa := TCnpjWs.Consultar(TFuncoes.new.fRemoveFormatoCarEsp
    (edtcpfcnpj.Text));
  if LEmpresa <> nil then
  begin
    // Tipo := LEmpresa.estabelecimento.Tipo;
    // RazaoSocial := LEmpresa.razao_social;
    // Abertura := DateToStr(LEmpresa.estabelecimento.data_inicio_atividade);
    edtfantasia.Text := LEmpresa.estabelecimento.nome_fantasia;
    ds.DataSet.fieldByname('fantasia').AsString := edtfantasia.Text;
    edtendereco.Text := LEmpresa.estabelecimento.logradouro;
    ds.DataSet.fieldByname('endereco').AsString := edtendereco.Text;
    edtnumero.Text := LEmpresa.estabelecimento.numero;
    ds.DataSet.fieldByname('numero').AsString := edtnumero.Text;
    edtcomplemento.Text := LEmpresa.estabelecimento.complemento;
    ds.DataSet.fieldByname('complemento').AsString := edtcomplemento.Text;
    edtbairro.Text := LEmpresa.estabelecimento.Bairro;
    ds.DataSet.fieldByname('bairro').AsString := edtbairro.Text;
    edtcidade.Text := LEmpresa.estabelecimento.Cidade.nome;
    ds.DataSet.fieldByname('cidade').AsString := edtcidade.Text;
    edtuf.Text := LEmpresa.estabelecimento.estado.sigla;
    ds.DataSet.fieldByname('estado').AsString := edtuf.Text;
    edtcep.Text := LEmpresa.estabelecimento.cep;
    // situacao := LEmpresa.estabelecimento.situacao_cadastral;
    ds.DataSet.fieldByname('cep').AsString := edtcep.Text;
    edttelefone.Text := LEmpresa.estabelecimento.ddd1 +
      LEmpresa.estabelecimento.Telefone1;
    // Telefone2 := LEmpresa.estabelecimento.ddd2 +
    // LEmpresa.estabelecimento.Telefone2;
    // cnpj := EditCNPJ.Text;
    ds.DataSet.fieldByname('telefone').AsString := edttelefone.Text;
    edtibge.Text := floattostr(LEmpresa.estabelecimento.Cidade.ibge_id);
    ds.DataSet.fieldByname('ibge').AsString := edtibge.Text;
    edtemail.Text := LEmpresa.estabelecimento.email;
    ds.DataSet.fieldByname('email').AsString := edtemail.Text;
  end;

  { for ie in LEmpresa.estabelecimento.inscricoes_estaduais do
    if (ie.ativo) and (ie.estado.sigla = LEmpresa.estabelecimento.estado.sigla)
    then
    begin
    RGIE := ie.Inscricao_estadual;
    end; }
end;

procedure TfCadCli.edttelefoneChange(Sender: TObject);
var
  TextoSemFormatacao, TextoFormatado: string;
  CursorPos, TextLengthBefore, TextLengthAfter, Adjustment: Integer;
begin
  CursorPos := edttelefone.SelStart;
  TextoSemFormatacao := TRegEx.Replace(edttelefone.Text, '[^\d]', '');
  TextLengthBefore := Length(edttelefone.Text);

  if Length(TextoSemFormatacao) > 10 then
    TextoFormatado := FormatMaskText('!(00) 00000-0000;0;', TextoSemFormatacao)
  else if Length(TextoSemFormatacao) > 6 then
    TextoFormatado := FormatMaskText('!(00) 0000-0000;0;', TextoSemFormatacao)
  else
    TextoFormatado := TextoSemFormatacao;

  edttelefone.Text := TextoFormatado;
  TextLengthAfter := Length(edttelefone.Text);
  Adjustment := TextLengthAfter - TextLengthBefore;
  edttelefone.SelStart := CursorPos + Adjustment;

  if (CursorPos > 1) and (edttelefone.Text[CursorPos - 1] in ['(', ')', ' ',
    '-']) then
    edttelefone.SelStart := edttelefone.SelStart + 1;
end;

procedure TfCadCli.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ds.DataSet.State in [dsinsert, dsedit] then
  begin
    if MsgBoxConfirmacao('Todos os dados ser�o perdidos. Deseja continuar?') = rmbNao
    then
      Abort;
  end;
end;

procedure TfCadCli.FormCreate(Sender: TObject);
begin
  pgviscad.ActivePageIndex := 0;
end;

procedure TfCadCli.FormPaint(Sender: TObject);
begin
  TFuncoes.new.CentralizarFormularioNoMultiMonitor(self);
end;

procedure TfCadCli.FormResize(Sender: TObject);
begin
  pncadcli.Left := (sbcad.ClientWidth div 2) - (pncadcli.Width div 2);
  pncadcli.Top := (sbcad.ClientHeight div 2) - (pncadcli.Height div 2);
end;

procedure TfCadCli.FormShow(Sender: TObject);
begin
  ds.DataSet.Close;
  ds.DataSet.Open;

  cxGridTableViewConsulta.ApplyBestFit();
end;

procedure TfCadCli.pgviscadChange(Sender: TObject);
begin
  if (ds.DataSet.IsEmpty) and not(ds.DataSet.State in [dsinsert, dsedit]) then
  begin
    msgboxsimples('Cadastro de Cliente(s), sem informa��o. ' + sLineBreak +
      'Clique em incluir para cadastrar um novo cliente.', tmbAdvertencia);
    pgviscad.ActivePageIndex := 0;
  end;

  if (ds.DataSet.State in [dsinsert, dsedit]) and (pgviscad.ActivePageIndex = 1)
  then
  begin
    if MsgBoxConfirmacao('Todos os dados ser�o perdidos. Deseja continuar?') = rmbSim
    then
    begin
      ds.DataSet.cancel;
      pgviscad.ActivePageIndex := 0;
    end;
  end;
end;

procedure TfCadCli.ValidarDados;
begin
  TCadCliProcessos.new.ValidarNomeFantasia(edtfantasia.Text, edtfantasia);
  TCadCliProcessos.new.ValidarCPF(edtcpfcnpj.Text, edtcpfcnpj);
  TCadCliProcessos.new.ValidarCNPJ(edtcpfcnpj.Text, edtcpfcnpj);
  TCadCliProcessos.new.ValidarEmail(edtemail.Text, edtemail);
  TCadCliProcessos.new.ValidarCep(edtcep.Text, edtcep);
end;

end.
