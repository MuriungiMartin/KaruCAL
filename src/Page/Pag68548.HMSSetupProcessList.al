#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68548 "HMS-Setup Process List"
{
    PageType = List;
    SourceTable = UnknownTable61399;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Request date";"Request date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

