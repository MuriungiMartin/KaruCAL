#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7608 "Where-Used Base Calendar"
{
    Caption = 'Where-Used Base Calendar';
    DataCaptionFields = "Base Calendar Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Where Used Base Calendar";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Type';
                    ToolTip = 'Specifies whether this customized calendar entry was set up for your company, a customer, vendor, location, shipping agent, or a service.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Code';
                    ToolTip = 'Specifies the source identity of the business partner the customized calendar is set up for.';
                }
                field("Additional Source Code";"Additional Source Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Additional Source Code';
                    ToolTip = 'Specifies the code of the shipping agent service if the Source Type field contains Shipping Agent.';
                }
                field("Source Name";"Source Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Name';
                    ToolTip = 'Specifies the source name associated with this entry.';
                }
                field("Customized Changes Exist";"Customized Changes Exist")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Changes Exist';
                    ToolTip = 'Specifies that this entry has used the base calendar to create a customized calendar.';
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

