#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5342 "CRM Contact List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Contacts';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Contact";
    SourceTableView = sorting(FullName);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(FullName;FullName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    StyleExpr = FirstColumnStyle;
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
                field(EMailAddress1;EMailAddress1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Email Address';
                    ToolTip = 'Specifies the email address.';
                }
                field(Fax;Fax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Fax';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(WebSiteUrl;WebSiteUrl)
                {
                    ApplicationArea = Suite;
                    Caption = 'Website URL';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(MobilePhone;MobilePhone)
                {
                    ApplicationArea = Suite;
                    Caption = 'Mobile Phone';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Pager;Pager)
                {
                    ApplicationArea = Suite;
                    Caption = 'Pager';
                    ToolTip = 'Specifies data from a corresponding field in a Microsoft Dynamics CRM entity. For more information about Microsoft Dynamics CRM, see Microsoft Dynamics CRM Help Center.';
                }
                field(Telephone1;Telephone1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Telephone';
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
                Caption = 'Create Contact in Dynamics NAV';
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create a contact in Dynamics NAV that is linked to the Dynamics CRM contact.';
                Visible = AllowCreateFromCRM;

                trigger OnAction()
                var
                    CRMContact: Record "CRM Contact";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    CRMContactRecordRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(CRMContact);
                    CRMContact.Next;

                    if CRMContact.Count = 1 then
                      CRMIntegrationManagement.CreateNewRecordFromCRM(CRMContact.ContactId,Database::Contact)
                    else begin
                      CRMContactRecordRef.GetTable(CRMContact);
                      CRMIntegrationManagement.CreateNewRecordsFromCRM(CRMContactRecordRef);
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
        if CRMIntegrationRecord.FindRecordIDFromID(ContactId,Database::Contact,RecordID) then
          if CurrentlyCoupledCRMContact.ContactId = ContactId then begin
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
        CurrentlyCoupledCRMContact: Record "CRM Contact";
        AllowCreateFromCRM: Boolean;
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetAllowCreateFromCRM(Allow: Boolean)
    begin
        AllowCreateFromCRM := Allow;
    end;


    procedure SetCurrentlyCoupledCRMContact(CRMContact: Record "CRM Contact")
    begin
        CurrentlyCoupledCRMContact := CRMContact;
    end;
}

