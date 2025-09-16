#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7607 "Base Calendar Change List"
{
    Caption = 'Base Calendar Change List';
    DataCaptionFields = "Base Calendar Code";
    Editable = false;
    PageType = List;
    SourceTable = "Base Calendar Change";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the base calendar in the entry.';
                    Visible = false;
                }
                field("Recurring System";"Recurring System")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring System';
                    ToolTip = 'Specifies whether a date or day is a recurring nonworking day. It can be either Annual Recurring or Weekly Recurring.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date to change associated with the base calendar in this entry.';
                }
                field(Day;Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the day of the week associated with this change entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the change in this entry.';
                }
                field(Nonworking;Nonworking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonworking';
                    ToolTip = 'Specifies that the date entry was defined as a nonworking day when the base calendar was set up.';
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

