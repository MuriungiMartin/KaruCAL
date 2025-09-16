#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 696 "All Objects"
{
    Caption = 'All Objects';
    DataCaptionFields = "Object Type";
    Editable = false;
    PageType = List;
    SourceTable = AllObj;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Object Type";"Object Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Type';
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object ID';
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Name';
                }
            }
        }
    }

    actions
    {
    }
}

