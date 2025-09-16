#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1405 "Bank Account - Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Account - Labels.rdlc';
    Caption = 'Bank Account - Labels';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Bank Account";"Bank Account")
        {
            RequestFilterFields = "No.",Name;
            column(ReportForNavId_4558; 4558)
            {
            }
            column(BankAccAddr_1__1_;BankAccAddr[1][1])
            {
            }
            column(BankAccAddr_1__2_;BankAccAddr[1][2])
            {
            }
            column(BankAccAddr_1__3_;BankAccAddr[1][3])
            {
            }
            column(BankAccAddr_1__4_;BankAccAddr[1][4])
            {
            }
            column(BankAccAddr_1__5_;BankAccAddr[1][5])
            {
            }
            column(BankAccAddr_1__6_;BankAccAddr[1][6])
            {
            }
            column(BankAccAddr_2__1_;BankAccAddr[2][1])
            {
            }
            column(BankAccAddr_2__2_;BankAccAddr[2][2])
            {
            }
            column(BankAccAddr_2__3_;BankAccAddr[2][3])
            {
            }
            column(BankAccAddr_2__4_;BankAccAddr[2][4])
            {
            }
            column(BankAccAddr_2__5_;BankAccAddr[2][5])
            {
            }
            column(BankAccAddr_2__6_;BankAccAddr[2][6])
            {
            }
            column(BankAccAddr_3__1_;BankAccAddr[3][1])
            {
            }
            column(BankAccAddr_3__2_;BankAccAddr[3][2])
            {
            }
            column(BankAccAddr_3__3_;BankAccAddr[3][3])
            {
            }
            column(BankAccAddr_3__4_;BankAccAddr[3][4])
            {
            }
            column(BankAccAddr_3__5_;BankAccAddr[3][5])
            {
            }
            column(BankAccAddr_3__6_;BankAccAddr[3][6])
            {
            }
            column(BankAccAddr_1__7_;BankAccAddr[1][7])
            {
            }
            column(BankAccAddr_1__8_;BankAccAddr[1][8])
            {
            }
            column(BankAccAddr_2__7_;BankAccAddr[2][7])
            {
            }
            column(BankAccAddr_2__8_;BankAccAddr[2][8])
            {
            }
            column(BankAccAddr_3__7_;BankAccAddr[3][7])
            {
            }
            column(BankAccAddr_3__8_;BankAccAddr[3][8])
            {
            }
            column(ShowBody1;(ColumnNo = 0) and (LabelFormat = Labelformat::"36 x 70 mm (3 columns)"))
            {
            }
            column(GroupNo;GroupNo)
            {
            }
            column(ShowBody2;(ColumnNo = 0) and (LabelFormat = Labelformat::"37 x 70 mm (3 columns)"))
            {
            }
            column(ShowBody3;(ColumnNo = 0) and (LabelFormat = Labelformat::"36 x 105 mm (2 columns)"))
            {
            }
            column(ShowBody4;(ColumnNo = 0) and (LabelFormat = Labelformat::"37 x 105 mm (2 columns)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                ColumnNo := ColumnNo + 1;
                FormatAddr.BankAcc(BankAccAddr[ColumnNo],"Bank Account");
                if RecordNo = NoOfRecords then begin
                  for i := ColumnNo + 1 to NoOfColumns do
                    Clear(BankAccAddr[i]);
                  ColumnNo := 0;
                end else begin
                  if ColumnNo = NoOfColumns then
                    ColumnNo := 0;
                end;

                if Counter = RecPerPageNum * NoOfColumns then begin
                  GroupNo := GroupNo + 1;
                  Counter := 0;
                end;

                Counter := Counter + 1;
            end;

            trigger OnPreDataItem()
            begin
                case LabelFormat of
                  Labelformat::"36 x 70 mm (3 columns)",Labelformat::"37 x 70 mm (3 columns)":
                    NoOfColumns := 3;
                  Labelformat::"36 x 105 mm (2 columns)",Labelformat::"37 x 105 mm (2 columns)":
                    NoOfColumns := 2;
                end;
                NoOfRecords := Count;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LabelFormat;LabelFormat)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Format';
                        OptionCaption = '36 x 70 mm (3 columns),37 x 70 mm (3 columns),36 x 105 mm (2 columns),37 x 105 mm (2 columns)';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GroupNo := 1;
        RecPerPageNum := 7;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        LabelFormat: Option "36 x 70 mm (3 columns)","37 x 70 mm (3 columns)","36 x 105 mm (2 columns)","37 x 105 mm (2 columns)";
        BankAccAddr: array [3,8] of Text[50];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        GroupNo: Integer;
        Counter: Integer;
        RecPerPageNum: Integer;
}

