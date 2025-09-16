#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5053 TAPIManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'No Contact found.';
        Text002: label 'No registered phone numbers have been found for this %1.';


    procedure Dial(PhoneNumber: Text[80]): Boolean
    begin
        Hyperlink(StrSubstNo('tel:%1',PhoneNumber));
        exit(true);
    end;


    procedure DialContCustVendBank(TableNo: Integer;No: Code[20];PhoneNo: Text[30];ContAltAddrCode: Code[10])
    var
        ContBusRel: Record "Contact Business Relation";
        Contact: Record Contact;
        Todo: Record "To-do";
        TempSegmentLine: Record "Segment Line" temporary;
    begin
        case TableNo of
          Database::Contact:
            Contact.Get(No);
          Database::"To-do":
            begin
              Todo.Get(No);
              Todo.TestField("Contact No.");
              Contact.Get(Todo."Contact No.");
            end;
          else begin
            ContBusRel.Reset;
            ContBusRel.SetCurrentkey("Link to Table","No.");
            case TableNo of
              Database::Customer:
                ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
              Database::Vendor:
                ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Vendor);
              Database::"Bank Account":
                ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::"Bank Account");
            end;
            ContBusRel.SetRange("No.",No);
            if ContBusRel.FindFirst then
              Contact.Get(ContBusRel."Contact No.")
            else
              Error(Text001);
          end;
        end;

        // Call Make Phone Call Wizard
        TempSegmentLine.MakePhoneCallFromContact(Contact,Todo,TableNo,PhoneNo,ContAltAddrCode);
    end;


    procedure ShowNumbers(ContactNo: Code[20];ContAltAddrCode: Code[10]): Text[260]
    var
        TempCommunicationMethod: Record "Communication Method" temporary;
        Contact: Record Contact;
        Contact2: Record Contact;
        ContAltAddrCode2: Code[10];
    begin
        if not Contact.Get(ContactNo) then
          exit;

        if ContAltAddrCode = '' then
          ContAltAddrCode2 := Contact.ActiveAltAddress(Today)
        else
          ContAltAddrCode2 := ContAltAddrCode;

        CreateCommMethod(Contact,TempCommunicationMethod,ContactNo,ContAltAddrCode);

        // Get linked company phonenumbers
        if (Contact.Type = Contact.Type::Person) and (Contact."Company No." <> '') then begin
          Contact2.Get(Contact."Company No.");

          if ContAltAddrCode = '' then
            ContAltAddrCode2 := Contact2.ActiveAltAddress(Today)
          else
            ContAltAddrCode2 := ContAltAddrCode;

          CreateCommMethod(Contact2,TempCommunicationMethod,ContactNo,ContAltAddrCode2);
        end;
        if TempCommunicationMethod.FindFirst then begin
          if Page.RunModal(Page::"Contact Through",TempCommunicationMethod) = Action::LookupOK then
            exit(TempCommunicationMethod.Number);
        end else
          Error(Text002,Contact.TableCaption);
    end;

    local procedure TrimCode("Code": Code[20]) TrimString: Text[20]
    begin
        TrimString := CopyStr(Code,1,1) + Lowercase(CopyStr(Code,2,StrLen(Code) - 1))
    end;

    local procedure CreateCommMethod(Contact: Record Contact;var TempCommunicationMethod: Record "Communication Method" temporary;ContactNo: Code[20];ContAltAddrCode: Code[10])
    var
        ContAltAddr: Record "Contact Alt. Address";
        I: Integer;
    begin
        with TempCommunicationMethod do begin
          Init;
          "Contact No." := ContactNo;
          Name := Contact.Name;
          if Contact."Phone No." <> '' then begin
            I := I + 1;
            Key := I;
            Description := CopyStr(Contact.FieldCaption("Phone No."),1,MaxStrLen(Description));
            Number := Contact."Phone No.";
            Type := Contact.Type;
            Insert;
          end;
          if Contact."Mobile Phone No." <> '' then begin
            I := I + 1;
            Key := I;
            Description := CopyStr(Contact.FieldCaption("Mobile Phone No."),1,MaxStrLen(Description));
            Number := Contact."Mobile Phone No.";
            Type := Contact.Type;
            Insert;
          end;

          // Alternative address
          if ContAltAddr.Get(Contact."No.",ContAltAddrCode) then begin
            if ContAltAddr."Phone No." <> '' then begin
              I := I + 1;
              Key := I;
              Description :=
                CopyStr(TrimCode(ContAltAddr.Code) + ' - ' + ContAltAddr.FieldCaption("Phone No."),1,MaxStrLen(Description));
              Number := ContAltAddr."Phone No.";
              Type := Contact.Type;
              Insert;
            end;
            if ContAltAddr."Mobile Phone No." <> '' then begin
              I := I + 1;
              Key := I;
              Description :=
                CopyStr(TrimCode(ContAltAddr.Code) + ' - ' + ContAltAddr.FieldCaption("Mobile Phone No."),1,MaxStrLen(Description));
              Number := ContAltAddr."Mobile Phone No.";
              Type := Contact.Type;
              Insert;
            end;
          end;
        end;
    end;
}

