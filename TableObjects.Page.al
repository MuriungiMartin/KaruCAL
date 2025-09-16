#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 669 "Table Objects"
{
    Caption = 'Table Objects';
    PageType = List;
    SourceTable = AllObjWithCaption;
    SourceTableView = where("Object Type"=const(Table));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID';
                }
                field("Object Caption";"Object Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

