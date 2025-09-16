#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7606 "Customized Calendar Entries"
{
    Caption = 'Customized Calendar Entries';
    DataCaptionExpression = GetCaption;
    PageType = ListPlus;
    SourceTable = "Customized Calendar Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Type';
                    DrillDown = false;
                    ToolTip = 'Specifies whether this customized calendar entry was set up for your company, a customer, vendor, location, shipping agent, or a service.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar Code';
                    Lookup = true;
                    ToolTip = 'Specifies which base calendar was used as the basis for this customized calendar.';
                }
            }
            part(BaseCalendarEntries;"Customized Cal. Entries Subfm")
            {
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Maintain Customized Calendar Changes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Maintain Customized Calendar Changes';
                    Image = Edit;
                    RunObject = Page "Customized Calendar Changes";
                    RunPageLink = "Source Type"=field("Source Type"),
                                  "Source Code"=field(filter("Source Code")),
                                  "Additional Source Code"=field("Additional Source Code"),
                                  "Base Calendar Code"=field("Base Calendar Code");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.BaseCalendarEntries.Page.SetCalendarCode("Source Type","Source Code","Additional Source Code","Base Calendar Code");
    end;
}

