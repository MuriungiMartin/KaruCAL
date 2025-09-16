#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1233 "Positive Pay Export"
{
    Caption = 'Positive Pay Export';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    ShowFilter = false;
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(LastUploadDateEntered;LastUploadDateEntered)
                {
                    ApplicationArea = Suite;
                    Caption = 'Last Upload Date';
                    ToolTip = 'Specifies the day when a positive pay file was last exported.';

                    trigger OnValidate()
                    begin
                        UpdateSubForm;
                    end;
                }
                field(LastUploadTime;LastUploadTime)
                {
                    ApplicationArea = Suite;
                    Caption = 'Last Upload Time';
                    Editable = false;
                    ToolTip = 'Specifies the time when a positive pay file was last exported.';
                }
                field(CutoffUploadDate;CutoffUploadDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cutoff Upload Date';
                    ToolTip = 'Specifies a date before which payments are not included in the exported file.';

                    trigger OnValidate()
                    begin
                        UpdateSubForm;
                    end;
                }
            }
            part(PosPayExportDetail;"Positive Pay Export Detail")
            {
                ApplicationArea = Suite;
                Caption = 'Positive Pay Export Detail';
                SubPageLink = "Bank Account No."=field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Export)
            {
                ApplicationArea = Suite;
                Caption = 'Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Export Positive Pay data to a file that you can send to the bank when processing payments to make sure that the bank only clears validated checks and amounts.';

                trigger OnAction()
                var
                    CheckLedgerEntry: Record "Check Ledger Entry";
                begin
                    CheckLedgerEntry.SetCurrentkey("Bank Account No.","Check Date");
                    CheckLedgerEntry.SetRange("Bank Account No.","No.");
                    CheckLedgerEntry.SetRange("Check Date",LastUploadDateEntered,CutoffUploadDate);
                    CheckLedgerEntry.ExportCheckFile;
                    UpdateSubForm;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateSubForm;
    end;

    trigger OnOpenPage()
    begin
        PositivePayEntry.SetRange("Bank Account No.","No.");
        if PositivePayEntry.FindLast then begin
          LastUploadDateEntered := Dt2Date(PositivePayEntry."Upload Date-Time");
          LastUploadTime := Dt2Time(PositivePayEntry."Upload Date-Time");
        end;
        CutoffUploadDate := WorkDate;
        UpdateSubForm;
    end;

    var
        PositivePayEntry: Record "Positive Pay Entry";
        LastUploadDateEntered: Date;
        LastUploadTime: Time;
        CutoffUploadDate: Date;


    procedure UpdateSubForm()
    begin
        CurrPage.PosPayExportDetail.Page.Set(LastUploadDateEntered,CutoffUploadDate,"No.");
    end;
}

