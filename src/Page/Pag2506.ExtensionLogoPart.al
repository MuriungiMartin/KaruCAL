#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2506 "Extension Logo Part"
{
    Caption = 'Extension Logo Part';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "NAV App";

    layout
    {
        area(content)
        {
            group(Control4)
            {
                group(Control3)
                {
                    field(Logo;Logo)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the logo of the extension, such as the logo of the service provider.';
                    }
                }
            }
        }
    }

    actions
    {
    }
}

