#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68224 "HRM-Leave Ledger View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61659;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Document No";"Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Days";"No. of Days")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Description";"Transaction Description")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Period";"Leave Period")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Reverse Leave Entry")
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Leave Entry';
                Image = ReverseLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if "Entry Type"="entry type"::Allocation then Error('The selected entry has already been involved in a reversal.\Please select another entry to reverse...');
                    if Confirm('This will reverse the selected Ledger entry, continue?',false) = false then exit;
                    leaveLedger.Reset;
                    if leaveLedger.Find('+') then
                    lastNo:=leaveLedger."Entry No."+10
                    else lastNo:=10;

                    "Entry Type":="entry type"::Allocation;
                    "Reversed By":=UserId;
                    Modify;

                    leaveLedger.Init;
                    leaveLedger."Entry No.":=lastNo;
                    leaveLedger."Employee No":="Employee No";
                    leaveLedger."Document No":="Document No";
                    leaveLedger."Leave Type":="Leave Type";
                    leaveLedger."Transaction Date":="Transaction Date";
                    leaveLedger."Transaction Type":="Transaction Type";
                    leaveLedger."No. of Days":=(("No. of Days")*(-1));
                    leaveLedger."Transaction Description":="Transaction Description";
                    leaveLedger."Leave Period":="Leave Period";
                    leaveLedger."Entry Type":=leaveLedger."entry type"::Allocation;
                    leaveLedger."Reversed By":=UserId;
                    leaveLedger.Insert;
                end;
            }
        }
    }

    var
        leaveLedger: Record UnknownRecord61659;
        lastNo: Integer;
}

