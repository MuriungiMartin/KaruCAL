#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68632 "HMS Drug Interaction Header"
{
    PageType = Document;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1102760000;"HMS Drug Interaction Line")
            {
                SubPageLink = "Drug No."=field("No.");
            }
        }
    }

    actions
    {
    }
}

