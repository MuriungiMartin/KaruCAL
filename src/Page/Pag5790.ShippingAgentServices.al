#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5790 "Shipping Agent Services"
{
    Caption = 'Shipping Agent Services';
    DataCaptionFields = "Shipping Agent Code";
    PageType = List;
    SourceTable = "Shipping Agent Services";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the shipping agent.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the shipping agent.';
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the agent''s shipping time.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }
                field("CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar.""Source Type""::""Shipping Agent"",""Shipping Agent Code"",Code,""Base Calendar Code"")";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."source type"::"Shipping Agent","Shipping Agent Code",Code,"Base Calendar Code"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(
                          CustomizedCalEntry."source type"::"Shipping Agent","Shipping Agent Code",Code,"Base Calendar Code");
                    end;
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
                Visible = false;
            }
        }
    }

    actions
    {
    }

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
}

