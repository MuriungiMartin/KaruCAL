#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5929 "Fault Reason Codes"
{
    ApplicationArea = Basic;
    Caption = 'Fault Reason Codes';
    PageType = List;
    SourceTable = "Fault Reason Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the fault reason.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the fault reason code.';
                }
                field("Exclude Warranty Discount";"Exclude Warranty Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want to exclude a warranty discount for the service item assigned this fault reason code.';
                }
                field("Exclude Contract Discount";"Exclude Contract Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want to exclude a contract/service discount for the service item assigned this fault reason code.';
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
        area(navigation)
        {
            group("&Fault")
            {
                Caption = '&Fault';
                Image = Error;
                action("Serv&ice Line List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serv&ice Line List';
                    Image = ServiceLines;
                    RunObject = Page "Service Line List";
                    RunPageLink = "Fault Reason Code"=field(Code);
                    RunPageView = sorting("Fault Reason Code");
                }
                action("Service Item Line List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item Line List';
                    Image = ServiceItem;
                    RunObject = Page "Service Item Lines";
                    RunPageLink = "Fault Reason Code"=field(Code);
                    RunPageView = sorting("Fault Reason Code");
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := false;
    end;
}

