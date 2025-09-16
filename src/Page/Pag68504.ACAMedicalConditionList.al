#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68504 "ACA-Medical Condition List"
{
    PageType = List;
    SourceTable = UnknownTable61379;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
                {
                    ApplicationArea = Basic;
                }
                field(Family;Family)
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

