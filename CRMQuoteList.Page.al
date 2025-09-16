#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5351 "CRM Quote List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Quotes';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Dynamics CRM';
    SourceTable = "CRM Quote";
    SourceTableView = sorting(Name);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the record.';
                }
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                    OptionCaption = 'Draft,Active,Won,Closed';
                }
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Amount';
                }
                field(EffectiveFrom;EffectiveFrom)
                {
                    ApplicationArea = Suite;
                    Caption = 'Effective From';
                    ToolTip = 'Specifies which date the sales quote is valid from.';
                }
                field(EffectiveTo;EffectiveTo)
                {
                    ApplicationArea = Suite;
                    Caption = 'Effective To';
                    ToolTip = 'Specifies which date the sales quote is valid to.';
                }
                field(ClosedOn;ClosedOn)
                {
                    ApplicationArea = Suite;
                    Caption = 'Closed On';
                    ToolTip = 'Specifies the date when quote was closed.';
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
                action(CRMGoToQuote)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quote';
                    Image = CoupledQuote;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Open the selected Dynamics CRM quote.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        Hyperlink(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(Database::"CRM Quote",QuoteId));
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

