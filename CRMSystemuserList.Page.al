#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5340 "CRM Systemuser List"
{
    Caption = 'Microsoft Dynamics CRM Users';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Systemuser";
    SourceTableView = sorting(FullName);

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
                field(InternalEMailAddress;InternalEMailAddress)
                {
                    ApplicationArea = Suite;
                    Caption = 'Email Address';
                    ToolTip = 'Specifies the email address.';
                }
                field(MobilePhone;MobilePhone)
                {
                    ApplicationArea = Suite;
                    Caption = 'Mobile Phone';
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
    }

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
    begin
        if CRMIntegrationRecord.FindRecordIDFromID(SystemUserId,Database::"Salesperson/Purchaser",RecordID) then
          if CurrentlyCoupledCRMSystemuser.SystemUserId = SystemUserId then begin
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
        CurrentlyCoupledCRMSystemuser: Record "CRM Systemuser";
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetCurrentlyCoupledCRMSystemuser(CRMSystemuser: Record "CRM Systemuser")
    begin
        CurrentlyCoupledCRMSystemuser := CRMSystemuser;
    end;
}

