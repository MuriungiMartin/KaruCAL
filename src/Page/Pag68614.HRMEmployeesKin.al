#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68614 "HRM-Employees Kin"
{
    Caption = 'Employee Next Of  Kin';
    PageType = List;
    SourceTable = UnknownTable61323;

    layout
    {
        area(content)
        {
            repeater(Control1000000010)
            {
                field(SurName;SurName)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field(Relationship;Relationship)
                {
                    ApplicationArea = Basic;
                }
                field("ID No/Passport No";"ID No/Passport No")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Occupation;Occupation)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Office Tel No";"Office Tel No")
                {
                    ApplicationArea = Basic;
                }
                field("Home Tel No";"Home Tel No")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Next of Kin")
            {
                Caption = '&Next of Kin';
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Employee Relative"),
                                  "No."=field("Employee Code"),
                                  "Table Line No."=field("Line No.");
                }
            }
        }
    }

    var
        D: Date;
}

