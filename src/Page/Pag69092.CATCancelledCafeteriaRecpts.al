#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69092 "CAT-Cancelled Cafeteria Recpts"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61783;
    SourceTableView = where(Status=const(Canceled));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recept Total";"Recept Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cancel Reason";"Cancel Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(User;User)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

