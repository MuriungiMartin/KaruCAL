#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1113 "Cost Accounting Setup"
{
    ApplicationArea = Basic;
    Caption = 'Cost Accounting Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Cost Accounting Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Starting Date for G/L Transfer";"Starting Date for G/L Transfer")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        if not Confirm(Text001,true,"Starting Date for G/L Transfer") then
                          Error(Text003);
                        Modify;
                    end;
                }
                field("Align G/L Account";"Align G/L Account")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Align Cost Center Dimension";"Align Cost Center Dimension")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Align Cost Object Dimension";"Align Cost Object Dimension")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Auto Transfer from G/L";"Auto Transfer from G/L")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        if "Auto Transfer from G/L" then
                          if not Confirm(Text002,true) then
                            Error(Text003);
                    end;
                }
                field("Check G/L Postings";"Check G/L Postings")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
            group(Allocation)
            {
                Caption = 'Allocation';
                field("Last Allocation ID";"Last Allocation ID")
                {
                    ApplicationArea = Basic;
                }
                field("Last Allocation Doc. No.";"Last Allocation Doc. No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Cost Accounting Dimensions")
            {
                Caption = 'Cost Accounting Dimensions';
                field("Cost Center Dimension";"Cost Center Dimension")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cost Object Dimension";"Cost Object Dimension")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Update Cost Acctg. Dimensions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Cost Acctg. Dimensions';
                    Image = CostAccountingDimensions;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Update Cost Acctg. Dimensions");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        Text001: label 'This field specifies that only general ledger entries from this posting date are transferred to Cost Accounting.\\Are you sure that you want to set the date to %1?';
        Text002: label 'All previous general ledger entries will be transferred to Cost Accounting. Do you want to continue?';
        Text003: label 'The change was canceled.';
}

