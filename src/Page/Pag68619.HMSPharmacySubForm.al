#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68619 "HMS Pharmacy SubForm"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable61423;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Pharmacy No.";"Pharmacy No.")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Date";"Pharmacy Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Time";"Pharmacy Time")
                {
                    ApplicationArea = Basic;
                }
                field("Issued By";"Issued By")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

