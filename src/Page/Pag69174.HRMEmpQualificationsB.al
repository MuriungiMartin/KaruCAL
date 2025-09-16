#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69174 "HRM-Emp. Qualifications (B)"
{
    PageType = List;
    SourceTable = "Employee Qualification";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Type";"Qualification Type")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Code";"Qualification Code")
                {
                    ApplicationArea = Basic;
                }
                field(Qualification;Qualification)
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
                field("Grad. Date";"Grad. Date")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Institution/Company";"Institution/Company")
                {
                    ApplicationArea = Basic;
                }
                field("Score ID";"Score ID")
                {
                    ApplicationArea = Basic;
                }
                field("From Year";"From Year")
                {
                    ApplicationArea = Basic;
                }
                field("To Year";"To Year")
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

