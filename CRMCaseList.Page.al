#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5349 "CRM Case List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Cases';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Dynamics CRM';
    SourceTable = "CRM Incident";
    SourceTableView = sorting(Title);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Title;Title)
                {
                    ApplicationArea = Suite;
                    Caption = 'Case Title';
                }
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                    OptionCaption = 'Active,Resolved,Canceled';
                }
                field(TicketNumber;TicketNumber)
                {
                    ApplicationArea = Suite;
                    Caption = 'Case Number';
                }
                field(CreatedOn;CreatedOn)
                {
                    ApplicationArea = Suite;
                    Caption = 'Created On';
                    ToolTip = 'Specifies when the sales order was created.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                action(CRMGoToCase)
                {
                    ApplicationArea = Suite;
                    Caption = 'Case';
                    Image = CoupledOrder;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        Hyperlink(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(Database::"CRM Incident",IncidentId));
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;
}

