#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68368 "HRM-Emp. Qualification"
{
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Employee Qualification";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Code";"Qualification Code")
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
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                }
                field("Institution/Company";"Institution/Company")
                {
                    ApplicationArea = Basic;
                }
                field("Course Grade";"Course Grade")
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

