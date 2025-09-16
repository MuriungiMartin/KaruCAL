#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68366 "HRM-M. Article Information"
{
    PageType = ListPart;
    SourceTable = "Misc. Article Information";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Misc. Article Code";"Misc. Article Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                }
                field("In Use";"In Use")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No.";"Serial No.")
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

