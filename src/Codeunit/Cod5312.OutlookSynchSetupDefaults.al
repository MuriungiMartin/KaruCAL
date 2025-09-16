#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5312 "Outlook Synch. Setup Defaults"
{

    trigger OnRun()
    begin
    end;

    var
        OutlookSynchEntity: Record "Outlook Synch. Entity";
        OutlookSynchField: Record "Outlook Synch. Field";
        OutlookSynchFilter: Record "Outlook Synch. Filter";
        Text012: label 'Reset to defaults...';
        Text013: label '%1 of the %2 entity must be %3 not %4.';
        Text102: label '%1 Contacts of the Person type', Comment='%1 - product name';
        OutlookSynchEntityElement: Record "Outlook Synch. Entity Element";
        OutlookSynchDependency: Record "Outlook Synch. Dependency";
        OutlookSynchOptionCorrel: Record "Outlook Synch. Option Correl.";
        OutlookSynchUserSetup: Record "Outlook Synch. User Setup";
        "Field": Record "Field";
        OutlookSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt.";
        OutlookSynchTypeConv: Codeunit "Outlook Synch. Type Conv";
        Text100: label '%1 Meetings', Comment='%1 - product name';
        Text101: label '%1 Tasks', Comment='%1 - product name';
        Text103: label '%1 Contacts of the Company type', Comment='%1 - product name';
        Text104: label '%1 Salespeople', Comment='%1 - product name';
        Text009: label 'You cannot reset the %1 entity to defaults because it is being used for synchronization. Remove this entity from %2 and try again.';
        Text010: label 'The %1 entity has collections that depend on it. All dependencies will be now deleted.\Do you want to proceed anyway?';
        Text110: label 'CONT_PERS', Locked=true;
        Text111: label 'CONT_COMP', Locked=true;
        Text112: label 'CONT_SP', Locked=true;
        Text130: label 'APP', Locked=true;
        Text131: label 'TASK', Locked=true;


    procedure ResetEntity(SynchEntityCode: Code[10])
    var
        Window: Dialog;
        Selected: Integer;
    begin
        Selected :=
          StrMenu(
            StrSubstNo(
              '%1,%2,%3,%4,%5',StrSubstNo(Text100,ProductName.Full),StrSubstNo(Text101,ProductName.Full),
              StrSubstNo(Text103,ProductName.Full),StrSubstNo(Text102,ProductName.Full),StrSubstNo(Text104,ProductName.Full)));

        if Selected = 0 then
          exit;

        OutlookSynchEntity.Get(SynchEntityCode);

        OutlookSynchDependency.Reset;
        OutlookSynchDependency.SetRange("Depend. Synch. Entity Code",SynchEntityCode);
        if OutlookSynchDependency.FindFirst then
          if not Confirm(StrSubstNo(Text010,SynchEntityCode)) then
            exit;

        OutlookSynchUserSetup.Reset;
        OutlookSynchUserSetup.SetRange("Synch. Entity Code",SynchEntityCode);
        if OutlookSynchUserSetup.FindFirst then
          Error(Text009,SynchEntityCode,OutlookSynchUserSetup.TableCaption);

        Window.Open(Text012);

        OutlookSynchDependency.DeleteAll(true);
        OutlookSynchUserSetup.DeleteAll(true);

        OutlookSynchEntityElement.Reset;
        OutlookSynchEntityElement.SetRange("Synch. Entity Code",SynchEntityCode);
        OutlookSynchEntityElement.DeleteAll(true);

        OutlookSynchField.Reset;
        OutlookSynchField.SetRange("Synch. Entity Code",SynchEntityCode);
        OutlookSynchField.DeleteAll(true);

        OutlookSynchFilter.Reset;
        OutlookSynchFilter.SetRange("Record GUID",OutlookSynchEntity."Record GUID");
        OutlookSynchFilter.DeleteAll;

        OutlookSynchEntity.Delete;

        case Selected of
          1:
            CreateDefaultApp(SynchEntityCode);
          2:
            CreateDefaultTask(SynchEntityCode);
          3:
            CreateDefaultContComp(SynchEntityCode);
          4:
            CreateDefaultContPers(SynchEntityCode);
          5:
            CreateDefaultContSp(SynchEntityCode);
        end;

        Window.Close;
    end;


    procedure InsertOSynchDefaults()
    var
        OutlookSynchEntity: Record "Outlook Synch. Entity";
        WebService: Record "Web Service";
        OutlookSynchTypeConv: Codeunit "Outlook Synch. Type Conv";
        WebServiceManagement: Codeunit "Web Service Management";
        OutlookSynchEntityRecordRef: RecordRef;
        CodeFieldRef: FieldRef;
        TempStr1: Text;
    begin
        if not OutlookSynchEntity.IsEmpty then
          exit;

        OutlookSynchEntityRecordRef.Open(Database::"Outlook Synch. Entity",true);
        CodeFieldRef := OutlookSynchEntityRecordRef.Field(OutlookSynchEntity.FieldNo(Code));

        TempStr1 := Text110;
        OutlookSynchTypeConv.TruncateString(TempStr1,CodeFieldRef.Length);
        CreateDefaultContPers(TempStr1);

        TempStr1 := Text111;
        OutlookSynchTypeConv.TruncateString(TempStr1,CodeFieldRef.Length);
        CreateDefaultContComp(TempStr1);

        TempStr1 := Text112;
        OutlookSynchTypeConv.TruncateString(TempStr1,CodeFieldRef.Length);
        CreateDefaultContSp(TempStr1);

        TempStr1 := Text130;
        OutlookSynchTypeConv.TruncateString(TempStr1,CodeFieldRef.Length);
        CreateDefaultApp(TempStr1);

        TempStr1 := Text131;
        OutlookSynchTypeConv.TruncateString(TempStr1,CodeFieldRef.Length);
        CreateDefaultTask(TempStr1);

        OutlookSynchEntityRecordRef.Close;
        WebServiceManagement.CreateWebService(WebService."object type"::Codeunit,
          Codeunit::"Outlook Synch. Dispatcher",'DynamicsNAVsynchOutlook',false);
    end;

    local procedure CreateDefaultContPers(SynchEntityCodeIn: Text)
    var
        Contact: Record Contact;
        OptionCaption: Text;
    begin
        InsertOSynchEntity(SynchEntityCodeIn,StrSubstNo(Text102,ProductName.Full),5050,'ContactItem');

        with OutlookSynchEntity do begin
          Get(SynchEntityCodeIn);
          InsertOSynchConditionFilter("Record GUID","Table No.",5050,OutlookSynchFilter.Type::CONST,0,0,'1');
          Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
          Modify;

          OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(Contact.Type::Person,"Table No.",Contact.FieldNo(Type));
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'',false,false,0,Contact.FieldNo(Type),OptionCaption,1);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'CompanyName',false,false,5050,5052,'',0);
        end;

        with OutlookSynchField do begin
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",5051,'');
            InsertOSynchTableRelationFilter("Record GUID","Table No.",5050,OutlookSynchFilter.Type::CONST,0,0,'0');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        with OutlookSynchEntity do begin
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'FullName',false,false,0,2,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'FirstName',false,false,0,5054,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'MiddleName',false,false,0,5055,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'LastName',false,false,0,5056,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'JobTitle',false,false,0,5058,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressStreet',false,false,0,5,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressCity',false,false,0,7,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressPostalCode',false,false,0,91,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressCountry',false,false,9,2,'',0);
        end;

        with OutlookSynchField do begin
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",35,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        with OutlookSynchEntity do begin
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessTelephoneNumber',false,false,0,9,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessFaxNumber',false,false,0,84,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessHomePage',false,false,0,103,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email1Address',false,false,0,102,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email2Address',false,false,0,5105,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'MobileTelephoneNumber',false,false,0,5061,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'PagerNumber',false,false,0,5062,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'TelexNumber',false,false,0,10,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Salesperson Code',true,false,0,29,'',0);
        end;

        InsertDefaultDependency(OutlookSynchEntity,Text130,'Recipients');
        InsertDefaultDependency(OutlookSynchEntity,Text130,'Links');
        InsertDefaultDependency(OutlookSynchEntity,Text131,'Links');
    end;

    local procedure CreateDefaultContComp(SynchEntityCodeIn: Text)
    var
        Contact: Record Contact;
        OptionCaption: Text;
    begin
        InsertOSynchEntity(SynchEntityCodeIn,StrSubstNo(Text103,ProductName.Full),5050,'ContactItem');

        with OutlookSynchEntity do begin
          Get(SynchEntityCodeIn);
          InsertOSynchConditionFilter("Record GUID","Table No.",5050,OutlookSynchFilter.Type::CONST,0,0,'0');
          Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
          Modify;

          OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(Contact.Type::Company,"Table No.",Contact.FieldNo(Type));
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'',false,false,0,Contact.FieldNo(Type),OptionCaption,1);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressStreet',false,false,0,5,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessAddressCity',false,false,225,2,'',0);
        end;

        with OutlookSynchField do begin
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter("Record GUID","Table No.",2,OutlookSynchFilter.Type::Field,"Master Table No.",7,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'BusinessAddressPostalCode',
            false,false,225,1,'',0);
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",91,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'BusinessAddressCountry',false,
            false,9,2,'',0);
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",35,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        with OutlookSynchEntity do begin
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessTelephoneNumber',false,false,0,9,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'CompanyName',false,false,0,2,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessFaxNumber',false,false,0,84,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email1Address',false,false,0,102,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email2Address',false,false,0,5105,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessHomePage',false,false,0,103,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'MobileTelephoneNumber',false,false,0,5061,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'PagerNumber',false,false,0,5062,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'TelexNumber',false,false,0,10,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Salesperson Code',true,false,0,29,'',0);
        end;

        InsertDefaultDependency(OutlookSynchEntity,Text130,'Recipients');
        InsertDefaultDependency(OutlookSynchEntity,Text130,'Links');
        InsertDefaultDependency(OutlookSynchEntity,Text131,'Links');
    end;

    local procedure CreateDefaultContSp(SynchEntityCodeIn: Text)
    begin
        InsertOSynchEntity(SynchEntityCodeIn,StrSubstNo(Text104,ProductName.Full),13,'ContactItem');

        with OutlookSynchEntity do begin
          Get(SynchEntityCodeIn);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'FullName',false,false,0,2,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'JobTitle',false,false,0,5062,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email1Address',false,false,0,5052,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Email2Address',false,false,0,5086,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'BusinessTelephoneNumber',false,false,0,5053,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Salesperson Code',true,false,0,1,'',1);
        end;

        InsertDefaultDependency(OutlookSynchEntity,Text130,'Recipients');
        InsertDefaultDependency(OutlookSynchEntity,Text130,'Links');
    end;

    local procedure CreateDefaultTask(SynchEntityCodeIn: Text)
    var
        OutlookSynchEntity1: Record "Outlook Synch. Entity";
    begin
        with OutlookSynchEntity do begin
          if Get(Text110) then
            if "Table No." <> 5050 then
              Error(Text013,FieldCaption("Table No."),Text110,5050,"Table No.");

          if Get(Text111) then
            if "Table No." <> 5050 then
              Error(Text013,FieldCaption("Table No."),Text111,5050,"Table No.");

          InsertOSynchEntity(SynchEntityCodeIn,StrSubstNo(Text101,ProductName.Full),5080,'TaskItem');

          Get(SynchEntityCodeIn);
          InsertOSynchConditionFilter("Record GUID","Table No.",8,OutlookSynchFilter.Type::FILTER,0,0,'<>1');
          InsertOSynchConditionFilter("Record GUID","Table No.",45,OutlookSynchFilter.Type::CONST,0,0,'0');
          InsertOSynchConditionFilter("Record GUID","Table No.",2,OutlookSynchFilter.Type::CONST,0,0,'');
          Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
          Modify;

          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'',false,false,0,8,'',1);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'StartDate',false,false,0,9,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'StartDate',false,false,0,28,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'DueDate',false,false,0,47,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'DueDate',false,false,0,48,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Subject',false,false,0,12,'',0);
        end;

        with OutlookSynchField do begin
          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Importance',false,false,0,11,
            '',0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceLow',0,0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceNormal',1,1);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceHigh',2,2);

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Status',false,false,0,10,'',0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olTaskNotStarted',0,0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olTaskInProgress',1,1);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olTaskComplete',2,2);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olTaskWaiting',3,3);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olTaskDeferred',4,4);

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Owner',false,false,13,2,'',0);
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter(
              "Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,OutlookSynchEntity."Table No.",3,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        with OutlookSynchEntityElement do begin
          InsertOutlookSynchEntityElement(OutlookSynchEntity.Code,5080,'Links');
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          if FindLast then begin
            CalcFields("Master Table No.");
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",1,'');
            InsertOSynchTableRelationFilter("Record GUID","Table No.",5,OutlookSynchFilter.Type::FILTER,"Master Table No.",0,'<>''''');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;

          InsertODependency("Synch. Entity Code","Element No.",Text110);
          OutlookSynchDependency.Get("Synch. Entity Code","Element No.",Text110);
          OutlookSynchEntity1.Get(OutlookSynchDependency."Depend. Synch. Entity Code");
          InsertOSynchTableRelationFilter(
            OutlookSynchDependency."Record GUID",OutlookSynchEntity1."Table No.",1,OutlookSynchFilter.Type::Field,"Table No.",5,'');
          OutlookSynchDependency."Table Relation" :=
            OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID",1);
          OutlookSynchDependency.Modify;

          InsertODependency("Synch. Entity Code","Element No.",Text111);
          OutlookSynchDependency.Get("Synch. Entity Code","Element No.",Text111);
          OutlookSynchEntity1.Get(OutlookSynchDependency."Depend. Synch. Entity Code");
          InsertOSynchTableRelationFilter(
            OutlookSynchDependency."Record GUID",OutlookSynchEntity1."Table No.",1,OutlookSynchFilter.Type::Field,
            OutlookSynchField."Master Table No.",5,'');
          OutlookSynchDependency."Table Relation" :=
            OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID",1);
          OutlookSynchDependency.Modify;

          InsertOutlookSynchField("Synch. Entity Code","Element No.","Table No.","Outlook Collection",'Name',false,true,5050,2,'',2);
        end;

        with OutlookSynchField do begin
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",OutlookSynchEntityElement."Element No.");
          if FindLast then begin
            OutlookSynchEntityElement.CalcFields("Master Table No.");
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",5,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;
    end;

    local procedure CreateDefaultApp(SynchEntityCodeIn: Text)
    var
        ToDo: Record "To-do";
        OptionCaption: Text;
    begin
        with OutlookSynchEntity do begin
          if Get(Text110) then
            if "Table No." <> 5050 then
              Error(Text013,FieldCaption("Table No."),Text110,5050,"Table No.");

          if Get(Text111) then
            if "Table No." <> 5050 then
              Error(Text013,FieldCaption("Table No."),Text111,5050,"Table No.");

          if Get(Text112) then
            if "Table No." <> 13 then
              Error(Text013,FieldCaption("Table No."),Text112,13,"Table No.");

          InsertOSynchEntity(SynchEntityCodeIn,StrSubstNo(Text100,ProductName.Full),5080,'AppointmentItem');

          Get(SynchEntityCodeIn);
          InsertOSynchConditionFilter("Record GUID","Table No.",8,OutlookSynchFilter.Type::CONST,0,0,'1');
          InsertOSynchConditionFilter("Record GUID","Table No.",17,OutlookSynchFilter.Type::CONST,0,0,'0');
          InsertOSynchConditionFilter("Record GUID","Table No.",45,OutlookSynchFilter.Type::CONST,0,0,'0');
          InsertOSynchConditionFilter("Record GUID","Table No.",2,OutlookSynchFilter.Type::CONST,0,0,'');
          Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
          Modify;

          OptionCaption := OutlookSynchTypeConv.FieldOptionValueToText(ToDo.Type::Meeting,"Table No.",ToDo.FieldNo(Type));
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'',false,false,0,ToDo.FieldNo(Type),OptionCaption,1);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Start',false,false,0,9,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Start',false,false,0,28,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Subject',false,false,0,12,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'Location',false,false,0,35,'',0);
          InsertOutlookSynchField(Code,0,"Table No.","Outlook Item",'AllDayEvent',false,false,0,34,'',0);
        end;

        with OutlookSynchField do begin
          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Importance',false,false,0,11,
            '',0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceLow',0,0);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceNormal',1,1);
          InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olImportanceHigh',2,2);

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Duration',false,false,0,29,'',0);
          InsertOutlookSynchField(
            OutlookSynchEntity.Code,0,OutlookSynchEntity."Table No.",OutlookSynchEntity."Outlook Item",'Organizer',false,false,13,2,'',
            2);
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          SetRange("Element No.",0);
          if FindLast then begin
            InsertOSynchTableRelationFilter(
              "Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,OutlookSynchEntity."Table No.",3,'');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        with OutlookSynchEntityElement do begin
          InsertOutlookSynchEntityElement(OutlookSynchEntity.Code,5199,'Recipients');
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          if FindLast then begin
            CalcFields("Master Table No.");
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",1,'');
            InsertOSynchTableRelationFilter("Record GUID","Table No.",7,OutlookSynchFilter.Type::CONST,"Master Table No.",0,'1');

            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        InsertOutlookSyncDependencies;

        InsertOutlookSynchField(
          OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection",'',false,false,0,7,Format(true),1);
        InsertOutlookSynchField(
          OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection",'Type',false,false,0,3,'',0);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code",OutlookSynchField."Element No.",OutlookSynchField."Line No.",'0',2,0);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code",OutlookSynchField."Element No.",OutlookSynchField."Line No.",'1',0,1);
        InsertOOptionCorrelation(
          OutlookSynchField."Synch. Entity Code",OutlookSynchField."Element No.",OutlookSynchField."Line No.",'2',1,2);

        with OutlookSynchField do begin
          InsertOutlookSynchField(
            OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",
            OutlookSynchEntityElement."Table No.",OutlookSynchEntityElement."Outlook Collection",'Address',false,true,5050,102,'',2);
          UpdateOutlookSynchField(
            OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement,'0');

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
            OutlookSynchEntityElement."Outlook Collection",'Address',false,true,13,5052,'',2);
          UpdateOutlookSynchField(
            OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement,'1');

          InsertOutlookSynchField(
            OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
            OutlookSynchEntityElement."Outlook Collection",'MeetingResponseStatus',false,false,0,8,'',2);
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntityElement."Synch. Entity Code");
          SetRange("Element No.",OutlookSynchEntityElement."Element No.");
          if FindLast then begin
            InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olResponseNone',0,0);
            InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olResponseAccepted',1,3);
            InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olResponseDeclined',2,4);
            InsertOOptionCorrelation("Synch. Entity Code","Element No.","Line No.",'olResponseTentative',3,2);
          end;
        end;

        InsertOutlookSynchEntityElement(OutlookSynchEntity.Code,5199,'Links');
        with OutlookSynchEntityElement do begin
          Reset;
          SetRange("Synch. Entity Code",OutlookSynchEntity.Code);
          if FindLast then begin
            CalcFields("Master Table No.");
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",1,'');
            InsertOSynchTableRelationFilter("Record GUID","Table No.",7,OutlookSynchFilter.Type::CONST,"Master Table No.",0,'0');
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Modify;
          end;
        end;

        InsertOutlookSyncDependencies;

        InsertOutlookSynchField(
          OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection",'',false,false,0,7,Format(false),1);
        InsertOutlookSynchField(
          OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection",'Name',false,true,5050,2,'',2);
        UpdateOutlookSynchField(
          OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement,'0');

        InsertOutlookSynchField(
          OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement."Table No.",
          OutlookSynchEntityElement."Outlook Collection",'Name',false,true,13,2,'',2);
        UpdateOutlookSynchField(
          OutlookSynchEntity.Code,OutlookSynchEntityElement."Element No.",OutlookSynchEntityElement,'1');
    end;

    local procedure InsertOSynchEntity(SynchEntityCode: Text;DescriptionString: Text;TableID: Integer;OutlookItem: Text)
    begin
        with OutlookSynchEntity do begin
          Init;
          Code := CopyStr(SynchEntityCode,1,MaxStrLen(Code));
          Description := CopyStr(DescriptionString,1,MaxStrLen(Description));
          "Table No." := TableID;
          "Outlook Item" := CopyStr(OutlookItem,1,MaxStrLen("Outlook Item"));
          CalcFields("Table Caption");
          Insert(true);
        end;
    end;

    local procedure InsertOutlookSynchEntityElement(SynchEntityCode: Text;TableID: Integer;OutlookCollection: Text)
    begin
        with OutlookSynchEntityElement do begin
          Init;
          "Synch. Entity Code" := CopyStr(SynchEntityCode,1,MaxStrLen("Synch. Entity Code"));
          "Element No." := "Element No." + 10000;
          "Table No." := TableID;
          "Outlook Collection" := CopyStr(OutlookCollection,1,MaxStrLen("Outlook Collection"));
          "Record GUID" := CreateGuid;
          Insert;
        end;
    end;

    local procedure InsertOSynchFilter(RecordGUID: Guid;FlterType: Integer;TableID: Integer;FieldID: Integer;CaseType: Integer;MasterTableID: Integer;MasterFieldID: Integer;ValueString: Text)
    begin
        with OutlookSynchFilter do begin
          Init;
          "Record GUID" := RecordGUID;
          "Filter Type" := FlterType;
          "Line No." := "Line No." + 10000;
          "Table No." := TableID;
          Validate("Field No.",FieldID);
          Type := CaseType;
          "Master Table No." := MasterTableID;

          if MasterFieldID <> 0 then
            Validate("Master Table Field No.",MasterFieldID)
          else
            Validate(Value,CopyStr(ValueString,1,MaxStrLen(Value)));

          UpdateFilterExpression;

          Insert;
        end;
    end;


    procedure InsertOSynchTableRelationFilter(RecordGUID: Guid;TableID: Integer;FieldID: Integer;CaseType: Integer;MasterTableID: Integer;MasterFieldID: Integer;ValueString: Text)
    begin
        InsertOSynchFilter(
          RecordGUID,
          OutlookSynchFilter."filter type"::"Table Relation",
          TableID,
          FieldID,
          CaseType,
          MasterTableID,
          MasterFieldID,
          ValueString);
    end;

    local procedure InsertOSynchConditionFilter(RecordGUID: Guid;TableID: Integer;FieldID: Integer;CaseType: Integer;MasterTableID: Integer;MasterFieldID: Integer;ValueString: Text)
    begin
        InsertOSynchFilter(
          RecordGUID,
          OutlookSynchFilter."filter type"::Condition,
          TableID,
          FieldID,
          CaseType,
          MasterTableID,
          MasterFieldID,
          ValueString);
    end;

    local procedure InsertOutlookSyncDependencies()
    begin
        InsertOutlookSyncDependency(OutlookSynchDependency,Text110,'0');
        InsertOutlookSyncDependency(OutlookSynchDependency,Text111,'0');
        InsertOutlookSyncDependency(OutlookSynchDependency,Text112,'1');
    end;

    local procedure InsertOutlookSyncDependency(var OutlookSynchDependency: Record "Outlook Synch. Dependency";DependentEntityCode: Code[10];FilterValueString: Text)
    var
        OutlookSynchEntity1: Record "Outlook Synch. Entity";
    begin
        with OutlookSynchDependency do begin
          InsertODependency(
            OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",DependentEntityCode);
          Get(OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",DependentEntityCode);
          OutlookSynchEntity1.Get("Depend. Synch. Entity Code");
          InsertOSynchConditionFilter(
            "Record GUID",OutlookSynchEntityElement."Table No.",4,OutlookSynchFilter.Type::CONST,0,0,FilterValueString);
          InsertOSynchTableRelationFilter(
            "Record GUID",OutlookSynchEntity1."Table No.",1,OutlookSynchFilter.Type::Field,OutlookSynchEntityElement."Table No.",5,'');
          Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
          "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
          Modify;
        end;
    end;

    local procedure InsertOutlookSynchField(SynchEntityCode: Code[10];ElementNo: Integer;MasterTableID: Integer;OutlookObject: Text;OutlookProperty: Text;UserDefined: Boolean;SearchField: Boolean;TableID: Integer;FieldID: Integer;DefaulfValue: Text;ReadOnlyStatus: Integer)
    begin
        with OutlookSynchField do begin
          Init;
          "Synch. Entity Code" := SynchEntityCode;
          "Element No." := ElementNo;
          "Line No." := "Line No." + 10000;
          "Master Table No." := MasterTableID;
          "Table No." := TableID;
          "Outlook Object" := CopyStr(OutlookObject,1,MaxStrLen("Outlook Object"));
          "User-Defined" := UserDefined;
          "Search Field" := SearchField;
          "Field No." := FieldID;
          "Record GUID" := CreateGuid;
          Validate("Field Default Value",CopyStr(DefaulfValue,1,MaxStrLen("Field Default Value")));
          if TableID = 0 then
            Field.Get(MasterTableID,FieldID)
          else
            Field.Get(TableID,FieldID);
          "Outlook Property" := CopyStr(OutlookProperty,1,MaxStrLen("Outlook Property"));
          "Read-Only Status" := ReadOnlyStatus;
          Insert;
        end;
    end;

    local procedure InsertOOptionCorrelation(SynchEntityCode: Code[10];ElementNo: Integer;FieldLineNo: Integer;OutlookValue: Text;OptionID: Integer;EnumerationID: Integer)
    begin
        with OutlookSynchOptionCorrel do begin
          Init;
          "Element No." := ElementNo;
          "Field Line No." := FieldLineNo;
          "Line No." := "Line No." + 10000;
          Validate("Synch. Entity Code",SynchEntityCode);
          Validate("Outlook Value",CopyStr(OutlookValue,1,MaxStrLen("Outlook Value")));
          Validate("Option No.",OptionID);
          "Enumeration No." := EnumerationID;
          Insert;
        end;
    end;

    local procedure InsertODependency(SynchEntityCode: Code[10];ElementNo: Integer;DependentEntityCode: Code[10])
    var
        OutlookSynchEntity1: Record "Outlook Synch. Entity";
    begin
        with OutlookSynchDependency do begin
          if not OutlookSynchEntity1.Get(DependentEntityCode) then begin
            case DependentEntityCode of
              Text111:
                CreateDefaultContComp(DependentEntityCode);
              Text110:
                CreateDefaultContPers(DependentEntityCode);
              Text112:
                CreateDefaultContSp(DependentEntityCode);
            end;
            OutlookSynchEntity.Get(SynchEntityCode);
          end;
          Init;
          "Synch. Entity Code" := SynchEntityCode;
          "Element No." := ElementNo;
          Validate("Depend. Synch. Entity Code",DependentEntityCode);
          "Record GUID" := CreateGuid;
          Insert;
        end;
    end;

    local procedure InsertDefaultDependency(OutlookSynchEntity1: Record "Outlook Synch. Entity";DependEntityElemCode: Code[10];DependEntityElemOCollection: Text)
    begin
        OutlookSynchEntityElement.Reset;
        OutlookSynchEntityElement.SetRange("Synch. Entity Code",DependEntityElemCode);
        OutlookSynchEntityElement.SetRange("Outlook Collection",DependEntityElemOCollection);
        if OutlookSynchEntityElement.FindFirst then begin
          InsertODependency(
            OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",OutlookSynchEntity1.Code);
          OutlookSynchDependency.Get(
            OutlookSynchEntityElement."Synch. Entity Code",OutlookSynchEntityElement."Element No.",OutlookSynchEntity1.Code);
          if DependEntityElemCode <> Text131 then
            if OutlookSynchEntity1.Code = Text112 then
              InsertOSynchConditionFilter(
                OutlookSynchDependency."Record GUID",OutlookSynchEntityElement."Table No.",4,OutlookSynchFilter.Type::CONST,0,0,'1')
            else
              InsertOSynchConditionFilter(
                OutlookSynchDependency."Record GUID",OutlookSynchEntityElement."Table No.",4,OutlookSynchFilter.Type::CONST,0,0,'0');

          InsertOSynchTableRelationFilter(
            OutlookSynchDependency."Record GUID",OutlookSynchEntity1."Table No.",1,OutlookSynchFilter.Type::Field,
            OutlookSynchEntityElement."Table No.",5,'');

          if DependEntityElemCode <> Text131 then
            OutlookSynchDependency.Condition := OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID",0);
          OutlookSynchDependency."Table Relation" :=
            OutlookSynchSetupMgt.ComposeFilterExpression(OutlookSynchDependency."Record GUID",1);
          OutlookSynchDependency.Modify;
        end
    end;

    local procedure UpdateOutlookSynchField(EntityCode: Code[10];ElementNo: Integer;OutlookSynchEntityElement: Record "Outlook Synch. Entity Element";Value: Text)
    begin
        with OutlookSynchField do begin
          Reset;
          SetRange("Synch. Entity Code",EntityCode);
          SetRange("Element No.",ElementNo);
          if FindLast then begin
            OutlookSynchEntityElement.CalcFields("Master Table No.");
            InsertOSynchTableRelationFilter("Record GUID","Table No.",1,OutlookSynchFilter.Type::Field,"Master Table No.",5,'');
            InsertOSynchConditionFilter("Record GUID",OutlookSynchEntityElement."Table No.",4,OutlookSynchFilter.Type::CONST,0,0,Value);
            "Table Relation" := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",1);
            Condition := OutlookSynchSetupMgt.ComposeFilterExpression("Record GUID",0);
            Modify;
          end;
        end;
    end;
}

