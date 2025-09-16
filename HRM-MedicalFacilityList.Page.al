#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69021 "HRM-Medical Facility List"
{
    CardPageID = "HRM-Medical Facility Card";
    PageType = List;
    SourceTable = "HRM-Medical Facility";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Facility Name";"Facility Name")
                {
                    ApplicationArea = Basic;
                }
                field(Contacts;Contacts)
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field("Facility Type";"Facility Type")
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

