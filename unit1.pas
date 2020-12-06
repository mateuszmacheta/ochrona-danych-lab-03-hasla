// Hasła - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, Math;

type

  { TForm1 }
  IntArray = array of integer;

  TForm1 = class(TForm)
    Button1: TButton;
    Button_odg: TButton;
    Button_zapisz: TButton;
    Button_sprawdz: TButton;
    Button_info: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label6: TLabel;
    Memo1: TMemo;
    odgWielkie: TCheckBox;
    odgMale: TCheckBox;
    odgCyfry: TCheckBox;
    odgSpecjal: TCheckBox;
    Edit_odgDlugosc: TEdit;
    Edit_dlugosc: TEdit;
    Edit_haslo: TEdit;
    Edit_maxDlugosc: TEdit;
    Edit_wielkieMin: TEdit;
    Edit_maleMin: TEdit;
    Edit_cyfryMin: TEdit;
    Edit_specjalMin: TEdit;
    Edit_minDlugosc: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Max: TLabel;
    Min: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button_infoClick(Sender: TObject);
    procedure Button_odgClick(Sender: TObject);
    procedure Button_sprawdzClick(Sender: TObject);
    procedure Button_zapiszClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure Edit_hasloChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure odgCyfryChange(Sender: TObject);
    procedure odgMaleChange(Sender: TObject);
    procedure odgSpecjalChange(Sender: TObject);
    procedure odgWielkieChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

var
  odgZnaki: string;

procedure odswiezOdgZnaki;
var
  znak: char;
begin
  odgZnaki := '';
  if (Form1.odgWielkie.Checked) then
  begin
    for znak in [char(65)..char(90)] do
      odgZnaki := odgZnaki + znak;
  end;

  if (Form1.odgMale.Checked) then
  begin
    for znak in [char(97)..char(122)] do
      odgZnaki := odgZnaki + znak;
  end;

  if (Form1.odgCyfry.Checked) then
  begin
    for znak in [char(48)..char(57)] do
      odgZnaki := odgZnaki + znak;
  end;

  if (Form1.odgSpecjal.Checked) then
  begin
    for znak in [char(33)..char(47), char(58)..char(64), char(
        91)..char(96), char(123)..char(126)] do
      odgZnaki := odgZnaki + znak;
  end;


  Form1.Memo1.Append('Zestaw znaków do celów odgadnięcia hasła: ' + odgZnaki);
end;

function odgadnijHaslo: bool;
var
  baza, dlugosc, max, i, j, k, zwiekszO: integer;
var
  czas: TDateTime;
var
  msg: string;
var
  kombinacja: IntArray;
begin
  baza := odgZnaki.Length;
  dlugosc := StrToInt(Form1.Edit_odgDlugosc.Text);
  SetLength(kombinacja, dlugosc);
  for j := 0 to dlugosc - 1 do
    kombinacja[j] := 0;
  max := baza ** dlugosc;
  Form1.Memo1.Append('Ilość kombinacji haseł: ' + IntToStr(max));
  czas := Now;
  msg := '';
  for i := 0 to max - 1 do
  begin
    if (i <> 0) and (i mod 900 = 0) then
      Form1.Memo1.Append('Sprawdzono ' + IntToStr(i) + ' kombinacji w ' +
        IntToStr(SecondsBetween(Now, czas)) + ' sekund. Ostatnie sprawdzone haslo: ' + msg);
    msg := '';
    for k in kombinacja do
      msg := msg + odgZnaki[k + 1];

    zwiekszO := 1;
    for j := dlugosc - 1 downto 0 do
    begin
      kombinacja[j] += zwiekszO;
      if (kombinacja[j] >= baza) then
      begin
        kombinacja[j] := 0;
        zwiekszO := 1;
      end
      else
        zwiekszO := 0;
    end;

    if (msg = Form1.Edit_haslo.Text) then
    begin
      Form1.Memo1.Append('Haslo odgadniete po ' + IntToStr(i) +
        ' kombinacjach w ' + IntToStr(SecondsBetween(Now, czas)) +
        ' sekund. Znalezione haslo: ' + msg);
      exit(True);
    end;
  end;
  Form1.Memo1.Append('Haslo nie zostalo odgadniete po  ' + IntToStr(i) +
    ' kombinacjach w ' + IntToStr(SecondsBetween(Now, czas)) +
    ' sekund. Ostatnie probowane haslo: ' + msg);
  exit(False);
