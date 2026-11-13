unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    BaseMemo: TMemo;
    BaseLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BaseMemoKeyPress(Sender: TObject; var Key: Char);
    procedure BaseMemoChange(Sender: TObject);
    procedure BaseMemoEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

type
  TAction = (DoUpdateHint,DoBringOn,DoBringOff);
  TCell = class
    Memo : TMemo;
    Hint : TLabel;
    Digits : Set of Char;
    Value : Char;
    Row,Col : Integer;
    constructor Create( Form:TForm; Row,Col:Integer );
    // Обновление подсказки сверху о допустимых цифрах
    procedure UpdateHint;
    // Сделать некоторое действие с этой ячейкой
    procedure ForOne(Action:TAction);
    // Сделать некоторое действие по отношению ко всем ячейкам на которые влияет данная
    procedure ForAll(Action:TAction);
  end;

var Cells : array [1..9,1..9] of TCell;

implementation

{$R *.dfm}

constructor TCell.Create;
begin
  Memo := TMemo.Create(Form);
  // Выравнивание текста
  Memo.Alignment := Form1.BaseMemo.Alignment;
  // Тип границы
  Memo.BorderStyle := Form1.BaseMemo.BorderStyle;
  // Шрифт
  Memo.Font := Form1.BaseMemo.Font;
  Memo.Text := ' ';
  // Ширина и высота
  Memo.Width := Form1.BaseMemo.Width;
  Memo.Height := Form1.BaseMemo.Height;
  // Положение на форме
  Memo.Top := Row * (Memo.Height + 15);
  Memo.Left := Col * (Memo.Width + 8);
  // Обработчики событий
  Memo.OnKeyPress := Form1.BaseMemo.OnKeyPress;
  Memo.OnChange := Form1.BaseMemo.OnChange;
  Memo.OnEnter := Form1.BaseMemo.OnEnter;
  Memo.OnExit := Form1.BaseMemo.OnExit;
  // Даем мемо название
  Memo.Tag := Row * 10 + Col;
  // Размещаем на форму
  Form.InsertControl(Memo);

  // Создаём подсказку о цифрах
  Hint := TLabel.Create(Form);
  Hint.Font := Form1.BaseLabel.Font;
  Hint.Width := Form1.BaseLabel.Width;
  Hint.Height := Form1.BaseLabel.Height;
  // Копируем цвет
  Hint.Color := Form1.BaseLabel.Color;

  // Положение на форме
  Hint.Top := Memo.Top - Hint.Height;
  Hint.Left := Memo.Left;

  // Размещаем на форму
  Form.InsertControl(Hint);

  // Допустимый набор символов
  Digits := ['1'..'9'];

  Self.Row := Row;
  Self.Col := Col;
end;

procedure TCell.UpdateHint;
var
  Ch : Char;
  i,j,R,C : Integer;
begin
  Digits := ['1'..'9'];

  // 1. В той же строке, 2. В том же стобце
  for i:=1 to 9 do
    Digits := Digits - [Cells[Row,i].Value, Cells[i,Col].Value];
  // 3. В том же квадрате
  R := ((Row-1) div 3) * 3 + 1;
  C := ((Col-1) div 3) * 3 + 1;
  for i:=R to R+2 do
    for j:=C to C+2 do
      Digits := Digits - [Cells[i,j].Value];

  Hint.Caption := '';
  for Ch := '1' to '9' do
    if Ch in Digits then
      Hint.Caption := Hint.Caption + Ch;
end;

// Сделать некоторое действие с этой ячейкой
procedure TCell.ForOne(Action:TAction);
begin
  case Action of
    DoUpdateHint: UpdateHint;
  end;
end;

// Сделать некоторое действие по отношению ко всем ячейкам на которые влияет данная
procedure TCell.ForAll(Action:TAction);
Var i,j,R,C : Integer;
begin
  // 1. В той же строке
  for i:=1 to 9 do
    Cells[Row,i].ForOne(Action);
  // 2. В том же стобце
  for j:=1 to 9 do
    Cells[j,Col].ForOne(Action);
  // 3. В том же квадрате
  R := ((Row-1) div 3) * 3 + 1;
  C := ((Col-1) div 3) * 3 + 1;
  for i:=R to R+2 do
    for j:=C to C+2 do
      Cells[i,j].ForOne(Action);
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j : Integer;
begin
  for i:=1 to 9 do
    for j:=1 to 9 do
      Cells[i,j] := TCell.Create(Self,i,j);
  for i:=1 to 9 do
    for j:=1 to 9 do
      Cells[i,j].UpdateHint;
end;

procedure TForm1.BaseMemoKeyPress(Sender: TObject; var Key: Char);
var M : TMemo;
  Row,Col : Integer;
begin
  M := TMemo(Sender);
  // Вычисляем номер строки и номер столбца сменилась цифра
  Row := M.Tag div 10;
  Col := M.Tag mod 10;
  // Проверяем что эту цифру мы можем поставить
  if Key in Cells[Row,Col].Digits then begin
    M.Text := Key;
    Cells[Row,Col].Value := Key;
    // Сменилась цифра, теперь её надо убрать из всех ячеек
    Cells[Row,Col].ForAll(DoUpdateHint);
  end;
end;

procedure TForm1.BaseMemoChange(Sender: TObject);
var S, D : String;
  i : integer;
  M : TMemo;
  Row,Col : Integer;
begin
  M := TMemo(Sender);
  // Вычисляем номер строки и номер столбца
  Row := M.Tag div 10;
  Col := M.Tag mod 10;

  S := M.Text;
  D := '';
  for i:=1 to Length(S) do
    if (S[i] in Cells[Row,Col].Digits) or (S[i] = Cells[Row,Col].Value) then
      D := D + S[i];
  TMemo(Sender).Text := D;
end;

procedure TForm1.BaseMemoEnter(Sender: TObject);
var M : TMemo;
  Row,Col,R,C : Integer;
begin
  M := TMemo(Sender);
  // Вычисляем номер строки и номер столбца
  Row := M.Tag div 10;
  Col := M.Tag mod 10;

  // Обновляем раскраску ячеек
  if Cells[Row,Col].Value in ['1'..'9'] then begin
    for R := 1 to 9 do
      for C := 1 to 9 do
        if Cells[Row,Col].Value in Cells[R,C].Digits then
          Cells[R,C].Memo.Color := clWhite
        else
          Cells[R,C].Memo.Color := clAqua;
  end else begin
    for R := 1 to 9 do
      for C := 1 to 9 do
        Cells[R,C].Memo.Color := clWhite
  end;
end;

end.
