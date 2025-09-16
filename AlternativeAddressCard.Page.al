#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5203 "Alternative Address Card"
{
    Caption = 'Alternative Address Card';
    DataCaptionExpression = Caption;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Alternative Address";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the employee''s alternate address.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate address for the employee.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies another line of an alternate address for the employee.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the alternate address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the alternate address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s telephone number at the alternate address.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s telephone number at the alternate address.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s fax number at the alternate address.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s alternate email address.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Address")
            {
                Caption = '&Address';
                Image = Addresses;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Alternative Address"),
                                  "No."=field("Employee No."),
                                  "Alternative Address Code"=field(Code);
                }
            }
        }
    }

    var
        Text000: label 'untitled';
        Employee: Record Employee;

    local procedure Caption(): Text[110]
    begin
        if Employee.Get("Employee No.") then
          exit("Employee No." + ' ' + Employee.FullName + ' ' + Code);

        exit(Text000);
    end;
}

