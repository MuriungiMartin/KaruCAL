#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 209 "Units of Measure"
{
    ApplicationArea = Basic;
    Caption = 'Units of Measure';
    PageType = List;
    SourceTable = "Unit of Measure";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the unit of measure, which you can select on item and resource cards from where it is copied to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the unit of measure.';
                }
                field("International Standard Code";"International Standard Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code expressed according to the UNECERec20 standard in connection with electronic sending of sales documents. For example, when sending sales documents through the PEPPOL service, the value in this field is used to populate the UnitCode element in the Product group.';
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
            group("&Unit")
            {
                Caption = '&Unit';
                Image = UnitOfMeasure;
                action(Translations)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Unit of Measure Translation";
                    RunPageLink = Code=field(Code);
                    ToolTip = 'View or edit descriptions for each unit of measure in different languages.';
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Image = Administration;
                Visible = CRMIntegrationEnabled;
                action(CRMGotoUnitsOfMeasure)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit of Measure';
                    Image = CoupledUnitOfMeasure;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM unit of measure.';

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
                    ApplicationArea = Basic;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send updated data to Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        UnitOfMeasure: Record "Unit of Measure";
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        UnitOfMeasureRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(UnitOfMeasure);
                        UnitOfMeasure.Next;

                        if UnitOfMeasure.Count = 1 then
                          CRMIntegrationManagement.UpdateOneNow(UnitOfMeasure.RecordId)
                        else begin
                          UnitOfMeasureRecordRef.GetTable(UnitOfMeasure);
                          CRMIntegrationManagement.UpdateMultipleNow(UnitOfMeasureRecordRef);
                        end
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
                        ApplicationArea = Basic,Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM Unit of Measure.';

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
                        ApplicationArea = Basic,Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM Unit of Measure.';

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

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
}

