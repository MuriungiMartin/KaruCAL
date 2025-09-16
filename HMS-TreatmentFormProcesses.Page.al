#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68569 "HMS-Treatment Form Processes"
{
    PageType = ListPart;
    SourceTable = UnknownTable61408;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Process No.";"Process No.")
                {
                    ApplicationArea = Basic;
                }
                field("Process Name";"Process Name")
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
                {
                    ApplicationArea = Basic;
                }
                field(Performed;Performed)
                {
                    ApplicationArea = Basic;
                }
                field("Process Remarks";"Process Remarks")
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

