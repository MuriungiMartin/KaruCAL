#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5341 "CRM Account List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Accounts';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Account";
    SourceTableView = sorting(Name);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_PrimaryContactName;Address1_PrimaryContactName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Primary Contact Name';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_Line1;Address1_Line1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Street 1';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_Line2;Address1_Line2)
                {
                    ApplicationArea = Suite;
                    Caption = 'Street 2';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_PostalCode;Address1_PostalCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'ZIP/Postal Code';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_City;Address1_City)
                {
                    ApplicationArea = Suite;
                    Caption = 'City';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Address1_Country;Address1_Country)
                {
                    ApplicationArea = Suite;
                    Caption = 'Country/Region';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Coupled;Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dynamics CRM record is coupled to Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateFromCRM)
            {
                ApplicationArea = Suite;
                Caption = 'Create Customer in Dynamics NAV';
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the customer in the coupled Microsoft Dynamics CRM account.';
                Visible = AllowCreateFromCRM;

                trigger OnAction()
                var
                    CRMAccount: Record "CRM Account";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    CRMAccountRecordRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(CRMAccount);
                    CRMAccount.Next;

                    if CRMAccount.Count = 1 then
                      CRMIntegrationManagement.CreateNewRecordFromCRM(CRMAccount.AccountId,Database::Customer)
                    else begin
                      CRMAccountRecordRef.GetTable(CRMAccount);
                      CRMIntegrationManagement.CreateNewRecordsFromCRM(CRMAccountRecordRef);
                    end
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
    begin
        if CRMIntegrationRecord.FindRecordIDFromID(AccountId,Database::Customer,RecordID) then
          if CurrentlyCoupledCRMAccount.AccountId = AccountId then begin
            Coupled := 'Current';
            FirstColumnStyle := 'Strong';
          end else begin
            Coupled := 'Yes';
            FirstColumnStyle := 'Subordinate';
          end
        else begin
          Coupled := 'No';
          FirstColumnStyle := 'None';
        end;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    var
        CurrentlyCoupledCRMAccount: Record "CRM Account";
        AllowCreateFromCRM: Boolean;
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetAllowCreateFromCRM(Allow: Boolean)
    begin
        AllowCreateFromCRM := Allow;
    end;


    procedure SetCurrentlyCoupledCRMAccount(CRMAccount: Record "CRM Account")
    begin
        CurrentlyCoupledCRMAccount := CRMAccount;
    end;
}