end;

function WalidacjaDlugosc: bool;
var
  DlugoscHasla: integer;
begin
  DlugoscHasla := Form1.Edit_haslo.GetTextLen;
  WalidacjaDlugosc := True;
  if (Form1.Edit_minDlugosc.GetTextLen > 0) then
    WalidacjaDlugosc := (DlugoscHasla >= StrToInt(Form1.Edit_minDlugosc.Text));
  if (Form1.Edit_maxDlugosc.GetTextLen > 0) then
    WalidacjaDlugosc := WalidacjaDlugosc and (DlugoscHasla <=
      StrToInt(Form1.Edit_maxDlugosc.Text));
end;

function WalidacjaWielkieLitery(litera: char): integer;
begin
  if litera in [char(65)..char(90)] then
    exit(1);
  exit(0);
end;

function WalidacjaMaleLitery(litera: char): integer;
begin
  if litera in [char(97)..char(122)] then
    exit(1);
  exit(0);
end;

function WalidacjaCyfry(litera: char): integer;
begin
  if litera in [char(48)..char(57)] then
    exit(1);
  exit(0);
end;

function WalidacjaSpecjalne(litera: char): integer;
begin
  if litera in [char(33)..char(47), char(58)..char(64), char(91)..char(
    96), char(123)..char(126)] then
    exit(1);
  exit(0);
end;

function WalidacjaPolskie(litera: char): integer;
begin
  if litera > char(127) then
    exit(1);
  exit(0);
end;

function WalidacjaHasla: integer;
var
  minWielkie, minMale, minCyfry, minSpecjal: integer;
var
  wielkieL, maleL, cyfryL, specjalL: integer;
var
  znak: char;
var
  bezSpecjal, bezPolskie: bool;
var
  msg: string;
