#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7603 "Customized Calendar Changes"
{
    Caption = 'Customized Calendar Changes';
    DataCaptionExpression = GetCaption;
    PageType = List;
    SourceTable = "Customized Calendar Change";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source type, such as company, for this entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code associated with this entry.';
                    Visible = false;
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which base calendar was used as the basis for this customized calendar.';
                    Visible = false;
                }
                field("Recurring System";"Recurring System")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring System';
                    ToolTip = 'Specifies a date or day as a recurring nonworking or working day.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date associated with this customized calendar entry.';
                }
                field(Day;Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the day of the week associated with this entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of this entry.';
                }
                field(Nonworking;Nonworking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonworking';
                    ToolTip = 'Selects the field when you make an entry in the Customized Calendar Changes window.';
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
}

