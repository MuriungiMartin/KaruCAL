#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1702 "Deferral Schedule"
{
    Caption = 'Deferral Schedule';
    DataCaptionFields = "Start Date";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "Deferral Header";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Amount to Defer";"Amount to Defer")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount to defer per period.';
                }
                field("Calc. Method";"Calc. Method")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how the Amount field for each period is calculated. Straight-Line: Calculated per the number of periods, distributed by period length. Equal Per Period: Calculated per the number of periods, distributed evenly on periods. Days Per Period: Calculated per the number of days in the period. User-Defined: Not calculated. You must manually fill the Amount field for each period.';
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies when to start calculating deferral amounts.';
                }
                field("No. of Periods";"No. of Periods")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many accounting periods the total amounts will be deferred to.';
                }
            }
            part(DeferralSheduleSubform;"Deferral Schedule Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Deferral Doc. Type"=field("Deferral Doc. Type"),
                              "Gen. Jnl. Template Name"=field("Gen. Jnl. Template Name"),
                              "Gen. Jnl. Batch Name"=field("Gen. Jnl. Batch Name"),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                action(CalculateSchedule)
                {
                    ApplicationArea = Suite;
                    Caption = 'Calculate Schedule';
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Calculate the deferral schedule by which revenue or expense amounts will be distributed over multiple accounting periods.';

                    trigger OnAction()
                    begin
                        Changed := CalculateSchedule;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Changed := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Changed := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Changed := true;
    end;

    trigger OnOpenPage()
    begin
        InitForm;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        DeferralUtilities: Codeunit "Deferral Utilities";
        EarliestPostingDate: Date;
        RecCount: Integer;
        ExpectedCount: Integer;
    begin
        // Prevent closing of the window if the sum of the periods does not equal the Amount to Defer
        if DeferralHeader.Get("Deferral Doc. Type",
             "Gen. Jnl. Template Name",
             "Gen. Jnl. Batch Name",
             "Document Type",
             "Document No.","Line No.")
        then begin
          CalcFields("Schedule Line Total");
          if "Schedule Line Total" <> DeferralHeader."Amount to Defer" then
            Error(TotalToDeferErr);
        end;

        DeferralLine.SetRange("Deferral Doc. Type","Deferral Doc. Type");
        DeferralLine.SetRange("Gen. Jnl. Template Name","Gen. Jnl. Template Name");
        DeferralLine.SetRange("Gen. Jnl. Batch Name","Gen. Jnl. Batch Name");
        DeferralLine.SetRange("Document Type","Document Type");
        DeferralLine.SetRange("Document No.","Document No.");
        DeferralLine.SetRange("Line No.","Line No.");

        RecCount := DeferralLine.Count;
        ExpectedCount := DeferralUtilities.CalcDeferralNoOfPeriods("Calc. Method","No. of Periods","Start Date");
        if ExpectedCount <> RecCount then
          FieldError("No. of Periods");

        DeferralLine.SetFilter("Posting Date",'>%1',0D);
        if DeferralLine.FindFirst then begin
          EarliestPostingDate := DeferralLine."Posting Date";
          if EarliestPostingDate <> DeferralHeader."Start Date" then
            Error(PostingDateErr);
        end;
    end;

    var
        TotalToDeferErr: label 'The sum of the deferred amounts must be equal to the amount in the Amount to Defer field.';
        Changed: Boolean;
        DisplayDeferralDocType: Option Purchase,Sales,"G/L";
        DisplayGenJnlTemplateName: Code[10];
        DisplayGenJnlBatchName: Code[10];
        DisplayDocumentType: Integer;
        DisplayDocumentNo: Code[20];
        DisplayLineNo: Integer;
        PostingDateErr: label 'You cannot specify a posting date that is earlier than the start date.';


    procedure SetParameter(DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer)
    begin
        DisplayDeferralDocType := DeferralDocType;
        DisplayGenJnlTemplateName := GenJnlTemplateName;
        DisplayGenJnlBatchName := GenJnlBatchName;
        DisplayDocumentType := DocumentType;
        DisplayDocumentNo := DocumentNo;
        DisplayLineNo := LineNo;
    end;


    procedure GetParameter(): Boolean
    begin
        exit(Changed or CurrPage.DeferralSheduleSubform.Page.GetChanged)
    end;


    procedure InitForm()
    begin
        Get(DisplayDeferralDocType,DisplayGenJnlTemplateName,DisplayGenJnlBatchName,DisplayDocumentType,DisplayDocumentNo,DisplayLineNo);
    end;
}

