#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5300 "Outlook Synch. Setup Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        OSynchDependency: Record "Outlook Synch. Dependency";
        OSynchEntity: Record "Outlook Synch. Entity";
        OSynchEntityElement: Record "Outlook Synch. Entity Element";
        OSynchFilter: Record "Outlook Synch. Filter";
        OSynchUserSetup: Record "Outlook Synch. User Setup";
        "Field": Record "Field";
        OSynchTypeConversion: Codeunit "Outlook Synch. Type Conv";
        OObjLibrary: dotnet OutlookObjectLibrary;
        Text001: label 'You should select a table and define a filter.';
        Text002: label 'You cannot setup a correlation with a property of an Outlook item for this field because it is not of the Option type.';
        Text003: label 'The filter cannot be processed because its length exceeds %1 symbols. Please redefine your criteria.';
        Text004: label 'The %1 entity cannot be found in the %2 for the selected collection.';
        Text005: label 'The %1 entity should not have the ''%2'' %3 in the %4.';
        Text006: label 'The %1 entities cannot be found in the %2 for the selected collection.';
        Text007: label 'You cannot setup a correlation with this field. This property of an Outlook item is not an enumeration value. Use the Assist button to see a list of valid enumeration values.';
        Text008: label 'The %1 field cannot be empty.';
        Text011: label 'The %1 table cannot be processed because its primary key contains more than 3 fields.';
        Text014: label 'Installation and configuration of the Microsoft Outlook Integration add-in is not complete. Be sure that Outlook Integration is installed and all required objects are allowed to run.';


    procedure ShowTablesList() TableID: Integer
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.Reset;

        if Page.RunModal(Page::"Outlook Synch. Table List",AllObjWithCaption) = Action::LookupOK then
          TableID := AllObjWithCaption."Object ID";
    end;


    procedure ShowTableFieldsList(TableID: Integer) FieldID: Integer
    begin
        Field.Reset;
        Field.SetRange(TableNo,TableID);

        if Page.RunModal(Page::"Outlook Synch. Table Fields",Field) = Action::LookupOK then
          FieldID := Field."No.";
    end;


    procedure ShowOItemsList() ItemName: Text[80]
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        Counter: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        for Counter := 1 to OObjLibrary.ItemsCount do begin
          TempOSynchLookupName.Init;
          TempOSynchLookupName.Name := OObjLibrary.GetItemName(Counter);
          TempOSynchLookupName."Entry No." := Counter;
          TempOSynchLookupName.Insert;
        end;

        ItemName := ShowLookupNames(TempOSynchLookupName);
    end;


    procedure ShowOItemProperties(ItemName: Text) PropertyName: Text[80]
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if not PropertyList.Item(Counter).ReturnsCollection then begin
            TempOSynchLookupName.Init;
            TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
            TempOSynchLookupName."Entry No." := Counter + 1;
            TempOSynchLookupName.Insert;
          end;

        PropertyName := ShowLookupNames(TempOSynchLookupName);
    end;


    procedure ShowOCollectionsList(ItemName: Text) CollectionName: Text[80]
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if PropertyList.Item(Counter).ReturnsCollection then begin
            TempOSynchLookupName.Init;
            TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
            TempOSynchLookupName."Entry No." := Counter + 1;
            TempOSynchLookupName.Insert;
          end;

        CollectionName := CopyStr(ShowLookupNames(TempOSynchLookupName),1,250);
    end;


    procedure ShowOCollectionProperties(ItemName: Text;CollectionName: Text) PropertyName: Text[80]
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        InnerPropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if PropertyList.Item(Counter).ReturnsCollection then
            if PropertyList.Item(Counter).Name = CollectionName then begin
              InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
              for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                TempOSynchLookupName.Init;
                TempOSynchLookupName.Name := InnerPropertyList.Item(Counter1).Name;
                TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
                TempOSynchLookupName.Insert;
              end;
            end;

        PropertyName := ShowLookupNames(TempOSynchLookupName);
    end;


    procedure ShowOEntityCollections(UserID: Code[50];SynchEntityCode: Code[10]) ElementNo: Integer
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        CollectionName: Text;
    begin
        with OSynchEntityElement do begin
          Reset;
          SetRange("Synch. Entity Code",SynchEntityCode);
          SetFilter("Outlook Collection",'<>%1','');

          if Find('-') then
            repeat
              TempOSynchLookupName.Init;
              TempOSynchLookupName.Name := "Outlook Collection";
              TempOSynchLookupName."Entry No." := "Element No.";
              TempOSynchLookupName.Insert;
            until Next = 0;

          CollectionName := ShowLookupNames(TempOSynchLookupName);
          if CollectionName <> '' then begin
            SetRange("Outlook Collection",CollectionName);
            if FindFirst then
              if CheckOCollectionAvailability(OSynchEntityElement,UserID) then
                ElementNo := "Element No.";
          end;
        end;
    end;


    procedure ShowOptionsLookup(OptionString: Text) OptionID: Integer
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        Separator: Text;
        TempString: Text;
        NamesCount: Integer;
        Counter: Integer;
    begin
        if OptionString = '' then
          exit;

        Separator := ',';
        NamesCount := 0;
        TempString := OptionString;

        while StrPos(TempString,Separator) <> 0 do begin
          NamesCount := NamesCount + 1;
          TempString := DelStr(TempString,StrPos(TempString,Separator),1);
        end;

        for Counter := 1 to NamesCount + 1 do begin
          TempOSynchLookupName.Init;
          TempOSynchLookupName.Name := SelectStr(Counter,OptionString);
          TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
          TempOSynchLookupName.Insert;
        end;

        TempString := ShowLookupNames(TempOSynchLookupName);
        TempOSynchLookupName.SetCurrentkey(Name);
        TempOSynchLookupName.SetRange(Name,TempString);
        if TempOSynchLookupName.FindFirst then
          OptionID := TempOSynchLookupName."Entry No.";
    end;


    procedure ShowEnumerationsLookup(ItemName: Text;CollectionName: Text;PropertyName: Text;var EnumerationNo: Integer) SelectedName: Text[80]
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        InnerPropertyList: dotnet OutlookPropertyList;
        PropertyItem: dotnet OutlookPropertyInfo;
        InnerPropertyItem: dotnet OutlookPropertyInfo;
        Counter: Integer;
        Counter1: Integer;
        Counter2: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        if CollectionName = '' then begin
          for Counter := 0 to PropertyList.Count - 1 do begin
            PropertyItem := PropertyList.Item(Counter);
            if not PropertyItem.ReturnsCollection and (PropertyItem.Name = PropertyName) then
              if PropertyItem.ReturnsEnumeration then begin
                for Counter1 := 0 to PropertyItem.EnumerationValues.Count - 1 do begin
                  TempOSynchLookupName.Init;
                  TempOSynchLookupName.Name := PropertyItem.EnumerationValues.Item(Counter1).Key;
                  TempOSynchLookupName."Entry No." := PropertyItem.EnumerationValues.Item(Counter1).Value;
                  TempOSynchLookupName.Insert;
                end;

                SelectedName := ShowLookupNames(TempOSynchLookupName);
                EnumerationNo := TempOSynchLookupName."Entry No.";
                exit;
              end;
          end;
        end else
          for Counter := 0 to PropertyList.Count - 1 do
            if PropertyList.Item(Counter).ReturnsCollection and (PropertyList.Item(Counter).Name = CollectionName) then begin
              InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
              for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                InnerPropertyItem := InnerPropertyList.Item(Counter1);
                if InnerPropertyItem.Name = PropertyName then
                  if InnerPropertyItem.ReturnsEnumeration then begin
                    for Counter2 := 0 to InnerPropertyItem.EnumerationValues.Count - 1 do begin
                      TempOSynchLookupName.Init;
                      TempOSynchLookupName.Name := InnerPropertyItem.EnumerationValues.Item(Counter2).Key;
                      TempOSynchLookupName."Entry No." := InnerPropertyItem.EnumerationValues.Item(Counter2).Value;
                      TempOSynchLookupName.Insert;
                    end;

                    SelectedName := ShowLookupNames(TempOSynchLookupName);
                    EnumerationNo := TempOSynchLookupName."Entry No.";
                    exit;
                  end;
              end;
            end;
    end;

    local procedure ShowLookupNames(var OSynchLookupNameRec: Record "Outlook Synch. Lookup Name") SelectedName: Text[80]
    begin
        OSynchLookupNameRec.FindFirst;

        if Page.RunModal(Page::"Outlook Synch. Lookup Names",OSynchLookupNameRec) = Action::LookupOK then
          SelectedName := OSynchLookupNameRec.Name;
    end;


    procedure ShowOSynchFiltersForm(RecGUID: Guid;TableNo: Integer;MasterTableNo: Integer) ComposedFilter: Text
    var
        TempOSynchFilter: Record "Outlook Synch. Filter" temporary;
        OSynchFiltersForm: Page "Outlook Synch. Filters";
        LookUpOk: Boolean;
        ShowWarning: Boolean;
    begin
        if TableNo = 0 then
          Error(Text001);

        OSynchFilter.Reset;
        OSynchFilter.SetRange("Record GUID",RecGUID);
        if MasterTableNo = 0 then
          OSynchFilter.SetRange("Filter Type",OSynchFilter."filter type"::Condition)
        else
          OSynchFilter.SetRange("Filter Type",OSynchFilter."filter type"::"Table Relation");

        Clear(OSynchFiltersForm);
        OSynchFiltersForm.SetTables(TableNo,MasterTableNo);
        OSynchFiltersForm.SetTableview(OSynchFilter);
        OSynchFiltersForm.SetRecord(OSynchFilter);

        TempOSynchFilter.Reset;
        TempOSynchFilter.DeleteAll;
        TempOSynchFilter.CopyFilters(OSynchFilter);
        if OSynchFilter.Find('-') then
          repeat
            TempOSynchFilter.TransferFields(OSynchFilter);
            TempOSynchFilter.Insert;
          until OSynchFilter.Next = 0;

        LookUpOk := OSynchFiltersForm.RunModal = Action::OK;
        ShowWarning := LookUpOk and ((OSynchFilter.Count = 0) and (MasterTableNo <> 0));

        if ShowWarning or (not LookUpOk) then begin
          if OSynchFilter.Count > 0 then
            OSynchFilter.DeleteAll;
          if TempOSynchFilter.Find('-') then
            repeat
              OSynchFilter.TransferFields(TempOSynchFilter);
              OSynchFilter.Insert;
            until TempOSynchFilter.Next = 0;
          Commit;
        end else
          OSynchFiltersForm.GetRecord(OSynchFilter);

        ComposedFilter := ComposeFilterExpression(RecGUID,OSynchFilter."Filter Type");
        Clear(OSynchFilter);
        if ShowWarning then
          Error(Text008,OSynchEntityElement.FieldCaption("Table Relation"));
    end;


    procedure ShowOOptionCorrelForm(OSynchFieldIn: Record "Outlook Synch. Field")
    var
        OSynchOptionCorrel: Record "Outlook Synch. Option Correl.";
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        if OSynchFieldIn."Table No." = 0 then
          Field.Get(OSynchFieldIn."Master Table No.",OSynchFieldIn."Field No.")
        else
          Field.Get(OSynchFieldIn."Table No.",OSynchFieldIn."Field No.");

        if Field.Type <> Field.Type::Option then
          Error(Text002);

        OSynchOptionCorrel.Reset;
        OSynchOptionCorrel.SetRange("Synch. Entity Code",OSynchFieldIn."Synch. Entity Code");
        OSynchOptionCorrel.SetRange("Element No.",OSynchFieldIn."Element No.");
        OSynchOptionCorrel.SetRange("Field Line No.",OSynchFieldIn."Line No.");
        Page.RunModal(Page::"Outlook Synch. Option Correl.",OSynchOptionCorrel);
    end;


    procedure CheckOCollectionAvailability(OSynchEntityElementIn: Record "Outlook Synch. Entity Element";UserID: Code[50]): Boolean
    var
        OSynchUserSetup1: Record "Outlook Synch. User Setup";
        EntityList: Text;
        CountAvailable: Integer;
    begin
        OSynchDependency.Reset;
        OSynchDependency.SetRange("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
        OSynchDependency.SetRange("Element No.",OSynchEntityElementIn."Element No.");
        if OSynchDependency.Find('-') then begin
          repeat
            if OSynchUserSetup.Get(UserID,OSynchDependency."Depend. Synch. Entity Code") then begin
              OSynchUserSetup1.Get(UserID,OSynchEntityElementIn."Synch. Entity Code");
              if (OSynchUserSetup."Synch. Direction" = OSynchUserSetup1."Synch. Direction") or
                 (OSynchUserSetup."Synch. Direction" = OSynchUserSetup."synch. direction"::Bidirectional)
              then
                CountAvailable := CountAvailable + 1
              else
                Error(
                  Text005,
                  OSynchUserSetup."Synch. Entity Code",
                  OSynchUserSetup."Synch. Direction",
                  OSynchUserSetup.FieldCaption("Synch. Direction"),
                  OSynchUserSetup.TableCaption);
            end else begin
              if EntityList = '' then
                EntityList := OSynchDependency."Depend. Synch. Entity Code"
              else
                EntityList := EntityList + ', ' + OSynchDependency."Depend. Synch. Entity Code";
            end;
          until OSynchDependency.Next = 0;

          if CountAvailable = OSynchDependency.Count then
            exit(true);

          if StrPos(EntityList,',') = 0 then
            Error(Text004,EntityList,OSynchUserSetup.TableCaption);
          Error(Text006,EntityList,OSynchUserSetup.TableCaption);
        end;

        exit(true);
    end;


    procedure ValidateEnumerationValue(var InputValue: Text;var EnumerationNo: Integer;ItemName: Text;CollectionName: Text;PropertyName: Text)
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        InnerPropertyList: dotnet OutlookPropertyList;
        PropertyItem: dotnet OutlookPropertyInfo;
        InnerPropertyItem: dotnet OutlookPropertyInfo;
        Counter: Integer;
        Counter1: Integer;
        Counter2: Integer;
        IntVar: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        TempOSynchLookupName.Reset;
        TempOSynchLookupName.DeleteAll;

        PropertyList := OObjLibrary.GetItem(ItemName);

        if CollectionName = '' then begin
          for Counter := 0 to PropertyList.Count - 1 do begin
            PropertyItem := PropertyList.Item(Counter);

            if not PropertyItem.ReturnsCollection and (PropertyItem.Name = PropertyName) then
              if PropertyItem.ReturnsEnumeration then begin
                for Counter1 := 0 to PropertyItem.EnumerationValues.Count - 1 do begin
                  TempOSynchLookupName.Init;
                  TempOSynchLookupName.Name := PropertyItem.EnumerationValues.Item(Counter1).Key;
                  TempOSynchLookupName."Entry No." := PropertyItem.EnumerationValues.Item(Counter1).Value;
                  TempOSynchLookupName.Insert;
                end;

                if Evaluate(IntVar,InputValue) then begin
                  TempOSynchLookupName.Reset;
                  TempOSynchLookupName.SetRange("Entry No.",IntVar);
                  if TempOSynchLookupName.FindFirst then begin
                    InputValue := TempOSynchLookupName.Name;
                    EnumerationNo := TempOSynchLookupName."Entry No.";
                    exit;
                  end;
                end;

                TempOSynchLookupName.Reset;
                TempOSynchLookupName.SetFilter(Name,'@' + InputValue + '*');
                if not TempOSynchLookupName.FindFirst then
                  Error(Text007);

                InputValue := TempOSynchLookupName.Name;
                EnumerationNo := TempOSynchLookupName."Entry No.";
                exit;
              end;
          end;
        end else
          for Counter := 0 to PropertyList.Count - 1 do begin
            PropertyItem := PropertyList.Item(Counter);
            if PropertyItem.ReturnsCollection and (PropertyItem.Name = CollectionName) then begin
              InnerPropertyList := PropertyItem.PropertyInfoList;
              for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                InnerPropertyItem := InnerPropertyList.Item(Counter1);
                if InnerPropertyItem.Name = PropertyName then
                  if InnerPropertyItem.ReturnsEnumeration then begin
                    for Counter2 := 0 to InnerPropertyItem.EnumerationValues.Count - 1 do begin
                      TempOSynchLookupName.Init;
                      TempOSynchLookupName.Name := InnerPropertyItem.EnumerationValues.Item(Counter2).Key;
                      TempOSynchLookupName."Entry No." := InnerPropertyItem.EnumerationValues.Item(Counter2).Value;
                      TempOSynchLookupName.Insert;
                    end;

                    if Evaluate(IntVar,InputValue) then begin
                      TempOSynchLookupName.Reset;
                      TempOSynchLookupName.SetRange("Entry No.",IntVar);
                      if TempOSynchLookupName.FindFirst then begin
                        InputValue := TempOSynchLookupName.Name;
                        EnumerationNo := TempOSynchLookupName."Entry No.";
                        exit;
                      end;
                    end;

                    TempOSynchLookupName.Reset;
                    TempOSynchLookupName.SetFilter(Name,'@' + InputValue + '*');
                    if not TempOSynchLookupName.FindFirst then
                      Error(Text007);

                    InputValue := TempOSynchLookupName.Name;
                    EnumerationNo := TempOSynchLookupName."Entry No.";
                    exit;
                  end;
              end;
            end;
          end;
    end;


    procedure ValidateFieldName(var NameString: Text;TableID: Integer): Boolean
    begin
        Field.Reset;
        Field.SetRange(TableNo,TableID);
        Field.SetFilter("Field Caption",'@' + OSynchTypeConversion.ReplaceFilterChars(NameString) + '*');
        if Field.FindFirst then begin
          NameString := Field."Field Caption";
          exit(true);
        end;
    end;


    procedure ValidateOutlookItemName(var InputString: Text): Boolean
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        Counter: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        for Counter := 1 to OObjLibrary.ItemsCount do begin
          TempOSynchLookupName.Init;
          TempOSynchLookupName.Name := OObjLibrary.GetItemName(Counter);
          TempOSynchLookupName."Entry No." := Counter;
          TempOSynchLookupName.Insert;
        end;

        TempOSynchLookupName.SetCurrentkey(Name);
        TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        if TempOSynchLookupName.FindFirst then begin
          InputString := TempOSynchLookupName.Name;
          exit(true);
        end;
    end;


    procedure ValidateOutlookCollectionName(var InputString: Text;ItemName: Text): Boolean
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if PropertyList.Item(Counter).ReturnsCollection then begin
            TempOSynchLookupName.Init;
            TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
            TempOSynchLookupName."Entry No." := Counter + 1;
            TempOSynchLookupName.Insert;
          end;

        TempOSynchLookupName.SetCurrentkey(Name);
        TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        if TempOSynchLookupName.FindFirst then begin
          InputString := TempOSynchLookupName.Name;
          exit(true);
        end;
    end;


    procedure ValidateOItemPropertyName(var InputString: Text;ItemName: Text;var IsReadOnly: Boolean;FullTextSearch: Boolean): Boolean
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        PropertyItem: dotnet OutlookPropertyInfo;
        Counter: Integer;
    begin
        if IsNull(OObjLibrary) then
          if not CanLoadType(OObjLibrary) then
            Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if not PropertyList.Item(Counter).ReturnsCollection then begin
            TempOSynchLookupName.Init;
            TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
            TempOSynchLookupName."Entry No." := Counter + 1;
            TempOSynchLookupName.Insert;
          end;

        TempOSynchLookupName.SetCurrentkey(Name);

        if FullTextSearch then
          TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString))
        else
          TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        if TempOSynchLookupName.FindFirst then begin
          InputString := TempOSynchLookupName.Name;
          PropertyItem := PropertyList.Item(TempOSynchLookupName."Entry No." - 1);
          IsReadOnly := PropertyItem.IsReadOnly;
          exit(true);
        end;
    end;


    procedure ValidateOCollectPropertyName(var InputString: Text;ItemName: Text;CollectionName: Text;var IsReadOnly: Boolean;FullTextSearch: Boolean): Boolean
    var
        TempOSynchLookupName: Record "Outlook Synch. Lookup Name" temporary;
        PropertyList: dotnet OutlookPropertyList;
        InnerPropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    begin
        Clear(OObjLibrary);
        if not CanLoadType(OObjLibrary) then
          Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        for Counter := 0 to PropertyList.Count - 1 do
          if PropertyList.Item(Counter).ReturnsCollection then
            if PropertyList.Item(Counter).Name = CollectionName then begin
              InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
              for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                TempOSynchLookupName.Init;
                TempOSynchLookupName.Name := InnerPropertyList.Item(Counter1).Name;
                TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
                TempOSynchLookupName.Insert;
              end;
            end;

        TempOSynchLookupName.SetCurrentkey(Name);

        if FullTextSearch then
          TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString))
        else
          TempOSynchLookupName.SetFilter(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        if TempOSynchLookupName.FindFirst then
          for Counter := 0 to PropertyList.Count - 1 do
            if PropertyList.Item(Counter).ReturnsCollection then
              if PropertyList.Item(Counter).Name = CollectionName then begin
                InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
                for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                  InputString := InnerPropertyList.Item(Counter1).Name;
                  if TempOSynchLookupName.Name = InnerPropertyList.Item(Counter1).Name then begin
                    InputString := InnerPropertyList.Item(Counter1).Name;
                    IsReadOnly := InnerPropertyList.Item(Counter1).IsReadOnly;
                    exit(true);
                  end;
                end;
              end;
    end;


    procedure ComposeFilterExpression(RecGUID: Guid;FilterType: Integer) OutFilterString: Text[250]
    var
        Delimiter: Text;
        TempString: Text;
        FilterLength: Integer;
    begin
        OSynchFilter.Reset;
        OSynchFilter.SetRange("Record GUID",RecGUID);
        OSynchFilter.SetRange("Filter Type",FilterType);

        OutFilterString := '';
        if OSynchFilter.Find('-') then begin
          Delimiter := '';
          repeat
            FilterLength := StrLen(TempString) +
              StrLen(OSynchFilter.GetFieldCaption) + StrLen(Format(OSynchFilter.Type)) + StrLen(OSynchFilter.Value);
            if FilterLength + StrLen(TempString) > MaxStrLen(TempString) - 5 then
              Error(Text003,Format(MaxStrLen(TempString)));
            TempString :=
              StrSubstNo('%1%2%3=%4(%5)',
                TempString,Delimiter,OSynchFilter.GetFieldCaption,Format(OSynchFilter.Type),OSynchFilter.Value);
            Delimiter := ',';
          until OSynchFilter.Next = 0;

          TempString := StrSubstNo('WHERE(%1)',TempString);
          if StrLen(TempString) > 250 then
            OutFilterString := StrSubstNo('%1...',CopyStr(TempString,1,247))
          else
            OutFilterString := TempString;
        end;
    end;


    procedure ComposeTableFilter(var OSynchFilterIn: Record "Outlook Synch. Filter";SynchRecRef: RecordRef) OutFilterString: Text[250]
    var
        MasterFieldRef: FieldRef;
        Delimiter: Text;
        TempStr: Text;
        FilterString: Text;
        FilterLength: Integer;
    begin
        OutFilterString := '';
        FilterString := '';
        if not OSynchFilterIn.Find('-') then
          exit;

        Delimiter := '';
        repeat
          case OSynchFilterIn.Type of
            OSynchFilterIn.Type::CONST:
              begin
                TempStr := OSynchFilterIn.FilterExpression;
                FilterString := StrSubstNo('%1%2%3',FilterString,Delimiter,TempStr)
              end;
            OSynchFilterIn.Type::FILTER:
              begin
                TempStr := OSynchFilterIn.FilterExpression;
                FilterString := StrSubstNo('%1%2%3',FilterString,Delimiter,TempStr)
              end;
            OSynchFilterIn.Type::Field:
              begin
                MasterFieldRef := SynchRecRef.Field(OSynchFilterIn."Master Table Field No.");
                TempStr := StrSubstNo('FILTER(%1)',OSynchTypeConversion.ReplaceFilterChars(Format(MasterFieldRef.Value)));
                FilterLength := StrLen(FilterString) + StrLen(Delimiter) + StrLen(OSynchFilterIn.GetFieldCaption) + StrLen(TempStr);
                if FilterLength > 1000 then
                  Error(Text003,Format(1000));
                FilterString := StrSubstNo('%1%2%3=%4',FilterString,Delimiter,OSynchFilterIn.GetFieldCaption,TempStr);
              end;
          end;
          Delimiter := ',';
        until OSynchFilterIn.Next = 0;

        OutFilterString := CopyStr(StrSubstNo('WHERE(%1)',FilterString),1,250);
    end;


    procedure ComposeTableView(var OSynchFilterCondition: Record "Outlook Synch. Filter";var OSynchFilterRelation: Record "Outlook Synch. Filter";RelatedRecRef: RecordRef) FilteringExpression: Text
    var
        TempOSynchFilter: Record "Outlook Synch. Filter" temporary;
        NullRecRef: RecordRef;
    begin
        CopyFilterRecords(OSynchFilterCondition,TempOSynchFilter);
        ComposeFilterRecords(OSynchFilterRelation,TempOSynchFilter,RelatedRecRef,TempOSynchFilter.Type::FILTER);

        FilteringExpression := ComposeTableFilter(TempOSynchFilter,NullRecRef);
    end;


    procedure CopyFilterRecords(var FromOSynchFilter: Record "Outlook Synch. Filter";var ToOSynchFilter: Record "Outlook Synch. Filter")
    begin
        if FromOSynchFilter.Find('-') then
          repeat
            ToOSynchFilter.Init;
            ToOSynchFilter := FromOSynchFilter;
            if ToOSynchFilter.Insert then;
          until FromOSynchFilter.Next = 0;
    end;


    procedure ComposeFilterRecords(var FromOSynchFilter: Record "Outlook Synch. Filter";var ToOSynchFilter: Record "Outlook Synch. Filter";RecRef: RecordRef;FilteringType: Integer)
    var
        FieldRef: FieldRef;
    begin
        if FromOSynchFilter.Find('-') then
          repeat
            FieldRef := RecRef.Field(FromOSynchFilter."Field No.");
            CreateFilterCondition(
              ToOSynchFilter,
              FromOSynchFilter."Master Table No.",
              FromOSynchFilter."Master Table Field No.",
              FilteringType,
              Format(FieldRef));
          until FromOSynchFilter.Next = 0;
    end;


    procedure CreateFilterCondition(var OSynchFilterIn: Record "Outlook Synch. Filter";TableID: Integer;FieldID: Integer;FilterType: Integer;FilterValue: Text)
    var
        FilterValueLen: Integer;
    begin
        if FilterType = OSynchFilterIn.Type::Field then
          exit;

        Field.Get(TableID,FieldID);
        if StrLen(FilterValue) > Field.Len then
          FilterValue := PadStr(FilterValue,Field.Len);

        OSynchFilterIn.Init;
        OSynchFilterIn."Record GUID" := CreateGuid;
        OSynchFilterIn."Filter Type" := OSynchFilterIn."filter type"::Condition;
        OSynchFilterIn."Line No." := OSynchFilterIn."Line No." + 10000;
        OSynchFilterIn."Table No." := TableID;
        OSynchFilterIn.Validate("Field No.",FieldID);
        OSynchFilterIn.Type := FilterType;

        if FilterType = OSynchFilterIn.Type::CONST then begin
          Field.Get(OSynchFilterIn."Table No.",OSynchFilterIn."Field No.");
          OSynchFilterIn.Value := OSynchTypeConversion.HandleFilterChars(FilterValue,Field.Len);
        end else begin
          FilterValueLen := Field.Len;
          Field.Get(Database::"Outlook Synch. Filter",OSynchFilterIn.FieldNo(Value));
          if FilterValueLen = Field.Len then begin
            FilterValue := PadStr(FilterValue,Field.Len - 2);
            OSynchFilterIn.Value := '@' + OSynchTypeConversion.ReplaceFilterChars(FilterValue) + '*';
          end else
            OSynchFilterIn.Value := '@' + OSynchTypeConversion.ReplaceFilterChars(FilterValue);
        end;

        if OSynchFilterIn.Insert(true) then;
    end;


    procedure CheckPKFieldsQuantity(TableID: Integer): Boolean
    var
        TempRecRef: RecordRef;
        KeyRef: KeyRef;
    begin
        if TableID = 0 then
          exit(true);

        TempRecRef.Open(TableID,true);
        KeyRef := TempRecRef.KeyIndex(1);
        if KeyRef.FieldCount <= 3 then
          exit(true);

        Error(Text011,TempRecRef.Caption);
    end;


    procedure CheckOEnumeration(OSynchFieldIn: Record "Outlook Synch. Field") IsEnumeration: Boolean
    var
        PropertyList: dotnet OutlookPropertyList;
        InnerPropertyList: dotnet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    begin
        if IsNull(OObjLibrary) then
          if not CanLoadType(OObjLibrary) then
            Error(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        if OSynchFieldIn."Element No." = 0 then begin
          PropertyList := OObjLibrary.GetItem(OSynchFieldIn."Outlook Object");
          for Counter := 0 to PropertyList.Count - 1 do begin
            if not PropertyList.Item(Counter).ReturnsCollection and
               (PropertyList.Item(Counter).Name = OSynchFieldIn."Outlook Property")
            then
              if PropertyList.Item(Counter).ReturnsEnumeration then
                IsEnumeration := true;
          end;
        end else begin
          OSynchEntity.Get(OSynchFieldIn."Synch. Entity Code");
          PropertyList := OObjLibrary.GetItem(OSynchEntity."Outlook Item");
          for Counter := 0 to PropertyList.Count - 1 do
            if PropertyList.Item(Counter).ReturnsCollection and
               (PropertyList.Item(Counter).Name = OSynchFieldIn."Outlook Object")
            then begin
              InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
              for Counter1 := 0 to InnerPropertyList.Count - 1 do begin
                if InnerPropertyList.Item(Counter1).Name = OSynchFieldIn."Outlook Property" then
                  if InnerPropertyList.Item(Counter1).ReturnsEnumeration then
                    IsEnumeration := true;
              end;
            end;
        end;
    end;
}

