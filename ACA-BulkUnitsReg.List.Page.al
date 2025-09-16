#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65008 "ACA-Bulk Units Reg. List"
{
    ApplicationArea = Basic;
    CardPageID = "ACA-Bulk Units Registration";
    PageType = List;
    SourceTable = "ACA-Bulk Units Registration";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Program Code";"Program Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
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
        SetFilter("User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetFilter("User ID",UserId);
    end;
}

