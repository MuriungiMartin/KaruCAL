#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50056 "Visitor Personal Items"
{
    PageType = ListPart;
    SourceTable = "ACA-2ndSuppExam. Co. Reg.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code";"Item Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Cleared;Cleared)
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

