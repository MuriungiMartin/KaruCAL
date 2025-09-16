#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5308 "Outlook Synch. Table List"
{
    Caption = 'Outlook Synch. Table List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = AllObjWithCaption;
    SourceTableView = sorting("Object Type","Object ID")
                      where("Object Type"=const(Table));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object ID';
                }
                field("Object Caption";"Object Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Caption';
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

