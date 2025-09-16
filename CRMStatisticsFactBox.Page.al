#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5360 "CRM Statistics FactBox"
{
    Caption = 'Dynamics CRM Statistics';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field(Opportunities;GetNoOfCRMOpportunities)
            {
                ApplicationArea = Suite;
                Caption = 'Opportunities';
                ToolTip = 'Specifies the sales opportunity that is coupled to this Dynamics CRM opportunity.';

                trigger OnDrillDown()
                var
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMIntegrationManagement.ShowCustomerCRMOpportunities(Rec);
                end;
            }
            field(Quotes;GetNoOfCRMQuotes)
            {
                ApplicationArea = Suite;
                Caption = 'Quotes';

                trigger OnDrillDown()
                var
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMIntegrationManagement.ShowCustomerCRMQuotes(Rec);
                end;
            }
            field(Cases;GetNoOfCRMCases)
            {
                ApplicationArea = Suite;
                Caption = 'Cases';

                trigger OnDrillDown()
                var
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMIntegrationManagement.ShowCustomerCRMCases(Rec);
                end;
            }
        }
    }

    actions
    {
    }

    local procedure GetNoOfCRMOpportunities(): Integer
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        exit(CRMIntegrationManagement.GetNoOfCRMOpportunities(Rec));
    end;

    local procedure GetNoOfCRMQuotes(): Integer
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        exit(CRMIntegrationManagement.GetNoOfCRMQuotes(Rec));
    end;

    local procedure GetNoOfCRMCases(): Integer
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        exit(CRMIntegrationManagement.GetNoOfCRMCases(Rec));
    end;
}

