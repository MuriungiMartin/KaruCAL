#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70710 "Sms-Custom Batch List"
{
    ApplicationArea = Basic;
    CardPageID = "Sms-Batch Custom Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable70707;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch No";"Batch No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
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

