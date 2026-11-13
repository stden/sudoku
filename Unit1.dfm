object Form1: TForm1
  Left = 231
  Top = 199
  Width = 801
  Height = 697
  Caption = #1057#1091#1076#1086#1082#1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BaseLabel: TLabel
    Left = 88
    Top = 16
    Width = 54
    Height = 13
    Caption = '123456789'
    Color = clMoneyGreen
    ParentColor = False
    Visible = False
  end
  object BaseMemo: TMemo
    Left = 16
    Top = 8
    Width = 50
    Height = 50
    Alignment = taCenter
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = []
    Lines.Strings = (
      '1')
    ParentFont = False
    TabOrder = 0
    Visible = False
    WantReturns = False
    OnChange = BaseMemoChange
    OnEnter = BaseMemoEnter
    OnKeyPress = BaseMemoKeyPress
  end
end
