#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68284 "REG- Files Ledger Entries"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = UnknownTable61636;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("File No./Folio No.";"File No./Folio No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Source Department";"Source Department")
                {
                    ApplicationArea = Basic;
                }
                field("Destination Department";"Destination Department")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatch Officer Code";"Dispatch Officer Code")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Officer Code";"Receiving Officer Code")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Return Date";"Expected Return Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

