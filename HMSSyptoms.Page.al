#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68651 "HMS Syptoms"
{
    PageType = List;
    SourceTable = UnknownTable61442;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Treatment no";"Treatment no")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Syptom Code";"Syptom Code")
                {
                    ApplicationArea = Basic;
                }
                field("Symptom Name";"Symptom Name")
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

