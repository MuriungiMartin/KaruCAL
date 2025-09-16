#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 408 DimensionManagement
{
    Permissions = TableData "Gen. Journal Template"=imd,
                  TableData "Gen. Journal Batch"=imd,
                  TableData "Dimension Set ID Filter Line"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Dimensions %1 and %2 can''t be used concurrently.';
        Text001: label 'Dimension combinations %1 - %2 and %3 - %4 can''t be used concurrently.';
        Text002: label 'This Shortcut Dimension is not defined in the %1.';
        Text003: label '%1 is not an available %2 for that dimension.';
        Text004: label 'Select a %1 for the %2 %3.';
        Text005: label 'Select a %1 for the %2 %3 for %4 %5.';
        Text006: label 'Select %1 %2 for the %3 %4.';
        Text007: label 'Select %1 %2 for the %3 %4 for %5 %6.';
        Text008: label '%1 %2 must be blank.';
        Text009: label '%1 %2 must be blank for %3 %4.';
        Text010: label '%1 %2 must not be mentioned.';
        Text011: label '%1 %2 must not be mentioned for %3 %4.';
        Text012: label 'A %1 used in %2 has not been used in %3.';
        Text013: label '%1 for %2 %3 is not the same in %4 and %5.';
        Text014: label '%1 %2 is blocked.';
        Text015: label '%1 %2 can''t be found.';
        Text016: label '%1 %2 - %3 is blocked.';
        Text017: label '%1 for %2 %3 - %4 must not be %5.';
        Text018: label '%1 for %2 is missing.';
        Text019: label 'You have changed a dimension.\\Do you want to update the lines?';
        TempDimBuf1: Record "Dimension Buffer" temporary;
        TempDimBuf2: Record "Dimension Buffer" temporary;
        ObjTransl: Record "Object Translation";
        DimValComb: Record "Dimension Value Combination";
        JobTaskDimTemp: Record "Job Task Dimension" temporary;
        DefaultDim: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        TempDimCombInitialized: Boolean;
        TempDimCombEmpty: Boolean;
        DimCombErr: Text[250];
        DimValuePostingErr: Text[250];
        DimErr: Text[250];
        DocDimConsistencyErr: Text[250];
        HasGotGLSetup: Boolean;
        GLSetupShortcutDimCode: array [8] of Code[20];
        DimSetFilterCtr: Integer;
        LastDimSetIDInFilter: Integer;


    procedure GetDimensionSetID(var DimSetEntry2: Record "Dimension Set Entry"): Integer
    begin
        exit(DimSetEntry.GetDimensionSetID(DimSetEntry2));
    end;


    procedure GetDimensionSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary;DimSetID: Integer)
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        TempDimSetEntry.DeleteAll;
        with DimSetEntry2 do begin
          SetRange("Dimension Set ID",DimSetID);
          if FindSet then
            repeat
              TempDimSetEntry := DimSetEntry2;
              TempDimSetEntry.Insert;
            until Next = 0;
        end;
    end;


    procedure ShowDimensionSet(DimSetID: Integer;NewCaption: Text[250])
    var
        DimSetEntries: Page "Dimension Set Entries";
    begin
        DimSetEntry.Reset;
        DimSetEntry.FilterGroup(2);
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimSetEntry.FilterGroup(0);
        DimSetEntries.SetTableview(DimSetEntry);
        DimSetEntries.SetFormCaption(NewCaption);
        DimSetEntry.Reset;
        DimSetEntries.RunModal;
    end;


    procedure EditDimensionSet(DimSetID: Integer;NewCaption: Text[250]): Integer
    var
        EditDimSetEntries: Page "Edit Dimension Set Entries";
        NewDimSetID: Integer;
    begin
        NewDimSetID := DimSetID;
        DimSetEntry.Reset;
        DimSetEntry.FilterGroup(2);
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimSetEntry.FilterGroup(0);
        EditDimSetEntries.SetTableview(DimSetEntry);
        EditDimSetEntries.SetFormCaption(NewCaption);
        EditDimSetEntries.RunModal;
        NewDimSetID := EditDimSetEntries.GetDimensionID;
        DimSetEntry.Reset;
        exit(NewDimSetID);
    end;


    procedure EditDimensionSet2(DimSetID: Integer;NewCaption: Text[250];var GlobalDimVal1: Code[20];var GlobalDimVal2: Code[20]): Integer
    var
        EditDimSetEntries: Page "Edit Dimension Set Entries";
        NewDimSetID: Integer;
    begin
        NewDimSetID := DimSetID;
        DimSetEntry.Reset;
        DimSetEntry.FilterGroup(2);
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimSetEntry.FilterGroup(0);
        EditDimSetEntries.SetTableview(DimSetEntry);
        EditDimSetEntries.SetFormCaption(NewCaption);
        EditDimSetEntries.RunModal;
        NewDimSetID := EditDimSetEntries.GetDimensionID;
        UpdateGlobalDimFromDimSetID(NewDimSetID,GlobalDimVal1,GlobalDimVal2);
        DimSetEntry.Reset;
        exit(NewDimSetID);
    end;


    procedure EditReclasDimensionSet2(var DimSetID: Integer;var NewDimSetID: Integer;NewCaption: Text[250];var GlobalDimVal1: Code[20];var GlobalDimVal2: Code[20];var NewGlobalDimVal1: Code[20];var NewGlobalDimVal2: Code[20])
    var
        EditReclasDimensions: Page "Edit Reclas. Dimensions";
    begin
        EditReclasDimensions.SetDimensionIDs(DimSetID,NewDimSetID);
        EditReclasDimensions.SetFormCaption(NewCaption);
        EditReclasDimensions.RunModal;
        EditReclasDimensions.GetDimensionIDs(DimSetID,NewDimSetID);
        UpdateGlobalDimFromDimSetID(DimSetID,GlobalDimVal1,GlobalDimVal2);
        UpdateGlobalDimFromDimSetID(NewDimSetID,NewGlobalDimVal1,NewGlobalDimVal2);
    end;


    procedure UpdateGlobalDimFromDimSetID(DimSetID: Integer;var GlobalDimVal1: Code[20];var GlobalDimVal2: Code[20])
    begin
        GetGLSetup;
        GlobalDimVal1 := '';
        GlobalDimVal2 := '';
        if GLSetupShortcutDimCode[1] <> '' then
          if DimSetEntry.Get(DimSetID,GLSetupShortcutDimCode[1]) then
            GlobalDimVal1 := DimSetEntry."Dimension Value Code";
        if GLSetupShortcutDimCode[2] <> '' then
          if DimSetEntry.Get(DimSetID,GLSetupShortcutDimCode[2]) then
            GlobalDimVal2 := DimSetEntry."Dimension Value Code";
    end;


    procedure GetCombinedDimensionSetID(DimensionSetIDArr: array [10] of Integer;var GlobalDimVal1: Code[20];var GlobalDimVal2: Code[20]): Integer
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        i: Integer;
    begin
        GetGLSetup;
        GlobalDimVal1 := '';
        GlobalDimVal2 := '';
        DimSetEntry.Reset;
        for i := 1 to 10 do
          if DimensionSetIDArr[i] <> 0 then begin
            DimSetEntry.SetRange("Dimension Set ID",DimensionSetIDArr[i]);
            if DimSetEntry.FindSet then
              repeat
                if TempDimSetEntry.Get(0,DimSetEntry."Dimension Code") then
                  TempDimSetEntry.Delete;
                TempDimSetEntry := DimSetEntry;
                TempDimSetEntry."Dimension Set ID" := 0;
                TempDimSetEntry.Insert;
                if GLSetupShortcutDimCode[1] = TempDimSetEntry."Dimension Code" then
                  GlobalDimVal1 := TempDimSetEntry."Dimension Value Code";
                if GLSetupShortcutDimCode[2] = TempDimSetEntry."Dimension Code" then
                  GlobalDimVal2 := TempDimSetEntry."Dimension Value Code";
              until DimSetEntry.Next = 0;
          end;
        exit(GetDimensionSetID(TempDimSetEntry));
    end;


    procedure GetDeltaDimSetID(DimSetID: Integer;NewParentDimSetID: Integer;OldParentDimSetID: Integer): Integer
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntryNew: Record "Dimension Set Entry" temporary;
        TempDimSetEntryDeleted: Record "Dimension Set Entry" temporary;
    begin
        // Returns an updated DimSetID based on parent's old and new DimSetID
        if NewParentDimSetID = OldParentDimSetID then
          exit(DimSetID);
        GetDimensionSet(TempDimSetEntry,DimSetID);
        GetDimensionSet(TempDimSetEntryNew,NewParentDimSetID);
        GetDimensionSet(TempDimSetEntryDeleted,OldParentDimSetID);
        if TempDimSetEntryDeleted.FindSet then
          repeat
            if TempDimSetEntryNew.Get(NewParentDimSetID,TempDimSetEntryDeleted."Dimension Code") then begin
              if TempDimSetEntryNew."Dimension Value Code" = TempDimSetEntryDeleted."Dimension Value Code" then
                TempDimSetEntryNew.Delete;
              TempDimSetEntryDeleted.Delete;
            end;
          until TempDimSetEntryDeleted.Next = 0;

        if TempDimSetEntryDeleted.FindSet then
          repeat
            if TempDimSetEntry.Get(DimSetID,TempDimSetEntryDeleted."Dimension Code") then
              TempDimSetEntry.Delete;
          until TempDimSetEntryDeleted.Next = 0;

        if TempDimSetEntryNew.FindSet then
          repeat
            if TempDimSetEntry.Get(DimSetID,TempDimSetEntryNew."Dimension Code") then begin
              if TempDimSetEntry."Dimension Value Code" <> TempDimSetEntryNew."Dimension Value Code" then begin
                TempDimSetEntry."Dimension Value Code" := TempDimSetEntryNew."Dimension Value Code";
                TempDimSetEntry."Dimension Value ID" := TempDimSetEntryNew."Dimension Value ID";
                TempDimSetEntry.Modify;
              end;
            end else begin
              TempDimSetEntry := TempDimSetEntryNew;
              TempDimSetEntry."Dimension Set ID" := DimSetID;
              TempDimSetEntry.Insert;
            end;
          until TempDimSetEntryNew.Next = 0;

        exit(GetDimensionSetID(TempDimSetEntry));
    end;

    local procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if not HasGotGLSetup then begin
          GLSetup.Get;
          GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
          GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
          GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
          GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
          GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
          GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
          GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
          GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
          HasGotGLSetup := true;
        end;
    end;


    procedure CheckDimIDComb(DimSetID: Integer): Boolean
    begin
        TempDimBuf1.Reset;
        TempDimBuf1.DeleteAll;
        DimSetEntry.Reset;
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        if DimSetEntry.FindSet then
          repeat
            TempDimBuf1.Init;
            TempDimBuf1."Table ID" := Database::"Dimension Buffer";
            TempDimBuf1."Entry No." := 0;
            TempDimBuf1."Dimension Code" := DimSetEntry."Dimension Code";
            TempDimBuf1."Dimension Value Code" := DimSetEntry."Dimension Value Code";
            TempDimBuf1.Insert;
          until DimSetEntry.Next = 0;

        DimSetEntry.Reset;
        exit(CheckDimComb);
    end;


    procedure CheckDimValuePosting(TableID: array [10] of Integer;No: array [10] of Code[20];DimSetID: Integer): Boolean
    var
        i: Integer;
        j: Integer;
        NoFilter: array [2] of Text[250];
    begin
        if not CheckBlockedDimAndValues(DimSetID) then
          exit(false);
        DefaultDim.SetFilter("Value Posting",'<>%1',DefaultDim."value posting"::" ");
        DimSetEntry.Reset;
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        NoFilter[2] := '';
        for i := 1 to ArrayLen(TableID) do begin
          if (TableID[i] <> 0) and (No[i] <> '') then begin
            DefaultDim.SetRange("Table ID",TableID[i]);
            NoFilter[1] := No[i];
            for j := 1 to 2 do begin
              DefaultDim.SetRange("No.",NoFilter[j]);
              if DefaultDim.FindSet then
                repeat
                  DimSetEntry.SetRange("Dimension Code",DefaultDim."Dimension Code");
                  case DefaultDim."Value Posting" of
                    DefaultDim."value posting"::"Code Mandatory":
                      begin
                        if not DimSetEntry.FindFirst or (DimSetEntry."Dimension Value Code" = '') then begin
                          if DefaultDim."No." = '' then
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text004,
                                DefaultDim.FieldCaption("Dimension Value Code"),
                                DefaultDim.FieldCaption("Dimension Code"),DefaultDim."Dimension Code")
                          else
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text005,
                                DefaultDim.FieldCaption("Dimension Value Code"),
                                DefaultDim.FieldCaption("Dimension Code"),
                                DefaultDim."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          exit(false);
                        end;
                      end;
                    DefaultDim."value posting"::"Same Code":
                      begin
                        if DefaultDim."Dimension Value Code" <> '' then begin
                          if not DimSetEntry.FindFirst or
                             (DefaultDim."Dimension Value Code" <> DimSetEntry."Dimension Value Code")
                          then begin
                            if DefaultDim."No." = '' then
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text006,
                                  DefaultDim.FieldCaption("Dimension Value Code"),DefaultDim."Dimension Value Code",
                                  DefaultDim.FieldCaption("Dimension Code"),DefaultDim."Dimension Code")
                            else
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text007,
                                  DefaultDim.FieldCaption("Dimension Value Code"),
                                  DefaultDim."Dimension Value Code",
                                  DefaultDim.FieldCaption("Dimension Code"),
                                  DefaultDim."Dimension Code",
                                  ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                  DefaultDim."No.");
                            exit(false);
                          end;
                        end else begin
                          if DimSetEntry.FindFirst then begin
                            if DefaultDim."No." = '' then
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text008,
                                  DimSetEntry.FieldCaption("Dimension Code"),DimSetEntry."Dimension Code")
                            else
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text009,
                                  DimSetEntry.FieldCaption("Dimension Code"),
                                  DimSetEntry."Dimension Code",
                                  ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                  DefaultDim."No.");
                            exit(false);
                          end;
                        end;
                      end;
                    DefaultDim."value posting"::"No Code":
                      begin
                        if DimSetEntry.FindFirst then begin
                          if DefaultDim."No." = '' then
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text010,
                                DimSetEntry.FieldCaption("Dimension Code"),DimSetEntry."Dimension Code")
                          else
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text011,
                                DimSetEntry.FieldCaption("Dimension Code"),
                                DimSetEntry."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          exit(false);
                        end;
                      end;
                  end;
                until DefaultDim.Next = 0;
            end;
          end;
        end;
        DimSetEntry.Reset;
        exit(true);
    end;


    procedure CheckDimBuffer(var DimBuffer: Record "Dimension Buffer"): Boolean
    var
        i: Integer;
    begin
        TempDimBuf1.Reset;
        TempDimBuf1.DeleteAll;
        if DimBuffer.FindSet then begin
          i := 1;
          repeat
            TempDimBuf1.Init;
            TempDimBuf1."Table ID" := Database::"Dimension Buffer";
            TempDimBuf1."Entry No." := i;
            TempDimBuf1."Dimension Code" := DimBuffer."Dimension Code";
            TempDimBuf1."Dimension Value Code" := DimBuffer."Dimension Value Code";
            TempDimBuf1.Insert;
            i := i + 1;
          until DimBuffer.Next = 0;
        end;
        exit(CheckDimComb);
    end;

    local procedure CheckDimComb(): Boolean
    var
        DimComb: Record "Dimension Combination";
        CurrentDimCode: Code[20];
        CurrentDimValCode: Code[20];
        DimFilter: Text[1024];
        FilterTooLong: Boolean;
    begin
        if not TempDimCombInitialized then begin
          TempDimCombInitialized := true;
          if DimComb.IsEmpty then
            TempDimCombEmpty := true;
        end;

        if TempDimCombEmpty then
          exit(true);

        if not TempDimBuf1.FindSet then
          exit(true);

        repeat
          if StrLen(DimFilter) + 1 + StrLen(TempDimBuf1."Dimension Code") > MaxStrLen(DimFilter) then
            FilterTooLong := true
          else
            if DimFilter = '' then
              DimFilter := TempDimBuf1."Dimension Code"
            else
              DimFilter := DimFilter + '|' + TempDimBuf1."Dimension Code";
        until FilterTooLong or (TempDimBuf1.Next = 0);

        if not FilterTooLong then begin
          DimComb.SetFilter("Dimension 1 Code",DimFilter);
          DimComb.SetFilter("Dimension 2 Code",DimFilter);
          if DimComb.FindSet then
            repeat
              if DimComb."Combination Restriction" = DimComb."combination restriction"::Blocked then begin
                DimCombErr := StrSubstNo(Text000,DimComb."Dimension 1 Code",DimComb."Dimension 2 Code");
                exit(false);
              end else begin
                TempDimBuf1.SetRange("Dimension Code",DimComb."Dimension 1 Code");
                TempDimBuf1.FindFirst;
                CurrentDimCode := TempDimBuf1."Dimension Code";
                CurrentDimValCode := TempDimBuf1."Dimension Value Code";
                TempDimBuf1.SetRange("Dimension Code",DimComb."Dimension 2 Code");
                TempDimBuf1.FindFirst;
                if not
                   CheckDimValueComb(
                     TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code",
                     CurrentDimCode,CurrentDimValCode)
                then
                  exit(false);
                if not
                   CheckDimValueComb(
                     CurrentDimCode,CurrentDimValCode,
                     TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code")
                then
                  exit(false);
              end;
            until DimComb.Next = 0;
          exit(true);
        end;

        while TempDimBuf1.FindFirst do begin
          CurrentDimCode := TempDimBuf1."Dimension Code";
          CurrentDimValCode := TempDimBuf1."Dimension Value Code";
          TempDimBuf1.Delete;
          if TempDimBuf1.FindSet then
            repeat
              if CurrentDimCode > TempDimBuf1."Dimension Code" then begin
                if DimComb.Get(TempDimBuf1."Dimension Code",CurrentDimCode) then begin
                  if DimComb."Combination Restriction" = DimComb."combination restriction"::Blocked then begin
                    DimCombErr :=
                      StrSubstNo(
                        Text000,
                        TempDimBuf1."Dimension Code",CurrentDimCode);
                    exit(false);
                  end;
                  if not
                     CheckDimValueComb(
                       TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code",
                       CurrentDimCode,CurrentDimValCode)
                  then
                    exit(false);
                end;
              end else begin
                if DimComb.Get(CurrentDimCode,TempDimBuf1."Dimension Code") then begin
                  if DimComb."Combination Restriction" = DimComb."combination restriction"::Blocked then begin
                    DimCombErr :=
                      StrSubstNo(
                        Text000,
                        CurrentDimCode,TempDimBuf1."Dimension Code");
                    exit(false);
                  end;
                  if not
                     CheckDimValueComb(
                       CurrentDimCode,CurrentDimValCode,TempDimBuf1."Dimension Code",
                       TempDimBuf1."Dimension Value Code")
                  then
                    exit(false);
                end;
              end;
            until TempDimBuf1.Next = 0;
        end;
        exit(true);
    end;

    local procedure CheckDimValueComb(Dim1: Code[20];Dim1Value: Code[20];Dim2: Code[20];Dim2Value: Code[20]): Boolean
    begin
        if DimValComb.Get(Dim1,Dim1Value,Dim2,Dim2Value) then begin
          DimCombErr :=
            StrSubstNo(Text001,
              Dim1,Dim1Value,Dim2,Dim2Value);
          exit(false);
        end;
        exit(true);
    end;


    procedure GetDimCombErr(): Text[250]
    begin
        exit(DimCombErr);
    end;


    procedure UpdateDefaultDim(TableID: Integer;No: Code[20];var GlobalDim1Code: Code[20];var GlobalDim2Code: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    begin
        GetGLSetup;
        if DefaultDim.Get(TableID,No,GLSetupShortcutDimCode[1]) then
          GlobalDim1Code := DefaultDim."Dimension Value Code"
        else
          GlobalDim1Code := '';
        if DefaultDim.Get(TableID,No,GLSetupShortcutDimCode[2]) then
          GlobalDim2Code := DefaultDim."Dimension Value Code"
        else
          GlobalDim2Code := '';
    end;


    procedure GetDefaultDimID(TableID: array [10] of Integer;No: array [10] of Code[20];SourceCode: Code[20];var GlobalDim1Code: Code[20];var GlobalDim2Code: Code[20];InheritFromDimSetID: Integer;InheritFromTableNo: Integer): Integer
    var
        DimVal: Record "Dimension Value";
        DefaultDimPriority1: Record "Default Dimension Priority";
        DefaultDimPriority2: Record "Default Dimension Priority";
        DefaultDim: Record "Default Dimension";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry0: Record "Dimension Set Entry" temporary;
        i: Integer;
        j: Integer;
        NoFilter: array [2] of Code[20];
        NewDimSetID: Integer;
    begin
        GetGLSetup;
        if InheritFromDimSetID > 0 then
          GetDimensionSet(TempDimSetEntry0,InheritFromDimSetID);
        TempDimBuf2.Reset;
        TempDimBuf2.DeleteAll;
        if TempDimSetEntry0.FindSet then
          repeat
            TempDimBuf2.Init;
            TempDimBuf2."Table ID" := InheritFromTableNo;
            TempDimBuf2."Entry No." := 0;
            TempDimBuf2."Dimension Code" := TempDimSetEntry0."Dimension Code";
            TempDimBuf2."Dimension Value Code" := TempDimSetEntry0."Dimension Value Code";
            TempDimBuf2.Insert;
          until TempDimSetEntry0.Next = 0;

        NoFilter[2] := '';
        for i := 1 to ArrayLen(TableID) do begin
          if (TableID[i] <> 0) and (No[i] <> '') then begin
            DefaultDim.SetRange("Table ID",TableID[i]);
            NoFilter[1] := No[i];
            for j := 1 to 2 do begin
              DefaultDim.SetRange("No.",NoFilter[j]);
              if DefaultDim.FindSet then
                repeat
                  if DefaultDim."Dimension Value Code" <> '' then begin
                    TempDimBuf2.SetRange("Dimension Code",DefaultDim."Dimension Code");
                    if not TempDimBuf2.FindFirst then begin
                      TempDimBuf2.Init;
                      TempDimBuf2."Table ID" := DefaultDim."Table ID";
                      TempDimBuf2."Entry No." := 0;
                      TempDimBuf2."Dimension Code" := DefaultDim."Dimension Code";
                      TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                      TempDimBuf2.Insert;
                    end else begin
                      if DefaultDimPriority1.Get(SourceCode,DefaultDim."Table ID") then begin
                        if DefaultDimPriority2.Get(SourceCode,TempDimBuf2."Table ID") then begin
                          if DefaultDimPriority1.Priority < DefaultDimPriority2.Priority then begin
                            TempDimBuf2.Delete;
                            TempDimBuf2."Table ID" := DefaultDim."Table ID";
                            TempDimBuf2."Entry No." := 0;
                            TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                            TempDimBuf2.Insert;
                          end;
                        end else begin
                          TempDimBuf2.Delete;
                          TempDimBuf2."Table ID" := DefaultDim."Table ID";
                          TempDimBuf2."Entry No." := 0;
                          TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                          TempDimBuf2.Insert;
                        end;
                      end;
                    end;
                    if GLSetupShortcutDimCode[1] = TempDimBuf2."Dimension Code" then
                      GlobalDim1Code := TempDimBuf2."Dimension Value Code";
                    if GLSetupShortcutDimCode[2] = TempDimBuf2."Dimension Code" then
                      GlobalDim2Code := TempDimBuf2."Dimension Value Code";
                  end;
                until DefaultDim.Next = 0;
            end;
          end;
        end;
        TempDimBuf2.Reset;
        if TempDimBuf2.FindSet then begin
          repeat
            DimVal.Get(TempDimBuf2."Dimension Code",TempDimBuf2."Dimension Value Code");
            TempDimSetEntry."Dimension Code" := TempDimBuf2."Dimension Code";
            TempDimSetEntry."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            TempDimSetEntry.Insert;
          until TempDimBuf2.Next = 0;
          NewDimSetID := GetDimensionSetID(TempDimSetEntry);
        end;
        exit(NewDimSetID);
    end;


    procedure TypeToTableID1(Type: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Integer
    begin
        case Type of
          Type::"G/L Account":
            exit(Database::"G/L Account");
          Type::Customer:
            exit(Database::Customer);
          Type::Vendor:
            exit(Database::Vendor);
          Type::"Bank Account":
            exit(Database::"Bank Account");
          Type::"Fixed Asset":
            exit(Database::"Fixed Asset");
          Type::"IC Partner":
            exit(Database::"IC Partner");
        end;
    end;


    procedure TypeToTableID2(Type: Option Resource,Item,"G/L Account"): Integer
    begin
        case Type of
          Type::Resource:
            exit(Database::Resource);
          Type::Item:
            exit(Database::Item);
          Type::"G/L Account":
            exit(Database::"G/L Account");
        end;
    end;


    procedure TypeToTableID3(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"): Integer
    begin
        case Type of
          Type::" ":
            exit(0);
          Type::"G/L Account":
            exit(Database::"G/L Account");
          Type::Item:
            exit(Database::Item);
          Type::Resource:
            exit(Database::Resource);
          Type::"Fixed Asset":
            exit(Database::"Fixed Asset");
          Type::"Charge (Item)":
            exit(Database::"Item Charge");
        end;
    end;


    procedure TypeToTableID4(Type: Option " ",Item,Resource): Integer
    begin
        case Type of
          Type::" ":
            exit(0);
          Type::Item:
            exit(Database::Item);
          Type::Resource:
            exit(Database::Resource);
        end;
    end;


    procedure TypeToTableID5(Type: Option " ",Item,Resource,Cost,"G/L Account"): Integer
    begin
        case Type of
          Type::" ":
            exit(0);
          Type::Item:
            exit(Database::Item);
          Type::Resource:
            exit(Database::Resource);
          Type::Cost:
            exit(Database::"Service Cost");
          Type::"G/L Account":
            exit(Database::"G/L Account");
        end;
    end;


    procedure DeleteDefaultDim(TableID: Integer;No: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    begin
        DefaultDim.SetRange("Table ID",TableID);
        DefaultDim.SetRange("No.",No);
        if not DefaultDim.IsEmpty then
          DefaultDim.DeleteAll;
    end;


    procedure LookupDimValueCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        GetGLSetup;
        if GLSetupShortcutDimCode[FieldNumber] = '' then
          Error(Text002,GLSetup.TableCaption);
        DimVal.SetRange("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        DimVal.Code := ShortcutDimCode;
        if Page.RunModal(0,DimVal) = Action::LookupOK then begin
          CheckDim(DimVal."Dimension Code");
          CheckDimValue(DimVal."Dimension Code",DimVal.Code);
          ShortcutDimCode := DimVal.Code;
        end;
    end;


    procedure ValidateDimValueCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        GetGLSetup;
        if (GLSetupShortcutDimCode[FieldNumber] = '') and (ShortcutDimCode <> '') then
          Error(Text002,GLSetup.TableCaption);
        DimVal.SetRange("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
        if ShortcutDimCode <> '' then begin
          DimVal.SetRange(Code,ShortcutDimCode);
          if not DimVal.FindFirst then begin
            DimVal.SetFilter(Code,StrSubstNo('%1*',ShortcutDimCode));
            if DimVal.FindFirst then
              ShortcutDimCode := DimVal.Code
            else
              Error(
                StrSubstNo(Text003,
                  ShortcutDimCode,DimVal.FieldCaption(Code)));
          end;
        end;
    end;


    procedure ValidateShortcutDimValues(FieldNumber: Integer;var ShortcutDimCode: Code[20];var DimSetID: Integer)
    var
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        if ShortcutDimCode <> '' then begin
          DimVal.Get(DimVal."Dimension Code",ShortcutDimCode);
          if not CheckDim(DimVal."Dimension Code") then
            Error(GetDimErr);
          if not CheckDimValue(DimVal."Dimension Code",ShortcutDimCode) then
            Error(GetDimErr);
        end;
        GetDimensionSet(TempDimSetEntry,DimSetID);
        if TempDimSetEntry.Get(TempDimSetEntry."Dimension Set ID",DimVal."Dimension Code") then
          if TempDimSetEntry."Dimension Value Code" <> ShortcutDimCode then
            TempDimSetEntry.Delete;
        if ShortcutDimCode <> '' then begin
          TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
          TempDimSetEntry."Dimension Value Code" := DimVal.Code;
          TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
          if TempDimSetEntry.Insert then;
        end;
        DimSetID := GetDimensionSetID(TempDimSetEntry);
    end;


    procedure SaveDefaultDim(TableID: Integer;No: Code[20];FieldNumber: Integer;ShortcutDimCode: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    begin
        GetGLSetup;
        if ShortcutDimCode <> '' then begin
          if DefaultDim.Get(TableID,No,GLSetupShortcutDimCode[FieldNumber])
          then begin
            DefaultDim.Validate("Dimension Value Code",ShortcutDimCode);
            DefaultDim.Modify;
          end else begin
            DefaultDim.Init;
            DefaultDim.Validate("Table ID",TableID);
            DefaultDim.Validate("No.",No);
            DefaultDim.Validate("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
            DefaultDim.Validate("Dimension Value Code",ShortcutDimCode);
            DefaultDim.Insert;
          end;
        end else
          if DefaultDim.Get(TableID,No,GLSetupShortcutDimCode[FieldNumber]) then
            DefaultDim.Delete;
    end;


    procedure GetShortcutDimensions(DimSetID: Integer;var ShortcutDimCode: array [8] of Code[20])
    var
        i: Integer;
    begin
        GetGLSetup;
        for i := 3 to 8 do begin
          ShortcutDimCode[i] := '';
          if GLSetupShortcutDimCode[i] <> '' then
            if DimSetEntry.Get(DimSetID,GLSetupShortcutDimCode[i]) then
              ShortcutDimCode[i] := DimSetEntry."Dimension Value Code";
        end;
    end;


    procedure CheckDimBufferValuePosting(var DimBuffer: Record "Dimension Buffer";TableID: array [10] of Integer;No: array [10] of Code[20]): Boolean
    var
        i: Integer;
    begin
        TempDimBuf2.Reset;
        TempDimBuf2.DeleteAll;
        if DimBuffer.FindSet then begin
          i := 1;
          repeat
            if (not CheckDimValue(
                  DimBuffer."Dimension Code",DimBuffer."Dimension Value Code")) or
               (not CheckDim(DimBuffer."Dimension Code"))
            then begin
              DimValuePostingErr := DimErr;
              exit(false);
            end;
            TempDimBuf2.Init;
            TempDimBuf2."Entry No." := i;
            TempDimBuf2."Dimension Code" := DimBuffer."Dimension Code";
            TempDimBuf2."Dimension Value Code" := DimBuffer."Dimension Value Code";
            TempDimBuf2.Insert;
            i := i + 1;
          until DimBuffer.Next = 0;
        end;
        exit(CheckValuePosting(TableID,No));
    end;

    local procedure CheckValuePosting(TableID: array [10] of Integer;No: array [10] of Code[20]): Boolean
    var
        DefaultDim: Record "Default Dimension";
        i: Integer;
        j: Integer;
        NoFilter: array [2] of Text[250];
    begin
        DefaultDim.SetFilter("Value Posting",'<>%1',DefaultDim."value posting"::" ");
        NoFilter[2] := '';
        for i := 1 to ArrayLen(TableID) do begin
          if (TableID[i] <> 0) and (No[i] <> '') then begin
            DefaultDim.SetRange("Table ID",TableID[i]);
            NoFilter[1] := No[i];
            for j := 1 to 2 do begin
              DefaultDim.SetRange("No.",NoFilter[j]);
              if DefaultDim.FindSet then begin
                repeat
                  TempDimBuf2.SetRange("Dimension Code",DefaultDim."Dimension Code");
                  case DefaultDim."Value Posting" of
                    DefaultDim."value posting"::"Code Mandatory":
                      begin
                        if (not TempDimBuf2.FindFirst) or
                           (TempDimBuf2."Dimension Value Code" = '')
                        then begin
                          if DefaultDim."No." = '' then
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text004,
                                DefaultDim.FieldCaption("Dimension Value Code"),
                                DefaultDim.FieldCaption("Dimension Code"),DefaultDim."Dimension Code")
                          else
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text005,
                                DefaultDim.FieldCaption("Dimension Value Code"),
                                DefaultDim.FieldCaption("Dimension Code"),
                                DefaultDim."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          exit(false);
                        end;
                      end;
                    DefaultDim."value posting"::"Same Code":
                      begin
                        if DefaultDim."Dimension Value Code" <> '' then begin
                          if (not TempDimBuf2.FindFirst) or
                             (DefaultDim."Dimension Value Code" <> TempDimBuf2."Dimension Value Code")
                          then begin
                            if DefaultDim."No." = '' then
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text006,
                                  DefaultDim.FieldCaption("Dimension Value Code"),DefaultDim."Dimension Value Code",
                                  DefaultDim.FieldCaption("Dimension Code"),DefaultDim."Dimension Code")
                            else
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text007,
                                  DefaultDim.FieldCaption("Dimension Value Code"),
                                  DefaultDim."Dimension Value Code",
                                  DefaultDim.FieldCaption("Dimension Code"),
                                  DefaultDim."Dimension Code",
                                  ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                  DefaultDim."No.");
                            exit(false);
                          end;
                        end else begin
                          if TempDimBuf2.FindFirst then begin
                            if DefaultDim."No." = '' then
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text008,
                                  TempDimBuf2.FieldCaption("Dimension Code"),TempDimBuf2."Dimension Code")
                            else
                              DimValuePostingErr :=
                                StrSubstNo(
                                  Text009,
                                  TempDimBuf2.FieldCaption("Dimension Code"),
                                  TempDimBuf2."Dimension Code",
                                  ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                  DefaultDim."No.");
                            exit(false);
                          end;
                        end;
                      end;
                    DefaultDim."value posting"::"No Code":
                      begin
                        if TempDimBuf2.FindFirst then begin
                          if DefaultDim."No." = '' then
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text010,
                                TempDimBuf2.FieldCaption("Dimension Code"),TempDimBuf2."Dimension Code")
                          else
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text011,
                                TempDimBuf2.FieldCaption("Dimension Code"),
                                TempDimBuf2."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."object type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          exit(false);
                        end;
                      end;
                  end;
                until DefaultDim.Next = 0;
                TempDimBuf2.Reset;
              end;
            end;
          end;
        end;
        exit(true);
    end;


    procedure GetDimValuePostingErr(): Text[250]
    begin
        exit(DimValuePostingErr);
    end;


    procedure SetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    begin
        InsertObject(TempAllObjWithCaption,Database::"Salesperson/Purchaser");
        InsertObject(TempAllObjWithCaption,Database::"G/L Account");
        InsertObject(TempAllObjWithCaption,Database::Customer);
        InsertObject(TempAllObjWithCaption,Database::Vendor);
        InsertObject(TempAllObjWithCaption,Database::Item);
        InsertObject(TempAllObjWithCaption,Database::"Resource Group");
        InsertObject(TempAllObjWithCaption,Database::Resource);
        InsertObject(TempAllObjWithCaption,Database::Job);
        InsertObject(TempAllObjWithCaption,Database::"Bank Account");
        InsertObject(TempAllObjWithCaption,Database::Campaign);
        InsertObject(TempAllObjWithCaption,Database::o);
        InsertObject(TempAllObjWithCaption,Database::"Fixed Asset");
        InsertObject(TempAllObjWithCaption,Database::Insurance);
        InsertObject(TempAllObjWithCaption,Database::"Responsibility Center");
        InsertObject(TempAllObjWithCaption,Database::"Item Charge");
        InsertObject(TempAllObjWithCaption,Database::"Work Center");
        InsertObject(TempAllObjWithCaption,Database::"Service Contract Header");
        InsertObject(TempAllObjWithCaption,Database::"Customer Template");
        InsertObject(TempAllObjWithCaption,Database::"Service Contract Template");
        InsertObject(TempAllObjWithCaption,Database::"IC Partner");
        InsertObject(TempAllObjWithCaption,Database::"Service Order Type");
        InsertObject(TempAllObjWithCaption,Database::"Service Item Group");
        InsertObject(TempAllObjWithCaption,Database::"Service Item");
        InsertObject(TempAllObjWithCaption,Database::"Cash Flow Manual Expense");
        InsertObject(TempAllObjWithCaption,Database::"Cash Flow Manual Revenue");
        OnAfterSetupObjectNoList(TempAllObjWithCaption);
    end;


    procedure GetDocDimConsistencyErr(): Text[250]
    begin
        exit(DocDimConsistencyErr);
    end;


    procedure CheckDim(DimCode: Code[20]): Boolean
    var
        Dim: Record Dimension;
    begin
        if Dim.Get(DimCode) then begin
          if Dim.Blocked then begin
            DimErr :=
              StrSubstNo(Text014,Dim.TableCaption,DimCode);
            exit(false);
          end;
        end else begin
          DimErr :=
            StrSubstNo(Text015,Dim.TableCaption,DimCode);
          exit(false);
        end;
        exit(true);
    end;


    procedure CheckDimValue(DimCode: Code[20];DimValCode: Code[20]): Boolean
    var
        DimVal: Record "Dimension Value";
    begin
        if (DimCode <> '') and (DimValCode <> '') then begin
          if DimVal.Get(DimCode,DimValCode) then begin
            if DimVal.Blocked then begin
              DimErr :=
                StrSubstNo(
                  Text016,DimVal.TableCaption,DimCode,DimValCode);
              exit(false);
            end;
            if not (DimVal."Dimension Value Type" in
                    [DimVal."dimension value type"::Standard,
                     DimVal."dimension value type"::"Begin-Total"])
            then begin
              DimErr :=
                StrSubstNo(Text017,DimVal.FieldCaption("Dimension Value Type"),
                  DimVal.TableCaption,DimCode,DimValCode,Format(DimVal."Dimension Value Type"));
              exit(false);
            end;
          end else begin
            DimErr :=
              StrSubstNo(
                Text018,DimVal.TableCaption,DimCode);
            exit(false);
          end;
        end;
        exit(true);
    end;

    local procedure CheckBlockedDimAndValues(DimSetID: Integer): Boolean
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if DimSetID = 0 then
          exit(true);
        DimSetEntry.Reset;
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        if DimSetEntry.FindSet then
          repeat
            if not CheckDim(DimSetEntry."Dimension Code") or
               not CheckDimValue(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
            then begin
              DimValuePostingErr := DimErr;
              exit(false);
            end;
          until DimSetEntry.Next = 0;
        exit(true);
    end;


    procedure GetDimErr(): Text[250]
    begin
        exit(DimErr);
    end;


    procedure LookupDimValueCodeNoUpdate(FieldNumber: Integer)
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        GetGLSetup;
        if GLSetupShortcutDimCode[FieldNumber] = '' then
          Error(Text002,GLSetup.TableCaption);
        DimVal.SetRange("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
        if Page.RunModal(0,DimVal) = Action::LookupOK then;
    end;


    procedure CopyJnlLineDimToICJnlDim(TableID: Integer;TransactionNo: Integer;PartnerCode: Code[20];TransactionSource: Option;LineNo: Integer;DimSetID: Integer)
    var
        InOutBoxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
        DimSetEntry: Record "Dimension Set Entry";
        ICDim: Code[20];
        ICDimValue: Code[20];
    begin
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        if DimSetEntry.FindSet then
          repeat
            ICDim := ConvertDimtoICDim(DimSetEntry."Dimension Code");
            ICDimValue := ConvertDimValuetoICDimVal(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
            if (ICDim <> '') and (ICDimValue <> '') then begin
              InOutBoxJnlLineDim.Init;
              InOutBoxJnlLineDim."Table ID" := TableID;
              InOutBoxJnlLineDim."IC Partner Code" := PartnerCode;
              InOutBoxJnlLineDim."Transaction No." := TransactionNo;
              InOutBoxJnlLineDim."Transaction Source" := TransactionSource;
              InOutBoxJnlLineDim."Line No." := LineNo;
              InOutBoxJnlLineDim."Dimension Code" := ICDim;
              InOutBoxJnlLineDim."Dimension Value Code" := ICDimValue;
              InOutBoxJnlLineDim.Insert;
            end;
          until DimSetEntry.Next = 0;
    end;


    procedure DefaultDimOnInsert(DefaultDimension: Record "Default Dimension")
    var
        CallingTrigger: Option OnInsert,OnModify,OnDelete;
    begin
        if DefaultDimension."Table ID" = Database::Job then
          UpdateJobTaskDim(DefaultDimension,false);

        UpdateCostType(DefaultDimension,Callingtrigger::OnInsert);
    end;


    procedure DefaultDimOnModify(DefaultDimension: Record "Default Dimension")
    var
        CallingTrigger: Option OnInsert,OnModify,OnDelete;
    begin
        if DefaultDimension."Table ID" = Database::Job then
          UpdateJobTaskDim(DefaultDimension,false);

        UpdateCostType(DefaultDimension,Callingtrigger::OnModify);
    end;


    procedure DefaultDimOnDelete(DefaultDimension: Record "Default Dimension")
    var
        CallingTrigger: Option OnInsert,OnModify,OnDelete;
    begin
        if DefaultDimension."Table ID" = Database::Job then
          UpdateJobTaskDim(DefaultDimension,true);

        UpdateCostType(DefaultDimension,Callingtrigger::OnDelete);
    end;


    procedure CopyICJnlDimToICJnlDim(var FromInOutBoxLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";var ToInOutBoxlineDim: Record "IC Inbox/Outbox Jnl. Line Dim.")
    begin
        if FromInOutBoxLineDim.FindSet then
          repeat
            ToInOutBoxlineDim := FromInOutBoxLineDim;
            ToInOutBoxlineDim.Insert;
          until FromInOutBoxLineDim.Next = 0;
    end;


    procedure CopyDocDimtoICDocDim(TableID: Integer;TransactionNo: Integer;PartnerCode: Code[20];TransactionSource: Option;LineNo: Integer;DimSetEntryID: Integer)
    var
        InOutBoxDocDim: Record "IC Document Dimension";
        DimSetEntry: Record "Dimension Set Entry";
        ICDim: Code[20];
        ICDimValue: Code[20];
    begin
        DimSetEntry.SetRange("Dimension Set ID",DimSetEntryID);
        if DimSetEntry.FindSet then
          repeat
            ICDim := ConvertDimtoICDim(DimSetEntry."Dimension Code");
            ICDimValue := ConvertDimValuetoICDimVal(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
            if (ICDim <> '') and (ICDimValue <> '') then begin
              InOutBoxDocDim.Init;
              InOutBoxDocDim."Table ID" := TableID;
              InOutBoxDocDim."IC Partner Code" := PartnerCode;
              InOutBoxDocDim."Transaction No." := TransactionNo;
              InOutBoxDocDim."Transaction Source" := TransactionSource;
              InOutBoxDocDim."Line No." := LineNo;
              InOutBoxDocDim."Dimension Code" := ICDim;
              InOutBoxDocDim."Dimension Value Code" := ICDimValue;
              InOutBoxDocDim.Insert;
            end;
          until DimSetEntry.Next = 0;
    end;


    procedure CopyICDocDimtoICDocDim(FromSourceICDocDim: Record "IC Document Dimension";var ToSourceICDocDim: Record "IC Document Dimension";ToTableID: Integer;ToTransactionSource: Integer)
    begin
        with FromSourceICDocDim do begin
          SetICDocDimFilters(FromSourceICDocDim,"Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.");
          if FindSet then
            repeat
              ToSourceICDocDim := FromSourceICDocDim;
              ToSourceICDocDim."Table ID" := ToTableID;
              ToSourceICDocDim."Transaction Source" := ToTransactionSource;
              ToSourceICDocDim.Insert;
            until Next = 0;
        end;
    end;


    procedure MoveICDocDimtoICDocDim(FromSourceICDocDim: Record "IC Document Dimension";var ToSourceICDocDim: Record "IC Document Dimension";ToTableID: Integer;ToTransactionSource: Integer)
    begin
        with FromSourceICDocDim do begin
          SetICDocDimFilters(FromSourceICDocDim,"Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.");
          if FindSet then
            repeat
              ToSourceICDocDim := FromSourceICDocDim;
              ToSourceICDocDim."Table ID" := ToTableID;
              ToSourceICDocDim."Transaction Source" := ToTransactionSource;
              ToSourceICDocDim.Insert;
              Delete;
            until Next = 0;
        end;
    end;


    procedure SetICDocDimFilters(var ICDocDim: Record "IC Document Dimension";TableID: Integer;TransactionNo: Integer;PartnerCode: Code[20];TransactionSource: Integer;LineNo: Integer)
    begin
        ICDocDim.Reset;
        ICDocDim.SetRange("Table ID",TableID);
        ICDocDim.SetRange("Transaction No.",TransactionNo);
        ICDocDim.SetRange("IC Partner Code",PartnerCode);
        ICDocDim.SetRange("Transaction Source",TransactionSource);
        ICDocDim.SetRange("Line No.",LineNo);
    end;


    procedure DeleteICDocDim(TableID: Integer;ICTransactionNo: Integer;ICPartnerCode: Code[20];TransactionSource: Option;LineNo: Integer)
    var
        ICDocDim: Record "IC Document Dimension";
    begin
        SetICDocDimFilters(ICDocDim,TableID,ICTransactionNo,ICPartnerCode,TransactionSource,LineNo);
        if not ICDocDim.IsEmpty then
          ICDocDim.DeleteAll;
    end;


    procedure DeleteICJnlDim(TableID: Integer;ICTransactionNo: Integer;ICPartnerCode: Code[20];TransactionSource: Option;LineNo: Integer)
    var
        ICJnlDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
    begin
        ICJnlDim.SetRange("Table ID",TableID);
        ICJnlDim.SetRange("Transaction No.",ICTransactionNo);
        ICJnlDim.SetRange("IC Partner Code",ICPartnerCode);
        ICJnlDim.SetRange("Transaction Source",TransactionSource);
        ICJnlDim.SetRange("Line No.",LineNo);
        if not ICJnlDim.IsEmpty then
          ICJnlDim.DeleteAll;
    end;

    local procedure ConvertICDimtoDim(FromICDim: Code[20]) DimCode: Code[20]
    var
        ICDim: Record "IC Dimension";
    begin
        if ICDim.Get(FromICDim) then
          DimCode := ICDim."Map-to Dimension Code";
    end;

    local procedure ConvertICDimValuetoDimValue(FromICDim: Code[20];FromICDimValue: Code[20]) DimValueCode: Code[20]
    var
        ICDimValue: Record "IC Dimension Value";
    begin
        if ICDimValue.Get(FromICDim,FromICDimValue) then
          DimValueCode := ICDimValue."Map-to Dimension Value Code";
    end;


    procedure ConvertDimtoICDim(FromDim: Code[20]) ICDimCode: Code[20]
    var
        Dim: Record Dimension;
    begin
        if Dim.Get(FromDim) then
          ICDimCode := Dim."Map-to IC Dimension Code";
    end;


    procedure ConvertDimValuetoICDimVal(FromDim: Code[20];FromDimValue: Code[20]) ICDimValueCode: Code[20]
    var
        DimValue: Record "Dimension Value";
    begin
        if DimValue.Get(FromDim,FromDimValue) then
          ICDimValueCode := DimValue."Map-to IC Dimension Value Code";
    end;


    procedure CheckICDimValue(ICDimCode: Code[20];ICDimValCode: Code[20]): Boolean
    var
        ICDimVal: Record "IC Dimension Value";
    begin
        if (ICDimCode <> '') and (ICDimValCode <> '') then begin
          if ICDimVal.Get(ICDimCode,ICDimValCode) then begin
            if ICDimVal.Blocked then begin
              DimErr :=
                StrSubstNo(
                  Text016,ICDimVal.TableCaption,ICDimCode,ICDimValCode);
              exit(false);
            end;
            if not (ICDimVal."Dimension Value Type" in
                    [ICDimVal."dimension value type"::Standard,
                     ICDimVal."dimension value type"::"Begin-Total"])
            then begin
              DimErr :=
                StrSubstNo(Text017,ICDimVal.FieldCaption("Dimension Value Type"),
                  ICDimVal.TableCaption,ICDimCode,ICDimValCode,Format(ICDimVal."Dimension Value Type"));
              exit(false);
            end;
          end else begin
            DimErr :=
              StrSubstNo(
                Text018,ICDimVal.TableCaption,ICDimCode);
            exit(false);
          end;
        end;
        exit(true);
    end;


    procedure CheckICDim(ICDimCode: Code[20]): Boolean
    var
        ICDim: Record "IC Dimension";
    begin
        if ICDim.Get(ICDimCode) then begin
          if ICDim.Blocked then begin
            DimErr :=
              StrSubstNo(Text014,ICDim.TableCaption,ICDimCode);
            exit(false);
          end;
        end else begin
          DimErr :=
            StrSubstNo(Text015,ICDim.TableCaption,ICDimCode);
          exit(false);
        end;
        exit(true);
    end;


    procedure SaveJobTaskDim(JobNo: Code[20];JobTaskNo: Code[20];FieldNumber: Integer;ShortcutDimCode: Code[20])
    var
        JobTaskDim: Record "Job Task Dimension";
    begin
        GetGLSetup;
        if ShortcutDimCode <> '' then begin
          if JobTaskDim.Get(JobNo,JobTaskNo,GLSetupShortcutDimCode[FieldNumber])
          then begin
            JobTaskDim.Validate("Dimension Value Code",ShortcutDimCode);
            JobTaskDim.Modify;
          end else begin
            JobTaskDim.Init;
            JobTaskDim.Validate("Job No.",JobNo);
            JobTaskDim.Validate("Job Task No.",JobTaskNo);
            JobTaskDim.Validate("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
            JobTaskDim.Validate("Dimension Value Code",ShortcutDimCode);
            JobTaskDim.Insert;
          end;
        end else
          if JobTaskDim.Get(JobNo,JobTaskNo,GLSetupShortcutDimCode[FieldNumber]) then
            JobTaskDim.Delete;
    end;


    procedure SaveJobTaskTempDim(FieldNumber: Integer;ShortcutDimCode: Code[20])
    begin
        GetGLSetup;
        if ShortcutDimCode <> '' then begin
          if JobTaskDimTemp.Get('','',GLSetupShortcutDimCode[FieldNumber])
          then begin
            JobTaskDimTemp."Dimension Value Code" := ShortcutDimCode;
            JobTaskDimTemp.Modify;
          end else begin
            JobTaskDimTemp.Init;
            JobTaskDimTemp."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
            JobTaskDimTemp."Dimension Value Code" := ShortcutDimCode;
            JobTaskDimTemp.Insert;
          end;
        end else
          if JobTaskDimTemp.Get('','',GLSetupShortcutDimCode[FieldNumber]) then
            JobTaskDimTemp.Delete;
    end;


    procedure InsertJobTaskDim(JobNo: Code[20];JobTaskNo: Code[20];var GlobalDim1Code: Code[20];var GlobalDim2Code: Code[20])
    var
        DefaultDim: Record "Default Dimension";
        JobTaskDim: Record "Job Task Dimension";
    begin
        GetGLSetup;
        DefaultDim.SetRange("Table ID",Database::Job);
        DefaultDim.SetRange("No.",JobNo);
        if DefaultDim.FindSet(false,false) then
          repeat
            if DefaultDim."Dimension Value Code" <> '' then begin
              JobTaskDim.Init;
              JobTaskDim."Job No." := JobNo;
              JobTaskDim."Job Task No." := JobTaskNo;
              JobTaskDim."Dimension Code" := DefaultDim."Dimension Code";
              JobTaskDim."Dimension Value Code" := DefaultDim."Dimension Value Code";
              JobTaskDim.Insert;
              if JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] then
                GlobalDim1Code := JobTaskDim."Dimension Value Code";
              if JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] then
                GlobalDim2Code := JobTaskDim."Dimension Value Code";
            end;
          until DefaultDim.Next = 0;

        JobTaskDimTemp.Reset;
        if JobTaskDimTemp.FindSet then
          repeat
            if not JobTaskDim.Get(JobNo,JobTaskNo,JobTaskDimTemp."Dimension Code") then begin
              JobTaskDim.Init;
              JobTaskDim."Job No." := JobNo;
              JobTaskDim."Job Task No." := JobTaskNo;
              JobTaskDim."Dimension Code" := JobTaskDimTemp."Dimension Code";
              JobTaskDim."Dimension Value Code" := JobTaskDimTemp."Dimension Value Code";
              JobTaskDim.Insert;
              if JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] then
                GlobalDim1Code := JobTaskDim."Dimension Value Code";
              if JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] then
                GlobalDim2Code := JobTaskDim."Dimension Value Code";
            end;
          until JobTaskDimTemp.Next = 0;
        JobTaskDimTemp.DeleteAll;
    end;

    local procedure UpdateJobTaskDim(DefaultDimension: Record "Default Dimension";FromOnDelete: Boolean)
    var
        JobTaskDimension: Record "Job Task Dimension";
        JobTask: Record "Job Task";
    begin
        if DefaultDimension."Table ID" <> Database::Job then
          exit;

        JobTask.SetRange("Job No.",DefaultDimension."No.");
        if JobTask.IsEmpty then
          exit;

        if not Confirm(Text019,true) then
          exit;

        JobTaskDimension.SetRange("Job No.",DefaultDimension."No.");
        JobTaskDimension.SetRange("Dimension Code",DefaultDimension."Dimension Code");
        JobTaskDimension.DeleteAll(true);

        if FromOnDelete or
           (DefaultDimension."Value Posting" = DefaultDimension."value posting"::"No Code") or
           (DefaultDimension."Dimension Value Code" = '')
        then
          exit;

        if JobTask.FindSet then
          repeat
            Clear(JobTaskDimension);
            JobTaskDimension."Job No." := JobTask."Job No.";
            JobTaskDimension."Job Task No." := JobTask."Job Task No.";
            JobTaskDimension."Dimension Code" := DefaultDimension."Dimension Code";
            JobTaskDimension."Dimension Value Code" := DefaultDimension."Dimension Value Code";
            JobTaskDimension.Insert(true);
          until JobTask.Next = 0;
    end;


    procedure DeleteJobTaskTempDim()
    begin
        JobTaskDimTemp.Reset;
        JobTaskDimTemp.DeleteAll;
    end;


    procedure CopyJobTaskDimToJobTaskDim(JobNo: Code[20];JobTaskNo: Code[20];NewJobNo: Code[20];NewJobTaskNo: Code[20])
    var
        JobTaskDimension: Record "Job Task Dimension";
        JobTaskDimension2: Record "Job Task Dimension";
    begin
        JobTaskDimension.Reset;
        JobTaskDimension.SetRange("Job No.",JobNo);
        JobTaskDimension.SetRange("Job Task No.",JobTaskNo);
        if JobTaskDimension.FindSet then
          repeat
            if not JobTaskDimension2.Get(NewJobNo,NewJobTaskNo,JobTaskDimension."Dimension Code") then begin
              JobTaskDimension2.Init;
              JobTaskDimension2."Job No." := NewJobNo;
              JobTaskDimension2."Job Task No." := NewJobTaskNo;
              JobTaskDimension2."Dimension Code" := JobTaskDimension."Dimension Code";
              JobTaskDimension2."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
              JobTaskDimension2.Insert(true);
            end;
          until JobTaskDimension.Next = 0;
    end;


    procedure CheckDimIDConsistency(var DimSetEntry: Record "Dimension Set Entry";var PostedDimSetEntry: Record "Dimension Set Entry";DocTableID: Integer;PostedDocTableID: Integer): Boolean
    begin
        if DimSetEntry.FindSet then;
        if PostedDimSetEntry.FindSet then;
        repeat
          case true of
            DimSetEntry."Dimension Code" > PostedDimSetEntry."Dimension Code":
              begin
                DocDimConsistencyErr :=
                  StrSubstNo(
                    Text012,
                    DimSetEntry.FieldCaption("Dimension Code"),
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,DocTableID),
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,PostedDocTableID));
                exit(false);
              end;
            DimSetEntry."Dimension Code" < PostedDimSetEntry."Dimension Code":
              begin
                DocDimConsistencyErr :=
                  StrSubstNo(
                    Text012,
                    PostedDimSetEntry.FieldCaption("Dimension Code"),
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,PostedDocTableID),
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,DocTableID));
                exit(false);
              end;
            DimSetEntry."Dimension Code" = PostedDimSetEntry."Dimension Code":
              begin
                if DimSetEntry."Dimension Value Code" <> PostedDimSetEntry."Dimension Value Code" then begin
                  DocDimConsistencyErr :=
                    StrSubstNo(
                      Text013,
                      DimSetEntry.FieldCaption("Dimension Value Code"),
                      DimSetEntry.FieldCaption("Dimension Code"),
                      DimSetEntry."Dimension Code",
                      ObjTransl.TranslateObject(ObjTransl."object type"::Table,DocTableID),
                      ObjTransl.TranslateObject(ObjTransl."object type"::Table,PostedDocTableID));
                  exit(false);
                end;
              end;
          end;
        until (DimSetEntry.Next = 0) and (PostedDimSetEntry.Next = 0);
        exit(true);
    end;

    local procedure CreateDimSetEntryFromDimValue(DimValue: Record "Dimension Value";var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDimSetEntry."Dimension Code" := DimValue."Dimension Code";
        TempDimSetEntry."Dimension Value Code" := DimValue.Code;
        TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
        TempDimSetEntry.Insert;
    end;


    procedure CreateDimSetIDFromICDocDim(var ICDocDim: Record "IC Document Dimension"): Integer
    var
        DimValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if ICDocDim.Find('-') then
          repeat
            DimValue.Get(
              ConvertICDimtoDim(ICDocDim."Dimension Code"),
              ConvertICDimValuetoDimValue(ICDocDim."Dimension Code",ICDocDim."Dimension Value Code"));
            CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
          until ICDocDim.Next = 0;
        exit(GetDimensionSetID(TempDimSetEntry));
    end;


    procedure CreateDimSetIDFromICJnlLineDim(var ICInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim."): Integer
    var
        DimValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if ICInboxOutboxJnlLineDim.Find('-') then
          repeat
            DimValue.Get(
              ConvertICDimtoDim(ICInboxOutboxJnlLineDim."Dimension Code"),
              ConvertICDimValuetoDimValue(
                ICInboxOutboxJnlLineDim."Dimension Code",ICInboxOutboxJnlLineDim."Dimension Value Code"));
            CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
          until ICInboxOutboxJnlLineDim.Next = 0;
        exit(GetDimensionSetID(TempDimSetEntry));
    end;


    procedure CopyDimBufToDimSetEntry(var FromDimBuf: Record "Dimension Buffer";var DimSetEntry: Record "Dimension Set Entry")
    var
        DimValue: Record "Dimension Value";
    begin
        with FromDimBuf do
          if FindSet then
            repeat
              DimValue.Get("Dimension Code","Dimension Value Code");
              DimSetEntry."Dimension Code" := "Dimension Code";
              DimSetEntry."Dimension Value Code" := "Dimension Value Code";
              DimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
              DimSetEntry.Insert;
            until Next = 0;
    end;


    procedure CreateDimSetIDFromDimBuf(var DimBuf: Record "Dimension Buffer"): Integer
    var
        DimValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if DimBuf.FindSet then
          repeat
            DimValue.Get(DimBuf."Dimension Code",DimBuf."Dimension Value Code");
            CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
          until DimBuf.Next = 0;
        exit(GetDimensionSetID(TempDimSetEntry));
    end;


    procedure GetDimSetIDsForFilter(DimCode: Code[20];DimValueFilter: Text[250])
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        DimSetEntry2.SetFilter("Dimension Code",'%1',DimCode);
        DimSetEntry2.SetFilter("Dimension Value Code",DimValueFilter);
        if DimSetEntry2.FindSet then
          repeat
            AddDimSetIDtoTempEntry(TempDimSetEntry2,DimSetEntry2."Dimension Set ID");
          until DimSetEntry2.Next = 0;
        if FilterIncludesBlank(DimCode,DimValueFilter) then
          GetDimSetIDsForBlank(DimCode);
        DimSetFilterCtr += 1;
    end;

    local procedure GetDimSetIDsForBlank(DimCode: Code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimSetEntry2: Record "Dimension Set Entry";
        PrevDimSetID: Integer;
        i: Integer;
    begin
        AddDimSetIDtoTempEntry(TempDimSetEntry,0);
        for i := 1 to 2 do begin
          if i = 2 then
            DimSetEntry2.SetFilter("Dimension Code",'%1',DimCode);
          if DimSetEntry2.FindSet then begin
            PrevDimSetID := 0;
            repeat
              if DimSetEntry2."Dimension Set ID" <> PrevDimSetID then begin
                AddDimSetIDtoTempEntry(TempDimSetEntry,DimSetEntry2."Dimension Set ID");
                PrevDimSetID := DimSetEntry2."Dimension Set ID";
              end;
            until DimSetEntry2.Next = 0;
          end;
        end;
        TempDimSetEntry.SetFilter("Dimension Value ID",'%1',1);
        if TempDimSetEntry.FindSet then
          repeat
            AddDimSetIDtoTempEntry(TempDimSetEntry2,TempDimSetEntry."Dimension Set ID");
          until TempDimSetEntry.Next = 0;
    end;


    procedure GetNextDimSetFilterChunk(Length: Integer) DimSetFilterChunk: Text[1024]
    var
        EndLoop: Boolean;
    begin
        if Length > MaxStrLen(DimSetFilterChunk) then
          Length := MaxStrLen(DimSetFilterChunk);
        TempDimSetEntry2.SetFilter("Dimension Value ID",'%1',DimSetFilterCtr);
        TempDimSetEntry2.SetFilter("Dimension Set ID",'>%1',LastDimSetIDInFilter);
        if TempDimSetEntry2.FindSet then begin
          DimSetFilterChunk := Format(TempDimSetEntry2."Dimension Set ID");
          LastDimSetIDInFilter := TempDimSetEntry2."Dimension Set ID";
          while (StrLen(DimSetFilterChunk) < Length) and (not EndLoop) do begin
            if TempDimSetEntry2.Next <> 0 then begin
              if StrLen(DimSetFilterChunk + '|' + Format(TempDimSetEntry2."Dimension Set ID")) <= Length then begin
                DimSetFilterChunk += '|' + Format(TempDimSetEntry2."Dimension Set ID");
                LastDimSetIDInFilter := TempDimSetEntry2."Dimension Set ID";
              end else
                EndLoop := true;
            end else
              EndLoop := true;
          end;
        end;
    end;

    local procedure FilterIncludesBlank(DimCode: Code[20];DimValueFilter: Text[250]): Boolean
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry.Insert;
        TempDimSetEntry.SetFilter("Dimension Value Code",DimValueFilter);
        exit(not TempDimSetEntry.IsEmpty);
    end;

    local procedure AddDimSetIDtoTempEntry(var TempDimSetEntry: Record "Dimension Set Entry" temporary;DimSetID: Integer)
    begin
        if TempDimSetEntry.Get(DimSetID,'') then begin
          TempDimSetEntry."Dimension Value ID" += 1;
          TempDimSetEntry.Modify;
        end else begin
          TempDimSetEntry."Dimension Set ID" := DimSetID;
          TempDimSetEntry."Dimension Value ID" := 1;
          TempDimSetEntry.Insert
        end;
    end;


    procedure ClearDimSetFilter()
    begin
        TempDimSetEntry2.Reset;
        TempDimSetEntry2.DeleteAll;
        DimSetFilterCtr := 0;
        LastDimSetIDInFilter := 0;
    end;


    procedure GetTempDimSetEntry(var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDimSetEntry.Copy(TempDimSetEntry2,true);
    end;

    local procedure UpdateCostType(DefaultDimension: Record "Default Dimension";CallingTrigger: Option OnInsert,OnModify,OnDelete)
    var
        GLAcc: Record "G/L Account";
        CostAccSetup: Record "Cost Accounting Setup";
        CostAccMgt: Codeunit "Cost Account Mgt";
    begin
        if CostAccSetup.Get and (DefaultDimension."Table ID" = Database::"G/L Account") then
          if GLAcc.Get(DefaultDimension."No.") then
            CostAccMgt.UpdateCostTypeFromDefaultDimension(DefaultDimension,GLAcc,CallingTrigger);
    end;


    procedure CreateDimSetFromJobTaskDim(JobNo: Code[20];JobTaskNo: Code[20];var GlobalDimVal1: Code[20];var GlobalDimVal2: Code[20]) NewDimSetID: Integer
    var
        JobTaskDimension: Record "Job Task Dimension";
        DimValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        with JobTaskDimension do begin
          SetRange("Job No.",JobNo);
          SetRange("Job Task No.",JobTaskNo);
          if FindSet then begin
            repeat
              DimValue.Get("Dimension Code","Dimension Value Code");
              TempDimSetEntry."Dimension Code" := "Dimension Code";
              TempDimSetEntry."Dimension Value Code" := "Dimension Value Code";
              TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
              TempDimSetEntry.Insert(true);
            until Next = 0;
            NewDimSetID := GetDimensionSetID(TempDimSetEntry);
            UpdateGlobalDimFromDimSetID(NewDimSetID,GlobalDimVal1,GlobalDimVal2);
          end;
        end;
    end;


    procedure UpdateGenJnlLineDim(var GenJnlLine: Record "Gen. Journal Line";DimSetID: Integer)
    begin
        GenJnlLine."Dimension Set ID" := DimSetID;
        UpdateGlobalDimFromDimSetID(
          GenJnlLine."Dimension Set ID",
          GenJnlLine."Shortcut Dimension 1 Code",GenJnlLine."Shortcut Dimension 2 Code");
    end;


    procedure UpdateGenJnlLineDimFromCustLedgEntry(var GenJnlLine: Record "Gen. Journal Line";DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if DtldCustLedgEntry."Cust. Ledger Entry No." <> 0 then begin
          CustLedgEntry.Get(DtldCustLedgEntry."Cust. Ledger Entry No.");
          UpdateGenJnlLineDim(GenJnlLine,CustLedgEntry."Dimension Set ID");
        end;
    end;


    procedure UpdateGenJnlLineDimFromVendLedgEntry(var GenJnlLine: Record "Gen. Journal Line";DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        if DtldVendLedgEntry."Vendor Ledger Entry No." <> 0 then begin
          VendLedgEntry.Get(DtldVendLedgEntry."Vendor Ledger Entry No.");
          UpdateGenJnlLineDim(GenJnlLine,VendLedgEntry."Dimension Set ID");
        end;
    end;


    procedure GetDimSetEntryDefaultDim(var DimSetEntry2: Record "Dimension Set Entry")
    var
        DimValue: Record "Dimension Value";
    begin
        if not DimSetEntry2.IsEmpty then
          DimSetEntry2.DeleteAll;
        if TempDimBuf2.FindSet then
          repeat
            DimValue.Get(TempDimBuf2."Dimension Code",TempDimBuf2."Dimension Value Code");
            DimSetEntry2."Dimension Code" := TempDimBuf2."Dimension Code";
            DimSetEntry2."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
            DimSetEntry2."Dimension Value ID" := DimValue."Dimension Value ID";
            DimSetEntry2.Insert;
          until TempDimBuf2.Next = 0;
        TempDimBuf2.Reset;
        TempDimBuf2.DeleteAll;
    end;

    local procedure InsertObject(var TempAllObjWithCaption: Record AllObjWithCaption temporary;TableID: Integer)
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type",AllObjWithCaption."object type"::Table);
        AllObjWithCaption.SetRange("Object ID",TableID);
        if AllObjWithCaption.FindFirst then begin
          TempAllObjWithCaption := AllObjWithCaption;
          TempAllObjWithCaption.Insert;
        end;
    end;


    procedure GetConsolidatedDimFilterByDimFilter(var Dimension: Record Dimension;DimFilter: Text) ConsolidatedDimFilter: Text
    begin
        Dimension.SetFilter("Consolidation Code",DimFilter);
        ConsolidatedDimFilter += DimFilter;
        if Dimension.FindSet then
          repeat
            ConsolidatedDimFilter += '|' + Dimension.Code;
          until Dimension.Next = 0;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    begin
    end;
}

