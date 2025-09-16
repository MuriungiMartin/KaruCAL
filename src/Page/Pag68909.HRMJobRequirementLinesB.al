#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68909 "HRM-Job Requirement Lines(B)"
{
    Caption = '<HR Job Requirements';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61195;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Qualification Type";"Qualification Type")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Code";"Qualification Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Description";"Qualification Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                }
                field("Desired Score";"Desired Score")
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
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

