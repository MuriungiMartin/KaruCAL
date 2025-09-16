#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5343 "CRM Opportunity List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Opportunities';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Dynamics CRM';
    SourceTable = "CRM Opportunity";
    SourceTableView = sorting(Name);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                    OptionCaption = 'Open,Won,Lost';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(StatusCode;StatusCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status Reason';
                    OptionCaption = ' ,In Progress,On Hold,Won,Canceled,Out-Sold';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Topic';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(EstimatedCloseDate;EstimatedCloseDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Est. Close Date';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(EstimatedValue;EstimatedValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Est. Revenue';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Amount';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(ParentContactIdName;ParentContactIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact Name';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(ParentAccountIdName;ParentAccountIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Account Name';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(CloseProbability;CloseProbability)
                {
                    ApplicationArea = Suite;
                    Caption = 'Probability';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(OpportunityRatingCode;OpportunityRatingCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Rating';
                    OptionCaption = 'Hot,Warm,Cold';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Need;Need)
                {
                    ApplicationArea = Suite;
                    Caption = 'Need';
                    OptionCaption = ' ,Must have,Should have,Good to have,No need';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
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
                action(CRMGotoOpportunities)
                {
                    ApplicationArea = Suite;
                    Caption = 'Opportunity';
                    Image = CoupledOpportunity;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Specifies the sales opportunity that is coupled to this Dynamics CRM opportunity.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        Hyperlink(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(Database::"CRM Opportunity",OpportunityId));
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

