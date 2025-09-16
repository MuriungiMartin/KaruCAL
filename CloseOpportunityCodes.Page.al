#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5133 "Close Opportunity Codes"
{
    ApplicationArea = Basic;
    Caption = 'Close Opportunity Codes';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Close Opportunity Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for closing the opportunity.';
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the opportunity was a success or a failure.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the reason for closing the opportunity.';
                }
                field("No. of Opportunities";"No. of Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of opportunities closed using this close opportunity code. This field is not editable.';
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

    trigger OnOpenPage()
    begin
        if GetFilters <> '' then
          CurrPage.Editable(false);
    end;
}

