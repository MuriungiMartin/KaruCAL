#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68706 "ELECT Election Result Line"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable61464;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Position Name";"Position Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Candidate No.";"Candidate No.")
                {
                    ApplicationArea = Basic;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Candidate Name";"Candidate Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }
}

