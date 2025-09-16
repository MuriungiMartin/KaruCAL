#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5900 ServOrderManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'You cannot create a %1, because the %2 field is not empty.';
        Text001: label 'You must specify %1, %2 and %3 in %4 %5, before you create new %6.';
        Text002: label 'This customer already exists.\\';
        Text003: label 'Do you want create a new %1 instead of using the existing one?';
        Text004: label 'There are no Customer Templates.';
        Text005: label 'Posting cannot be completed successfully. The %1 field on the service invoice lines should contain 1 because %2 %3 was replaced.';
        Text006: label 'The %1 %2 is already assigned to %3 %4.';
        Text007: label '%1 %2 was created.';
        Text008: label 'There is not enough space to insert %1.';
        Text009: label 'Travel fee in the %1 table with %2 %3 cannot be found.';
        Text011: label 'There is no %1 for %2 %3.';
        Text012: label 'You can not post %1 %2.\\%3 %4 in %5 line %6 is preventing it.';


    procedure ServHeaderLookup(DocumentType: Integer;var DocumentNo: Code[20]): Boolean
    var
        ServHeader: Record "Service Header";
    begin
        if ServHeader.Get(DocumentType,DocumentNo) then begin
          ServHeader.SetRange("Document Type",DocumentType);
          if Page.RunModal(0,ServHeader) = Action::LookupOK then begin
            DocumentNo := ServHeader."No.";
            exit(true);
          end;
        end;
        exit(false);
    end;


    procedure UpdateResponseDateTime(var ServItemLine: Record "Service Item Line";Deleting: Boolean)
    var
        ServItemLine2: Record "Service Item Line";
        ServHeader: Record "Service Header";
        NewResponseDate: Date;
        NewResponseTime: Time;
    begin
        if not ServHeader.Get(ServItemLine."Document Type",ServItemLine."Document No.") then
          exit;

        if not Deleting then begin
          NewResponseDate := ServItemLine."Response Date";
          NewResponseTime := ServItemLine."Response Time";
        end;

        ServItemLine2.Reset;
        ServItemLine2.SetRange("Document Type",ServItemLine."Document Type");
        ServItemLine2.SetRange("Document No.",ServItemLine."Document No.");
        ServItemLine2.SetFilter("Line No.",'<>%1',ServItemLine."Line No.");
        if ServItemLine2.Find('-') then begin
          if Deleting then begin
            NewResponseDate := ServItemLine2."Response Date";
            NewResponseTime := ServItemLine2."Response Time";
          end;
          repeat
            if ServItemLine2."Response Date" < NewResponseDate then begin
              NewResponseDate := ServItemLine2."Response Date";
              NewResponseTime := ServItemLine2."Response Time"
            end else
              if (ServItemLine2."Response Date" = NewResponseDate) and
                 (ServItemLine2."Response Time" < NewResponseTime)
              then
                NewResponseTime := ServItemLine2."Response Time";
          until ServItemLine2.Next = 0;
        end;

        if (ServHeader."Response Date" <> NewResponseDate) or
           (ServHeader."Response Time" <> NewResponseTime)
        then begin
          ServHeader."Response Date" := NewResponseDate;
          ServHeader."Response Time" := NewResponseTime;
          ServHeader.Modify;
        end;
    end;


    procedure CreateNewCustomer(var ServHeader: Record "Service Header")
    var
        Cust: Record Customer;
        DefaultDim: Record "Default Dimension";
        DefaultDim2: Record "Default Dimension";
        CustTempl: Record "Customer Template";
        FromCustInvDisc: Record "Cust. Invoice Disc.";
        ToCustInvDisc: Record "Cust. Invoice Disc.";
        CustContUpdate: Codeunit "CustCont-Update";
    begin
        with ServHeader do begin
          if "Customer No." <> '' then
            Error(
              Text000,
              Cust.TableCaption,FieldCaption("Customer No."));
          if (Name = '') or (Address = '') or (City = '') then
            Error(
              Text001,
              FieldCaption(Name),FieldCaption(Address),FieldCaption(City),TableCaption,"No.",Cust.TableCaption);

          Cust.Reset;
          Cust.SetCurrentkey(Name,Address,City);
          Cust.SetRange(Name,Name);
          Cust.SetRange(Address,Address);
          Cust.SetRange(City,City);
          if Cust.FindFirst then
            if not
               Confirm(
                 Text002 + Text003,
                 false,Cust.TableCaption)
            then begin
              Validate("Customer No.",Cust."No.");
              exit;
            end;
          CustTempl.Reset;
          if not CustTempl.FindFirst then
            Error(Text004);
          if Page.RunModal(Page::"Customer Template List",CustTempl) = Action::LookupOK then begin
            Cust."No." := '';
            Cust.Validate(Name,Name);
            Cust."Name 2" := "Name 2";
            Cust.Address := Address;
            Cust."Address 2" := "Address 2";
            Cust.City := City;
            Cust."Post Code" := "Post Code";
            Cust.Contact := "Contact Name";
            Cust."Phone No." := "Phone No.";
            Cust."E-Mail" := "E-Mail";
            Cust.Blocked := Cust.Blocked::" ";
            Cust."Territory Code" := CustTempl."Territory Code";
            Cust."Global Dimension 1 Code" := CustTempl."Global Dimension 1 Code";
            Cust."Global Dimension 2 Code" := CustTempl."Global Dimension 2 Code";
            Cust."Customer Posting Group" := CustTempl."Customer Posting Group";
            Cust."Currency Code" := CustTempl."Currency Code";
            Cust."Invoice Disc. Code" := CustTempl."Invoice Disc. Code";
            Cust."Customer Price Group" := CustTempl."Customer Price Group";
            Cust."Customer Disc. Group" := CustTempl."Customer Disc. Group";
            Cust."Country/Region Code" := CustTempl."Country/Region Code";
            Cust."Allow Line Disc." := CustTempl."Allow Line Disc.";
            Cust."Gen. Bus. Posting Group" := CustTempl."Gen. Bus. Posting Group";
            Cust."VAT Bus. Posting Group" := CustTempl."VAT Bus. Posting Group";
            Cust.Validate("Payment Terms Code",CustTempl."Payment Terms Code");
            Cust.Validate("Payment Method Code",CustTempl."Payment Method Code");
            Cust."Shipment Method Code" := CustTempl."Shipment Method Code";
            Cust."Tax Area Code" := CustTempl."Tax Area Code";
            Cust."Tax Liable" := CustTempl."Tax Liable";
            if CustTempl.State <> '' then
              Cust.County := CustTempl.State
            else
              Cust.County := County;
            Cust."Credit Limit (LCY)" := CustTempl."Credit Limit (LCY)";
            Cust.Insert(true);

            if "Contact Name" <> '' then begin
              CustContUpdate.InsertNewContactPerson(Cust,false);
              Cust.Modify;
            end;

            DefaultDim.Reset;
            DefaultDim.SetRange("Table ID",Database::"Customer Template");
            DefaultDim.SetRange("No.",CustTempl.Code);
            if DefaultDim.Find('-') then
              repeat
                DefaultDim2 := DefaultDim;
                DefaultDim2."Table ID" := Database::Customer;
                DefaultDim2."No." := Cust."No.";
                DefaultDim2.Insert(true);
              until DefaultDim.Next = 0;

            if CustTempl."Invoice Disc. Code" <> '' then begin
              FromCustInvDisc.Reset;
              FromCustInvDisc.SetRange(Code,CustTempl."Invoice Disc. Code");
              if FromCustInvDisc.Find('-') then
                repeat
                  ToCustInvDisc.Init;
                  ToCustInvDisc.Code := Cust."No.";
                  ToCustInvDisc."Currency Code" := FromCustInvDisc."Currency Code";
                  ToCustInvDisc."Minimum Amount" := FromCustInvDisc."Minimum Amount";
                  ToCustInvDisc."Discount %" := FromCustInvDisc."Discount %";
                  ToCustInvDisc."Service Charge" := FromCustInvDisc."Service Charge";
                  ToCustInvDisc.Insert;
                until FromCustInvDisc.Next = 0;
            end;
            Validate("Customer No.",Cust."No.");
          end;
        end;
    end;


    procedure ReplacementCreateServItem(FromServItem: Record "Service Item";ServiceLine: Record "Service Line";ServShptDocNo: Code[20];ServShptLineNo: Integer;var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        NewServItem: Record "Service Item";
        ResSkill: Record "Resource Skill";
        ServLogMgt: Codeunit ServLogManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ResSkillMgt: Codeunit "Resource Skill Mgt.";
        SerialNo: Code[20];
    begin
        if ServiceLine.Quantity <> 1 then
          Error(Text005,ServiceLine.FieldCaption(Quantity),FromServItem.TableCaption,FromServItem."No.");

        SerialNo := '';
        TempTrackingSpecification.Reset;
        TempTrackingSpecification.SetCurrentkey(
          "Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        TempTrackingSpecification.SetRange("Source Type",Database::"Service Line");
        TempTrackingSpecification.SetRange("Source Subtype",ServiceLine."Document Type");
        TempTrackingSpecification.SetRange("Source ID",ServiceLine."Document No.");
        TempTrackingSpecification.SetRange("Source Ref. No.",ServiceLine."Line No.");
        if TempTrackingSpecification.Find('-') then
          SerialNo := TempTrackingSpecification."Serial No.";

        if SerialNo <> '' then begin
          NewServItem.Reset;
          NewServItem.SetCurrentkey("Item No.","Serial No.");
          NewServItem.SetRange("Item No.",ServiceLine."No.");
          NewServItem.SetRange("Variant Code",ServiceLine."Variant Code");
          NewServItem.SetRange("Serial No.",SerialNo);
          if NewServItem.FindFirst then
            Error(
              Text006,
              NewServItem.TableCaption,NewServItem."No.",NewServItem.FieldCaption("Serial No."),NewServItem."Serial No.");
        end;

        NewServItem.Reset;
        ServMgtSetup.Get;
        NewServItem := FromServItem;
        NewServItem."No." := '';
        NoSeriesMgt.InitSeries(
          ServMgtSetup."Service Item Nos.",NewServItem."No. Series",0D,NewServItem."No.",NewServItem."No. Series");
        NewServItem."Serial No." := SerialNo;
        NewServItem."Variant Code" := ServiceLine."Variant Code";
        NewServItem."Shipment Type" := NewServItem."shipment type"::Service;
        NewServItem."Sales/Serv. Shpt. Document No." := ServShptDocNo;
        NewServItem."Sales/Serv. Shpt. Line No." := ServShptLineNo;
        case ServiceLine."Spare Part Action" of
          ServiceLine."spare part action"::"Temporary":
            NewServItem.Status := NewServItem.Status::"Temporarily Installed";
          ServiceLine."spare part action"::Permanent:
            NewServItem.Status := NewServItem.Status::Installed;
        end;

        NewServItem.Insert;
        ResSkillMgt.CloneObjectResourceSkills(ResSkill.Type::"Service Item",FromServItem."No.",NewServItem."No.");

        Clear(ServLogMgt);
        ServLogMgt.ServItemAutoCreated(NewServItem);

        Clear(ServLogMgt);
        ServLogMgt.ServItemReplaced(FromServItem,NewServItem);
        FromServItem.Status := FromServItem.Status::Defective;
        FromServItem.Modify;
        case ServiceLine."Copy Components From" of
          ServiceLine."copy components from"::"Item BOM":
            CopyComponentsFromBOM(NewServItem);
          ServiceLine."copy components from"::"Old Service Item":
            CopyComponentsFromSI(FromServItem,NewServItem,true);
          ServiceLine."copy components from"::"Old Serv.Item w/o Serial No.":
            CopyComponentsFromSI(FromServItem,NewServItem,false);
        end;

        Message(
          Text007,
          NewServItem.TableCaption,NewServItem."No.");
    end;


    procedure InsertServCost(ServInvLine: Record "Service Line";CostType: Integer;LinktoServItemLine: Boolean): Boolean
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        ServHeader: Record "Service Header";
        ServInvLine2: Record "Service Line";
        ServCost: Record "Service Cost";
        NextLine: Integer;
    begin
        ServHeader.Get(ServInvLine."Document Type",ServInvLine."Document No.");

        ServInvLine2.Reset;
        ServInvLine2.SetRange("Document Type",ServInvLine."Document Type");
        ServInvLine2.SetRange("Document No.",ServInvLine."Document No.");
        ServInvLine2 := ServInvLine;

        NextLine := ServInvLine.GetNextLineNo(ServInvLine,false);
        if NextLine = 0 then
          Error(Text008,ServInvLine.TableCaption);

        case CostType of
          0: // Travel Fee
            begin
              ServHeader.TestField("Service Zone Code");
              ServCost.Reset;
              ServCost.SetCurrentkey("Service Zone Code");
              ServCost.SetRange("Service Zone Code",ServHeader."Service Zone Code");
              ServCost.SetRange("Cost Type",ServCost."cost type"::Travel);
              if not ServCost.FindFirst then
                Error(
                  Text009,
                  ServCost.TableCaption,ServCost.FieldCaption("Service Zone Code"),ServHeader."Service Zone Code");

              ServInvLine2.Init;
              if LinktoServItemLine then begin
                ServInvLine2."Service Item Line No." := ServInvLine."Service Item Line No.";
                ServInvLine2."Service Item No." := ServInvLine."Service Item No.";
                ServInvLine2."Service Item Serial No." := ServInvLine."Service Item Serial No.";
              end;
              ServInvLine2."Document Type" := ServHeader."Document Type";
              ServInvLine2."Document No." := ServHeader."No.";
              ServInvLine2."Line No." := NextLine;
              ServInvLine2.Type := ServInvLine2.Type::Cost;
              ServInvLine2.Validate("No.",ServCost.Code);
              ServInvLine2.Validate("Unit of Measure Code",ServCost."Unit of Measure Code");
              ServInvLine2.Insert(true);
              exit(true);
            end;
          1: // Starting Fee
            begin
              ServMgtSetup.Get;
              ServMgtSetup.TestField("Service Order Starting Fee");
              ServCost.Get(ServMgtSetup."Service Order Starting Fee");
              ServInvLine2.Init;
              if LinktoServItemLine then begin
                ServInvLine2."Service Item Line No." := ServInvLine."Service Item Line No.";
                ServInvLine2."Service Item No." := ServInvLine."Service Item No.";
                ServInvLine2."Service Item Serial No." := ServInvLine."Service Item Serial No.";
              end;
              ServInvLine2."Document Type" := ServHeader."Document Type";
              ServInvLine2."Document No." := ServHeader."No.";
              ServInvLine2."Line No." := NextLine;
              ServInvLine2.Type := ServInvLine2.Type::Cost;
              ServInvLine2.Validate("No.",ServCost.Code);
              ServInvLine2.Validate("Unit of Measure Code",ServCost."Unit of Measure Code");
              ServInvLine2.Insert(true);
              exit(true);
            end;
          else
            exit(false);
        end;
    end;


    procedure FindContactInformation(CustNo: Code[20]): Code[20]
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        Cust: Record Customer;
        ContBusRel: Record "Contact Business Relation";
        ContJobResp: Record "Contact Job Responsibility";
        Cont: Record Contact;
        ContactFound: Boolean;
    begin
        if Cust.Get(CustNo) then begin
          ServMgtSetup.Get;
          ContactFound := false;
          ContBusRel.Reset;
          ContBusRel.SetCurrentkey("Link to Table","No.");
          ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
          ContBusRel.SetRange("No.",Cust."No.");
          Cont.Reset;
          Cont.SetCurrentkey("Company No.");
          Cont.SetRange(Type,Cont.Type::Person);
          if ContBusRel.FindFirst then begin
            Cont.SetRange("Company No.",ContBusRel."Contact No.");
            if Cont.Find('-') then
              repeat
                ContJobResp.Reset;
                ContJobResp.SetRange("Contact No.",Cont."No.");
                ContJobResp.SetRange("Job Responsibility Code",ServMgtSetup."Serv. Job Responsibility Code");
                ContactFound := ContJobResp.FindFirst;
              until (Cont.Next = 0) or ContactFound;
          end;
          if ContactFound then begin
            Cont.Get(ContJobResp."Contact No.");
            exit(Cont."No.");
          end;
        end;
    end;


    procedure FindResLocationCode(ResourceNo: Code[20];StartDate: Date): Code[10]
    var
        ResLocation: Record "Resource Location";
    begin
        ResLocation.Reset;
        ResLocation.SetCurrentkey("Resource No.","Starting Date");
        ResLocation.SetRange("Resource No.",ResourceNo);
        ResLocation.SetRange("Starting Date",0D,StartDate);
        if ResLocation.FindLast then
          exit(ResLocation."Location Code");
    end;


    procedure CalcServTime(StartingDate: Date;StartingTime: Time;FinishingDate: Date;FinishingTime: Time;ContractNo: Code[20];ContractCalendarExists: Boolean): Decimal
    var
        CalChange: Record "Customized Calendar Change";
        ServHour: Record "Service Hour";
        ServMgtSetup: Record "Service Mgt. Setup";
        CalendarMgmt: Codeunit "Calendar Management";
        TotTime: Decimal;
        TempDay: Integer;
        TempDate: Date;
        Holiday: Boolean;
        CalendarCustomized: Boolean;
        NewDescription: Text[50];
        MiliSecPerDay: Decimal;
    begin
        MiliSecPerDay := 86400000;
        if (StartingDate = 0D) or (StartingTime = 0T) or (FinishingDate = 0D) or (FinishingTime = 0T) then
          exit(0);

        ServHour.Reset;
        if (ContractNo <> '') and ContractCalendarExists then begin
          ServHour.SetRange("Service Contract Type",ServHour."service contract type"::Contract);
          ServHour.SetRange("Service Contract No.",ContractNo)
        end else begin
          ServHour.SetRange("Service Contract Type",ServHour."service contract type"::" ");
          ServHour.SetRange("Service Contract No.",'');
        end;

        if ServHour.IsEmpty then
          exit(
            ROUND(
              ((FinishingDate - StartingDate) * MiliSecPerDay +
               CalendarMgmt.CalcTimeDelta(FinishingTime,StartingTime)) / 3600000,0.01));

        TotTime := 0;
        TempDate := StartingDate;

        ServMgtSetup.Get;
        ServMgtSetup.TestField("Base Calendar Code");
        CalendarCustomized :=
          CalendarMgmt.CustomizedChangesExist(CalChange."source type"::Service,'','',ServMgtSetup."Base Calendar Code");

        repeat
          TempDay := Date2dwy(TempDate,1) - 1;
          ServHour.SetFilter("Starting Date",'<=%1',TempDate);
          ServHour.SetRange(Day,TempDay);
          if ServHour.FindLast then begin
            if CalendarCustomized then
              Holiday :=
                CalendarMgmt.CheckCustomizedDateStatus(
                  CalChange."source type"::Service,'','',ServMgtSetup."Base Calendar Code",TempDate,NewDescription)
            else
              Holiday := CalendarMgmt.CheckDateStatus(ServMgtSetup."Base Calendar Code",TempDate,NewDescription);

            if not Holiday or ServHour."Valid on Holidays" then begin
              if StartingDate > FinishingDate then
                exit(0);

              if StartingDate = FinishingDate then
                TotTime := CalendarMgmt.CalcTimeDelta(FinishingTime,StartingTime)
              else
                case TempDate of
                  StartingDate:
                    if ServHour."Ending Time" > StartingTime then
                      TotTime := TotTime + CalendarMgmt.CalcTimeDelta(ServHour."Ending Time",StartingTime);
                  FinishingDate:
                    if FinishingTime > ServHour."Starting Time" then
                      TotTime := TotTime + CalendarMgmt.CalcTimeDelta(FinishingTime,ServHour."Starting Time");
                  else
                    TotTime := TotTime + CalendarMgmt.CalcTimeDelta(ServHour."Ending Time",ServHour."Starting Time");
                end;
            end;
          end;
          TempDate := TempDate + 1;
        until TempDate > FinishingDate;

        exit(ROUND(TotTime / 3600000,0.01));
    end;


    procedure LookupServItemNo(var ServItemLine: Record "Service Item Line")
    var
        ServHeader: Record "Service Header";
        ServItem: Record "Service Item";
        ServContractLine: Record "Service Contract Line";
        ServItemList: Page "Service Item List";
        ServContractLineList: Page "Serv. Item List (Contract)";
    begin
        ServHeader.Get(ServItemLine."Document Type",ServItemLine."Document No.");

        if ServHeader."Contract No." = '' then begin
          if ServItem.Get(ServItemLine."Service Item No.") then
            ServItemList.SetRecord(ServItem);
          ServItem.Reset;
          ServItem.SetCurrentkey("Customer No.","Ship-to Code");
          ServItem.SetRange("Customer No.",ServHeader."Customer No.");
          ServItem.SetRange("Ship-to Code",ServHeader."Ship-to Code");
          ServItemList.SetTableview(ServItem);
          ServItemList.LookupMode(true);
          if ServItemList.RunModal = Action::LookupOK then begin
            ServItemList.GetRecord(ServItem);
            ServItemLine.Validate("Service Item No.",ServItem."No.");
          end;
        end else begin
          if ServItemLine."Service Item No." <> '' then
            if ServContractLine.Get(
                 ServContractLine."contract type"::Contract,
                 ServItemLine."Contract No.",ServItemLine."Contract Line No.")
            then
              ServContractLineList.SetRecord(ServContractLine);
          ServContractLine.Reset;
          ServContractLine.FilterGroup(2);
          ServContractLine.SetRange("Contract Type",ServContractLine."contract type"::Contract);
          ServContractLine.SetRange("Contract No.",ServHeader."Contract No.");
          ServContractLine.SetRange("Contract Status",ServContractLine."contract status"::Signed);
          ServContractLine.SetRange("Customer No.",ServHeader."Customer No.");
          ServContractLine.SetFilter("Starting Date",'<=%1',ServHeader."Order Date");
          ServContractLine.SetFilter("Contract Expiration Date",'>%1 | =%2',ServHeader."Order Date",0D);
          ServContractLine.FilterGroup(0);
          ServContractLine.SetRange("Ship-to Code",ServHeader."Ship-to Code");
          ServContractLineList.SetTableview(ServContractLine);
          ServContractLineList.LookupMode(true);
          if ServContractLineList.RunModal = Action::LookupOK then begin
            ServContractLineList.GetRecord(ServContractLine);
            ServItemLine.Validate("Service Item No.",ServContractLine."Service Item No.");
          end;
        end;
    end;


    procedure UpdatePriority(var ServItemLine: Record "Service Item Line";Deleting: Boolean)
    var
        ServItemLine2: Record "Service Item Line";
        ServHeader: Record "Service Header";
        NewPriority: Integer;
    begin
        if not ServHeader.Get(ServItemLine."Document Type",ServItemLine."Document No.") then
          exit;

        if not Deleting then
          NewPriority := ServItemLine.Priority;

        ServItemLine2.Reset;
        ServItemLine2.SetRange("Document Type",ServItemLine."Document Type");
        ServItemLine2.SetRange("Document No.",ServItemLine."Document No.");
        ServItemLine2.SetFilter("Line No.",'<>%1',ServItemLine."Line No.");
        if ServItemLine2.Find('-') then
          repeat
            if ServItemLine2.Priority > NewPriority then
              NewPriority := ServItemLine2.Priority;
          until ServItemLine2.Next = 0;

        if ServHeader.Priority <> NewPriority then begin
          ServHeader.Priority := NewPriority;
          ServHeader.Modify;
        end;
    end;

    local procedure CopyComponentsFromSI(OldServItem: Record "Service Item";NewServItem: Record "Service Item";CopySerialNo: Boolean)
    var
        ServItemComponent: Record "Service Item Component";
        OldSIComponent: Record "Service Item Component";
    begin
        OldSIComponent.Reset;
        OldSIComponent.SetRange(Active,true);
        OldSIComponent.SetRange("Parent Service Item No.",OldServItem."No.");
        if OldSIComponent.Find('-') then begin
          repeat
            Clear(ServItemComponent);
            ServItemComponent.Init;
            ServItemComponent := OldSIComponent;
            ServItemComponent."Parent Service Item No." := NewServItem."No.";
            if not CopySerialNo then
              ServItemComponent."Serial No." := '';
            ServItemComponent.Insert;
          until OldSIComponent.Next = 0;
        end else
          Error(
            Text011,
            ServItemComponent.TableCaption,OldServItem.FieldCaption("No."),OldServItem."No.");
    end;

    local procedure CopyComponentsFromBOM(var NewServItem: Record "Service Item")
    begin
        Codeunit.Run(Codeunit::"ServComponent-Copy from BOM",NewServItem);
    end;


    procedure InServiceContract(var ServInvLine: Record "Service Line"): Boolean
    begin
        exit(ServInvLine."Contract No." <> '');
    end;


    procedure CheckServItemRepairStatus(ServHeader: Record "Service Header";var ServItemLine: Record "Service Item Line" temporary;var ServLine: Record "Service Line")
    var
        RepairStatus: Record "Repair Status";
    begin
        if ServItemLine.Get(ServHeader."Document Type",ServHeader."No.",ServLine."Service Item Line No.") then
          if ServItemLine."Repair Status Code" <> '' then begin
            RepairStatus.Get(ServItemLine."Repair Status Code");
            if not RepairStatus."Posting Allowed" then
              Error(
                Text012,
                ServHeader.TableCaption,ServHeader."No.",ServItemLine.FieldCaption("Repair Status Code"),
                ServItemLine."Repair Status Code",ServItemLine.TableCaption,ServItemLine."Line No.")
          end;
    end;


    procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNo: Code[20];ToNo: Code[20])
    var
        ServCommentLine: Record "Service Comment Line";
        ServCommentLine2: Record "Service Comment Line";
    begin
        ServCommentLine.Reset;
        ServCommentLine.SetRange("Table Name",FromDocumentType);
        ServCommentLine.SetRange("No.",FromNo);
        if ServCommentLine.Find('-') then
          repeat
            ServCommentLine2 := ServCommentLine;
            ServCommentLine2."Table Name" := ToDocumentType;
            ServCommentLine2."Table Subtype" := 0;
            ServCommentLine2."No." := ToNo;
            ServCommentLine2.Insert;
          until ServCommentLine.Next = 0;
    end;


    procedure CalcContractDates(var ServHeader: Record "Service Header";var ServItemLine: Record "Service Item Line")
    var
        ServContractLine: Record "Service Contract Line";
    begin
        if ServContractLine.Get(
             ServContractLine."contract type"::Contract,
             ServItemLine."Contract No.",
             ServItemLine."Contract Line No.")
        then begin
          ServContractLine.SuspendStatusCheck(true);
          if ServHeader."Finishing Date" <> 0D then
            ServContractLine."Last Service Date" := ServHeader."Finishing Date"
          else
            ServContractLine."Last Service Date" := ServHeader."Posting Date";
          ServContractLine."Last Planned Service Date" :=
            ServContractLine."Next Planned Service Date";
          ServContractLine.CalculateNextServiceVisit;
          ServContractLine."Last Preventive Maint. Date" := ServContractLine."Last Service Date";
        end;
        ServContractLine.Modify;
    end;


    procedure CalcServItemDates(var ServHeader: Record "Service Header";ServItemNo: Code[20])
    var
        ServItem: Record "Service Item";
    begin
        if ServItem.Get(ServItemNo) then begin
          if ServHeader."Finishing Date" <> 0D then
            ServItem."Last Service Date" := ServHeader."Finishing Date"
          else
            ServItem."Last Service Date" := ServHeader."Posting Date";
          ServItem.Modify;
        end;
    end;
}

