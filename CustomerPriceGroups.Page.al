#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7 "Customer Price Groups"
{
    ApplicationArea = Basic;
    Caption = 'Customer Price Groups';
    PageType = List;
    SourceTable = "Customer Price Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to identify the price group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the customer price group.';
                }
                field("Allow Line Disc.";"Allow Line Disc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if a line discount will be calculated when the sales price is offered.';
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the ordinary invoice discount calculation will apply to customers in this price group.';
                }
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the prices given for this price group will include tax.';
                }
                field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax business group code for this price group. The code to find the Tax percentage rate in the Tax Posting Setup window that it uses to calculate the unit price.';
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
            group("Cust. &Price Group")
            {
                Caption = 'Cust. &Price Group';
                Image = Group;
                action(SalesPrices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales &Prices';
                    Image = SalesPrices;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type"=const("Customer Price Group"),
                                  "Sales Code"=field(Code);
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.';
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGoToPricelevel)
                {
                    ApplicationArea = All;
                    Caption = 'Pricelevel';
                    Image = CoupledItem;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record"=IM;
                    ApplicationArea = All;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send updated data to Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(RecordId);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment='Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = All;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM product.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(RecordId);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = All;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM product.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CRMIsCoupledToRecord :=
          CRMCouplingManagement.IsRecordCoupledToCRM(RecordId) and CRMIntegrationEnabled;
    end;

    trigger OnOpenPage()
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;


    procedure GetSelectionFilter(): Text
    var
        CustPriceGr: Record "Customer Price Group";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CustPriceGr);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomerPriceGroup(CustPriceGr));
    end;
}

