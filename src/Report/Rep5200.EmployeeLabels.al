#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5200 "Employee - Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Labels.rdlc';
    Caption = 'Employee - Labels';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.","First Name","Middle Name","Last Name";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(EmployeeAddr_1__1_;EmployeeAddr[1][1])
            {
            }
            column(EmployeeAddr_1__2_;EmployeeAddr[1][2])
            {
            }
            column(EmployeeAddr_1__3_;EmployeeAddr[1][3])
            {
            }
            column(EmployeeAddr_1__4_;EmployeeAddr[1][4])
            {
            }
            column(EmployeeAddr_1__5_;EmployeeAddr[1][5])
            {
            }
            column(EmployeeAddr_1__6_;EmployeeAddr[1][6])
            {
            }
            column(EmployeeAddr_2__1_;EmployeeAddr[2][1])
            {
            }
            column(EmployeeAddr_2__2_;EmployeeAddr[2][2])
            {
            }
            column(EmployeeAddr_2__3_;EmployeeAddr[2][3])
            {
            }
            column(EmployeeAddr_2__4_;EmployeeAddr[2][4])
            {
            }
            column(EmployeeAddr_2__5_;EmployeeAddr[2][5])
            {
            }
            column(EmployeeAddr_2__6_;EmployeeAddr[2][6])
            {
            }
            column(EmployeeAddr_3__1_;EmployeeAddr[3][1])
            {
            }
            column(EmployeeAddr_3__2_;EmployeeAddr[3][2])
            {
            }
            column(EmployeeAddr_3__3_;EmployeeAddr[3][3])
            {
            }
            column(EmployeeAddr_3__4_;EmployeeAddr[3][4])
            {
            }
            column(EmployeeAddr_3__5_;EmployeeAddr[3][5])
            {
            }
            column(EmployeeAddr_3__6_;EmployeeAddr[3][6])
            {
            }
            column(EmployeeAddr_1__7_;EmployeeAddr[1][7])
            {
            }
            column(EmployeeAddr_1__8_;EmployeeAddr[1][8])
            {
            }
            column(EmployeeAddr_2__7_;EmployeeAddr[2][7])
            {
            }
            column(EmployeeAddr_2__8_;EmployeeAddr[2][8])
            {
            }
            column(EmployeeAddr_3__7_;EmployeeAddr[3][7])
            {
            }
            column(EmployeeAddr_3__8_;EmployeeAddr[3][8])
            {
            }
            column(ShowBody1;(ColumnNo = 0) and (LabelFormat = Labelformat::"36 x 70 mm (3 columns)"))
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
                if (Today < "Alt. Address End Date") and
                   (Today > "Alt. Address Start Date") and
                   ("Alt. Address Code" <> '') and
                   (AddrFormat = Addrformat::"Current Alternative Address")
                then
                  FormatAddr.EmployeeAltAddr(EmployeeAddr[ColumnNo],o)
                else
                  FormatAddr.Employee(EmployeeAddr[ColumnNo],o);
                if RecordNo = NoOfRecords then begin
                  for i := ColumnNo + 1 to NoOfColumns do
                    Clear(EmployeeAddr[i]);
                  ColumnNo := 0;
                end else begin
                  if ColumnNo = NoOfColumns then
                    ColumnNo := 0;
                end;
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
                    field(AddrFormat;AddrFormat)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use';
                        OptionCaption = 'Home Address,Current Alternative Address';
                    }
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

    var
        FormatAddr: Codeunit "Format Address";
        LabelFormat: Option "36 x 70 mm (3 columns)","37 x 70 mm (3 columns)","36 x 105 mm (2 columns)","37 x 105 mm (2 columns)";
        AddrFormat: Option "Home Address","Current Alternative Address";
        EmployeeAddr: array [3,8] of Text[50];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;


    procedure InitializeRequest(AddrFormatFrom: Option;LabelFormatFrom: Option)
    begin
        AddrFormat := AddrFormatFrom;
        LabelFormat := LabelFormatFrom;
    end;
}

