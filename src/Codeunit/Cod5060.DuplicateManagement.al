#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5060 DuplicateManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Duplicate Contacts were found. Would you like to process these?';
        RMSetup: Record "Marketing Setup";


    procedure MakeContIndex(Cont: Record Contact)
    var
        DuplSearchStringSetup: Record "Duplicate Search String Setup";
    begin
        RMSetup.Get;

        RemoveContIndex(Cont,true);

        if DuplSearchStringSetup.Find('-') then
          repeat
            InsDuplContIndex(Cont,DuplSearchStringSetup);
          until DuplSearchStringSetup.Next = 0;

        InsDuplCont(Cont,RMSetup."Search Hit %");
    end;


    procedure RemoveContIndex(Cont: Record Contact;KeepAccepted: Boolean)
    var
        DuplContSearchString: Record "Cont. Duplicate Search String";
        DuplCont: Record "Contact Duplicate";
    begin
        DuplContSearchString.SetRange("Contact Company No.",Cont."No.");
        if DuplContSearchString.FindFirst then
          DuplContSearchString.DeleteAll;

        DuplCont.SetRange("Contact No.",Cont."No.");
        if KeepAccepted then
          DuplCont.SetRange("Separate Contacts",false);
        DuplCont.DeleteAll(true);
    end;


    procedure DuplicateExist(Cont: Record Contact): Boolean
    var
        DuplCont: Record "Contact Duplicate";
    begin
        RMSetup.Get;
        if not RMSetup."Autosearch for Duplicates" then
          exit(false);
        DuplCont.SetRange("Contact No.",Cont."No.");
        DuplCont.SetRange("Separate Contacts",false);
        exit(DuplCont.Find('=<>'));
    end;


    procedure LaunchDuplicateForm(Cont: Record Contact)
    var
        DuplCont: Record "Contact Duplicate";
    begin
        if Confirm(Text000,true) then begin
          DuplCont.SetRange("Contact No.",Cont."No.");
          Page.RunModal(Page::"Contact Duplicates",DuplCont);
        end
    end;

    local procedure InsDuplContIndex(Cont: Record Contact;DuplSearchStringSetup: Record "Duplicate Search String Setup")
    var
        DuplContSearchString: Record "Cont. Duplicate Search String";
    begin
        DuplContSearchString.Init;
        DuplContSearchString."Contact Company No." := Cont."No.";
        DuplContSearchString.Field := DuplSearchStringSetup.Field;
        DuplContSearchString."Part of Field" := DuplSearchStringSetup."Part of Field";
        case DuplSearchStringSetup.Field of
          DuplSearchStringSetup.Field::Name:
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont.Name,DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::"Name 2":
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont."Name 2",DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::Address:
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont.Address,DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::"Address 2":
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont."Address 2",DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::"Post Code":
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont."Post Code",DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::City:
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont.City,DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::"Phone No.":
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont."Phone No.",DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.Length);
          DuplSearchStringSetup.Field::"VAT Registration No.":
            DuplContSearchString."Search String" :=
              ComposeIndexString(Cont."VAT Registration No.",DuplSearchStringSetup."Part of Field",DuplSearchStringSetup.
                Length);
        end;

        if DuplContSearchString."Search String" <> '' then
          DuplContSearchString.Insert;
    end;

    local procedure InsDuplCont(Cont: Record Contact;HitRatio: Integer)
    var
        DuplContSearchString: Record "Cont. Duplicate Search String";
        DuplContSearchString2: Record "Cont. Duplicate Search String";
        DuplCont: Record "Contact Duplicate" temporary;
        DuplCont2: Record "Contact Duplicate";
        DuplSearchStringSetup: Record "Duplicate Search String Setup";
    begin
        DuplContSearchString.SetRange("Contact Company No.",Cont."No.");
        if DuplContSearchString.Find('-') then
          repeat
            DuplContSearchString2.SetCurrentkey(Field,"Part of Field","Search String");
            DuplContSearchString2.SetRange(Field,DuplContSearchString.Field);
            DuplContSearchString2.SetRange("Part of Field",DuplContSearchString."Part of Field");
            DuplContSearchString2.SetRange("Search String",DuplContSearchString."Search String");
            DuplContSearchString2.SetFilter("Contact Company No.",'<>%1',DuplContSearchString."Contact Company No.");
            if DuplContSearchString2.Find('-') then
              repeat
                if DuplCont.Get(DuplContSearchString."Contact Company No.",DuplContSearchString2."Contact Company No.") then begin
                  if not DuplCont."Separate Contacts" then begin
                    DuplCont."No. of Matching Strings" := DuplCont."No. of Matching Strings" + 1;
                    DuplCont.Modify;
                  end;
                end else begin
                  DuplCont."Contact No." := DuplContSearchString."Contact Company No.";
                  DuplCont."Duplicate Contact No." := DuplContSearchString2."Contact Company No.";
                  DuplCont."Separate Contacts" := false;
                  DuplCont."No. of Matching Strings" := 1;
                  DuplCont.Insert;
                end;
              until DuplContSearchString2.Next = 0;
          until DuplContSearchString.Next = 0;

        DuplCont.SetFilter("No. of Matching Strings",'>=%1',ROUND(DuplSearchStringSetup.Count * HitRatio / 100,1,'>'));
        if DuplCont.Find('-') then begin
          repeat
            DuplCont2 := DuplCont;
            if not DuplCont2.Get(DuplCont."Contact No.",DuplCont."Duplicate Contact No.") then
              DuplCont2.Insert(true);
          until DuplCont.Next = 0;
          DuplCont.DeleteAll;
        end;
    end;

    local procedure ComposeIndexString(InString: Text[260];"Part": Option First,Last;ChrToCopy: Integer): Text[10]
    begin
        InString := DelChr(InString,'=',' +"&/,.;:-_(){}#!£$\');

        if StrLen(InString) < ChrToCopy then
          ChrToCopy := StrLen(InString);

        if ChrToCopy > 0 then
          if Part = Part::First then
            InString := CopyStr(InString,1,ChrToCopy)
          else
            InString := CopyStr(InString,StrLen(InString) - ChrToCopy + 1,ChrToCopy);

        exit(UpperCase(InString));
    end;
}

