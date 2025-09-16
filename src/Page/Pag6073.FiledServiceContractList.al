#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6073 "Filed Service Contract List"
{
    Caption = 'Filed Service Contract List';
    CardPageID = "Filed Service Contract";
    DataCaptionFields = "Contract No. Relation";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Filed Service Contract Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("File Date";"File Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service contract or contract quote is filed.';
                }
                field("File Time";"File Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service contract or contract quote is filed.';
                }
                field("Filed By";"Filed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the user who filed the service contract.';
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the filed contract or contract quote.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the filed service contract or service contract quote.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the filed service contract or contract quote.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the filed service contract or contract quote.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the customer in the filed service contract or contract quote.';
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

    trigger OnInit()
    begin
        CurrPage.LookupMode := false;
    end;
}