begin
  // dlugosc
  if (not WalidacjaDlugosc) then
  begin
    Application.MessageBox('Hasło posiada niepoprawną długość',
      'Walidacja', MB_OK);
    exit(0);
  end;
  minWielkie := -1;
  minMale := -1;
  minCyfry := -1;
  minSpecjal := -1;
  wielkieL := 0;
  maleL := 0;
  cyfryL := 0;
  specjalL := 0;

  // wykluczenia
  bezSpecjal := Form1.CheckBox5.Checked;
  bezPolskie := Form1.CheckBox6.Checked;

  // przypisz minimalne wartosci do zmiennych jesli checkbox jest ustawiony
  if (Form1.CheckBox1.Checked) then
    minWielkie := StrToInt(Form1.Edit_wielkieMin.Text);
  if (Form1.Checkbox2.Checked) then
    minMale := StrToInt(Form1.Edit_maleMin.Text);
  if (Form1.Checkbox3.Checked) then
    minCyfry := StrToInt(Form1.Edit_cyfryMin.Text);
  if (Form1.Checkbox4.Checked) then
    minSpecjal := StrToInt(Form1.Edit_specjalMin.Text);

  // sprawdz wszystkie znaki w hasle
  for znak in Form1.Edit_haslo.Text do
  begin
    if ((bezSpecjal) and (WalidacjaSpecjalne(znak) = 1)) then
    begin
         msg := 'Haslo niepoprawne: wystepuja znaki specjalne';
         Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
         exit(0);
    end;

    if ((bezPolskie) and (WalidacjaPolskie(znak) = 1)) then
    begin
         msg := 'Haslo niepoprawne: wystepuja polskie znaki diakrytyczne';
         Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
         exit(0);
    end;

    if ((minWielkie > 0) and (WalidacjaWielkieLitery(znak) = 1)) then
    begin
      Inc(wielkieL);
      continue;
    end;

    if ((minMale > 0) and (WalidacjaMaleLitery(znak) = 1)) then
    begin
      Inc(maleL);
      continue;
    end;

    if ((minCyfry > 0) and (WalidacjaCyfry(znak) = 1)) then
    begin
      Inc(cyfryL);
      continue;
    end;

    if ((minSpecjal > 0) and (WalidacjaSpecjalne(znak) = 1)) then
    begin
      Inc(specjalL);
      continue;
    end;
  end;
  if (wielkieL < minWielkie) then
  begin
    msg := 'Za malo wielkich liter. Jest ' + IntToStr(wielkieL) +
      ' a potrzeba min ' + IntToStr(minWielkie);
    Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
    exit(0);
  end;
  if (maleL < minMale) then
  begin
    msg := 'Za malo malych liter. Jest ' + IntToStr(maleL) +
      ' a potrzeba min ' + IntToStr(minMale);
    Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
    exit(0);
  end;
  if (cyfryL < minCyfry) then
  begin
    msg := 'Za malo cyfr. Jest ' + IntToStr(cyfryL) + ' a potrzeba min ' +
      IntToStr(minCyfry);
    Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
    exit(0);
  end;
  if (specjalL < minSpecjal) then
  begin
    msg := 'Za malo znakow specjalnych. Jest ' + IntToStr(specjalL) +
      ' a potrzeba min ' + IntToStr(minSpecjal);
    Application.MessageBox(PChar(msg), 'Walidacja', MB_OK);
    exit(0);
  end;

  Application.MessageBox('Hasło poprawne.', 'Walidacja', MB_OK);
end;


procedure TForm1.Button_infoClick(Sender: TObject);
begin
  Application.MessageBox(
    'Hasła - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V',
    'Info',
    MB_OK);
end;

procedure TForm1.Button_odgClick(Sender: TObject);
begin
  odgadnijHaslo;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.Button_sprawdzClick(Sender: TObject);
begin
  WalidacjaHasla;
end;

procedure TForm1.Button_zapiszClick(Sender: TObject);
var
  f: Text;
begin
  AssignFile(f, 'hasla.txt');
  try
    Append(f);
  except
    Rewrite(f);
  end;
  WriteLn(f, Edit_haslo.Text);
  CloseFile(f);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  Edit_wielkieMin.Enabled := CheckBox1.Checked;
  if Edit_wielkieMin.GetTextLen = 0 then
    Edit_wielkieMin.Text := '1';
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  Edit_maleMin.Enabled := CheckBox2.Checked;
  if Edit_maleMin.GetTextLen = 0 then
    Edit_maleMin.Text := '1';
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  Edit_cyfryMin.Enabled := CheckBox3.Checked;
  if Edit_cyfryMin.GetTextLen = 0 then
    Edit_cyfryMin.Text := '1';
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  Edit_specjalMin.Enabled := CheckBox4.Checked;
  if Edit_specjalMin.GetTextLen = 0 then
    Edit_specjalMin.Text := '1';
end;

procedure TForm1.Edit_hasloChange(Sender: TObject);
begin
  Edit_dlugosc.Text := IntToStr(Edit_haslo.GetTextLen);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  odswiezOdgZnaki;
end;

procedure TForm1.odgCyfryChange(Sender: TObject);
begin
  odswiezOdgZnaki;
end;

procedure TForm1.odgMaleChange(Sender: TObject);
begin
  odswiezOdgZnaki;
end;

procedure TForm1.odgSpecjalChange(Sender: TObject);
begin
  odswiezOdgZnaki;
end;

procedure TForm1.odgWielkieChange(Sender: TObject);
begin
  odswiezOdgZnaki;
end;

end.



