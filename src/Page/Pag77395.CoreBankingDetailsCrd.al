#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77395 "Core_Banking_Details Crd"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Core_Banking_Details;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Editable = false;
                field("Transaction Number";"Transaction Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Description";"Transaction Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transaction Occurences";"Transaction Occurences")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Posting Status";"Posting Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Core_Banking Status";"Core_Banking Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Trans. Amount";"Trans. Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

