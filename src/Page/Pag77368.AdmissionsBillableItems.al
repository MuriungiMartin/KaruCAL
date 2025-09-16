#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77368 "Admissions Billable Items"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77389;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Index;Index)
                {
                    ApplicationArea = Basic;
                }
                field(Admin;Admin)
                {
                    ApplicationArea = Basic;
                }
                field("Charge Code";"Charge Code")
                {
                    ApplicationArea = Basic;
                }
                field("Charge Description";"Charge Description")
                {
                    ApplicationArea = Basic;
                }
                field("Charge Amount";"Charge Amount")
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

