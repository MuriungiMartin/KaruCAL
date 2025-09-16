#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1100 "Cost Account Mgt"
{
    Permissions = TableData "G/L Account"=rm,
                  TableData "G/L Entry"=rm,
                  TableData "Cost Entry"=rimd,
                  TableData "Cost Center"=r,
                  TableData "Cost Object"=r;

    trigger OnRun()
    begin
    end;

    var
        CostAccSetup: Record "Cost Accounting Setup";
        GLAcc: Record "G/L Account";
        CostType: Record "Cost Type";
        Window: Dialog;
        i: Integer;
        NoOfCostTypes: Integer;
        NoOfGLAcc: Integer;
        RecsProcessed: Integer;
        RecsCreated: Integer;
        CostTypeExists: Boolean;
        Text000: label 'This function transfers all income statement accounts from the chart of accounts to the chart of cost types.\\All types including Heading, Begin-Total, and End-Total are transferred.\General ledger accounts that have the same number as an existing cost type are not transferred.\\Do you want to start the job?';
        Text001: label 'Indent %1?';
        Text002: label 'Create cost types:\Number                         #1########';
        Text003: label '%1 income statement accounts processed. %2 cost types created.';
        Text004: label 'Indent chart of cost types\Number                 #1########';
        Text005: label 'End-Total %1 does not belong to the corresponding Begin-Total.';
        Text006: label 'This function registers the cost types in the chart of accounts.\\This creates the link between chart of accounts and cost types and verifies that each income statement account is only linked to a cost type.\\Start job?';
        Text007: label '%1 cost types are processed and logged in %2 G/L accounts.';
        Text008: label 'Check assignment cost type - G/L account\Number   #1########';
        Text009: label 'Cost type %1 should be assigned to G/L account %2.\Cost type %3 is already linked to G/L account %2.\\Each G/L account can only be linked to a single cost type.\However, it is possible to link multiple G/L accounts to a single cost type.';
        Text010: label 'Indenting chart\Number                            #1########';
        Text011: label 'End-Total %1 does not belong to Begin-Total.';
        Text012: label 'The range is too long and cannot be transferred to the End-Total field.\\Move End-Total closer to Begin-Total or use shorter codes.';
        Text013: label '%1 %2 is not defined in Cost Accounting.', Comment='%1=Table caption Cost Center;%2=Field Value Cost Center Code';
        Text014: label '%1 %2 is blocked in Cost Accounting.', Comment='%1=Table caption Cost Center;%2=Field Value Cost Center Code';
        Text015: label '%1 %2 does not have line type %1 or Begin-Total.', Comment='%1=Table caption Cost Center;%2=Field Value Cost Center Code';
        Text016: label 'Do you want to create %1 %2 in Cost Accounting?', Comment='%1=Table caption Cost Center or Cost Object;%2=Field Value';
        Text017: label '%1 %2 has been updated in Cost Accounting.', Comment='%1=Table caption Cost Center or Cost Object or Cost Type;%2=Field Value';
        Text018: label 'Create dimension\Number                           #1########';
        Text019: label '%1 cost centers created.';
        Text020: label '%1 cost objects created.';
        Text021: label 'Do you want to get cost centers from dimension %1 ?';
        Text022: label 'Do you want to get cost objects from dimension %1 ?';
        Text023: label 'The %1 %2 cannot be inserted because it already exists as %3.', Comment='%1=Table caption Cost Center or Cost Object or Cost Type or Dimension Value;%2=Field Value';
        Text024: label 'Do you want to update %1 %2 in Cost Accounting?', Comment='%1=Table caption Cost Center or Cost Object;%2=Field Value';
        Text025: label 'The %1 cannot be updated with this %2 because the %3 does not fall within the From/To range.', Comment='%1=Cost Budget Register tablecaption,%2=Cost Budget Entry tablecaption,%3=Entry No. fieldcaption';


    procedure GetCostTypesFromChartOfAccount()
    begin
        if not Confirm(Text000,true) then
          Error('');

        GetCostTypesFromChartDirect;

        IndentCostTypes(true);

        Message(Text003,NoOfGLAcc,RecsCreated)
    end;


    procedure GetCostTypesFromChartDirect()
    begin
        NoOfGLAcc := 0;
        RecsCreated := 0;
        Window.Open(Text002);

        with GLAcc do begin
          Reset;
          SetRange("Income/Balance","income/balance"::"Income Statement");
          if Find('-') then
            repeat
              GetCostType("No.",CostTypeExists);
              Window.Update(1,"No.");
              NoOfGLAcc := NoOfGLAcc + 1;

              CostType.Init;
              CostType."No." := "No.";
              CostType.Name := Name;
              CostType."Search Name" := "Search Name";
              CostType.Type := "Account Type";
              CostType.Blocked := "Account Type" <> "account type"::Posting;
              CostType."Cost Center Code" := GetCostCenterCodeFromDefDim(Database::"G/L Account","No.");
              if not CostCenterExists(CostType."Cost Center Code") then
                CostType."Cost Center Code" := '';
              CostType."Cost Object Code" := GetCostObjectCodeFromDefDim(Database::"G/L Account","No.");
              if not CostObjectExists(CostType."Cost Object Code") then
                CostType."Cost Object Code" := '';
              CostType."New Page" := "New Page";
              if "No. of Blank Lines" > 0 then
                CostType."Blank Line" := true;
              CostType.Totaling := Totaling;
              CostType."Modified Date" := Today;
              if "Account Type" = "account type"::Posting then
                CostType."G/L Account Range" := "No."
              else
                CostType."G/L Account Range" := '';
              if not CostTypeExists then
                if CostType.Insert then begin
                  RecsCreated := RecsCreated + 1;
                  "Cost Type No." := "No.";
                end;
              Modify;
            until Next = 0;
          Window.Close;
        end;

        IndentCostTypes(true);
    end;


    procedure ConfirmUpdate(CallingTrigger: Option OnInsert,OnModify,,OnRename;TableCaption: Text[80];Value: Code[20]): Boolean
    begin
        if CallingTrigger = Callingtrigger::OnInsert then
          exit(Confirm(Text016,true,TableCaption,Value));
        exit(Confirm(Text024,true,TableCaption,Value));
    end;

    local procedure CanUpdate(Alignment: Option;NoAligment: Option;PromptAlignment: Option;DimValue: Record "Dimension Value";DimensionCode: Code[20];CallingTrigger: Option;TableCaption: Text[80]): Boolean
    begin
        if DimValue."Dimension Code" <> DimensionCode then
          exit(false);
        if DimValue."Dimension Value Type" in
           [DimValue."dimension value type"::"Begin-Total",DimValue."dimension value type"::"End-Total"]
        then
          exit(false);
        case Alignment of
          NoAligment:
            exit(false);
          PromptAlignment:
            if not ConfirmUpdate(CallingTrigger,TableCaption,DimValue.Code) then
              exit(false);
        end;
        exit(true);
    end;


    procedure UpdateCostTypeFromGLAcc(var GLAcc: Record "G/L Account";var xGLAcc: Record "G/L Account";CallingTrigger: Option OnInsert,OnModify,,OnRename)
    var
        UpdateCostType: Boolean;
    begin
        if GLAcc."Income/Balance" <> GLAcc."income/balance"::"Income Statement" then
          exit;

        if (CallingTrigger = Callingtrigger::OnModify) and (Format(GLAcc) = Format(xGLAcc)) then
          exit;

        if not CostAccSetup.Get then
          exit;

        if CostType.Get(GLAcc."No.") and (GLAcc."Cost Type No." = '') then
          exit;

        if not CheckAlignment(GLAcc,CallingTrigger) then
          exit;

        case CallingTrigger of
          Callingtrigger::OnInsert,Callingtrigger::OnModify:
            with GLAcc do begin
              if CostType.Get("Cost Type No.") then
                UpdateCostType := IsGLAccNoFirstFromRange(CostType,"No.")
              else begin
                CostType."No." := "No.";
                UpdateCostType := CostType.Insert;
              end;

              if UpdateCostType then begin
                CostType.Name := Name;
                CostType."Search Name" := "Search Name";
                CostType.Type := "Account Type";
                CostType.Blocked := "Account Type" <> "account type"::Posting;
                CostType."Cost Center Code" := GetCostCenterCodeFromDefDim(Database::"G/L Account","No.");
                if not CostCenterExists(CostType."Cost Center Code") then
                  CostType."Cost Center Code" := '';
                CostType."Cost Object Code" := GetCostObjectCodeFromDefDim(Database::"G/L Account","No.");
                if not CostObjectExists(CostType."Cost Object Code") then
                  CostType."Cost Object Code" := '';
                CostType."New Page" := "New Page";
                CostType."Blank Line" := "No. of Blank Lines" > 0;
                CostType.Totaling := Totaling;
                CostType."Modified Date" := Today;
                if "Account Type" = "account type"::Posting then
                  CostType."G/L Account Range" := "No."
                else
                  CostType."G/L Account Range" := '';

                CostType.Modify;
                "Cost Type No." := CostType."No.";
              end;
            end;
          Callingtrigger::OnRename:
            begin
              if CostType.Get(GLAcc."No.") then
                Error(Text023,GLAcc.TableCaption,GLAcc."No.",CostType.TableCaption);
              if CostType.Get(xGLAcc."No.") then begin
                CostType.Rename(GLAcc."No.");
                CostType."G/L Account Range" := GLAcc."No.";
                CostType.Modify;
                GLAcc."Cost Type No." := GLAcc."No.";
              end else
                exit;
            end;
        end;
        IndentCostTypes(false);
        Message(Text017,CostType.TableCaption,GLAcc."No.");
    end;


    procedure UpdateCostCenterFromDim(var DimValue: Record "Dimension Value";var xDimValue: Record "Dimension Value";CallingTrigger: Option OnInsert,OnModify,,OnRename)
    var
        CostCenter: Record "Cost Center";
    begin
        CostAccSetup.Get;
        if not CanUpdate(CostAccSetup."Align Cost Center Dimension",CostAccSetup."align cost center dimension"::"No Alignment",
             CostAccSetup."align cost center dimension"::Prompt,DimValue,CostAccSetup."Cost Center Dimension",CallingTrigger,
             CostCenter.TableCaption)
        then
          exit;

        case CallingTrigger of
          Callingtrigger::OnInsert:
            begin
              if CostCenterExists(DimValue.Code) then
                Error(Text023,CostCenter.TableCaption,DimValue.Code,CostCenter.TableCaption);
              InsertCostCenterFromDimValue(DimValue);
            end;
          Callingtrigger::OnModify:
            begin
              if not CostCenterExists(DimValue.Code) then
                InsertCostCenterFromDimValue(DimValue)
              else
                ModifyCostCenterFromDimValue(DimValue);
            end;
          Callingtrigger::OnRename:
            begin
              if not CostCenterExists(xDimValue.Code) then
                exit;
              if CostCenterExists(DimValue.Code) then
                Error(Text023,DimValue.TableCaption,DimValue.Code,CostCenter.TableCaption);
              CostCenter.Get(xDimValue.Code);
              CostCenter.Rename(DimValue.Code);
            end;
        end;

        IndentCostCenters;
        Message(Text017,CostCenter.TableCaption,DimValue.Code);
    end;


    procedure UpdateCostObjectFromDim(var DimValue: Record "Dimension Value";var xDimValue: Record "Dimension Value";CallingTrigger: Option OnInsert,OnModify,,OnRename)
    var
        CostObject: Record "Cost Object";
    begin
        CostAccSetup.Get;
        if not CanUpdate(CostAccSetup."Align Cost Object Dimension",CostAccSetup."align cost object dimension"::"No Alignment",
             CostAccSetup."align cost object dimension"::Prompt,DimValue,CostAccSetup."Cost Object Dimension",CallingTrigger,
             CostObject.TableCaption)
        then
          exit;

        case CallingTrigger of
          Callingtrigger::OnInsert:
            begin
              if CostObjectExists(DimValue.Code) then
                Error(Text023,CostObject.TableCaption,DimValue.Code,CostObject.TableCaption);
              InsertCostObjectFromDimValue(DimValue);
            end;
          Callingtrigger::OnModify:
            begin
              if not CostObjectExists(DimValue.Code) then
                InsertCostObjectFromDimValue(DimValue)
              else
                ModifyCostObjectFromDimValue(DimValue);
            end;
          Callingtrigger::OnRename:
            begin
              if not CostObjectExists(xDimValue.Code) then
                exit;
              if CostObjectExists(DimValue.Code) then
                Error(Text023,DimValue.TableCaption,DimValue.Code,CostObject.TableCaption);
              CostObject.Get(xDimValue.Code);
              CostObject.Rename(DimValue.Code);
            end;
        end;

        IndentCostCenters;
        Message(Text017,CostObject.TableCaption,DimValue.Code);
    end;


    procedure UpdateCostTypeFromDefaultDimension(var DefaultDim: Record "Default Dimension";var GLAcc: Record "G/L Account";CallingTrigger: Option OnInsert,OnModify,OnDelete)
    var
        CostType: Record "Cost Type";
    begin
        CostAccSetup.Get;

        with GLAcc do
          if CostType.Get("Cost Type No.") then begin
            if not IsGLAccNoFirstFromRange(CostType,"No.") then
              exit;
            if not CheckAlignment(GLAcc,Callingtrigger::OnModify) then
              exit;

            if CostAccSetup."Cost Center Dimension" = DefaultDim."Dimension Code" then
              if CostCenterExists(DefaultDim."Dimension Value Code") and not (CallingTrigger = Callingtrigger::OnDelete) then
                CostType."Cost Center Code" := DefaultDim."Dimension Value Code"
              else
                CostType."Cost Center Code" := '';

            if CostAccSetup."Cost Object Dimension" = DefaultDim."Dimension Code" then
              if CostObjectExists(DefaultDim."Dimension Value Code") and not (CallingTrigger = Callingtrigger::OnDelete) then
                CostType."Cost Object Code" := DefaultDim."Dimension Value Code"
              else
                CostType."Cost Object Code" := '';

            CostType.Modify;
          end;
    end;


    procedure ConfirmIndentCostTypes()
    begin
        if not Confirm(Text001,true,CostType.TableCaption) then
          Error('');

        IndentCostTypes(true);
    end;


    procedure IndentCostTypes(ShowMessage: Boolean)
    var
        CostTypeNo: array [10] of Code[20];
    begin
        i := 0;
        if ShowMessage then
          Window.Open(Text004);

        with CostType do begin
          if Find('-') then
            repeat
              if ShowMessage then
                Window.Update(1,"No.");
              if Type = Type::"End-Total" then begin
                if i < 1 then
                  Error(Text005,"No.");
                Totaling := CostTypeNo[i] + '..' + "No.";
                i := i - 1;
              end;
              Indentation := i;
              Modify;
              if Type = Type::"Begin-Total" then begin
                i := i + 1;
                CostTypeNo[i] := "No.";
              end;
            until Next = 0;
        end;

        if ShowMessage then
          Window.Close;
    end;


    procedure LinkCostTypesToGLAccountsYN()
    begin
        if not Confirm(Text006,true) then
          Error('');

        ClearAll;
        LinkCostTypesToGLAccounts;
        Message(Text007,NoOfCostTypes,NoOfGLAcc);
    end;


    procedure LinkCostTypesToGLAccounts()
    begin
        Window.Open(Text008);

        GLAcc.Reset;
        CostType.Reset;
        GLAcc.ModifyAll("Cost Type No.",'');
        CostType.SetRange(Type,CostType.Type::"Cost Type");
        CostType.SetFilter("G/L Account Range",'<>%1','');
        if CostType.FindSet then
          repeat
            Window.Update(1,CostType."No.");
            NoOfCostTypes := NoOfCostTypes + 1;
            GLAcc.SetFilter("No.",CostType."G/L Account Range");
            GLAcc.SetRange("Income/Balance",GLAcc."income/balance"::"Income Statement");
            if GLAcc.FindSet then
              repeat
                if GLAcc."Cost Type No." <> '' then begin
                  Window.Close;
                  Error(Text009,CostType."No.",GLAcc."No.",GLAcc."Cost Type No.");
                end;
                GLAcc."Cost Type No." := CostType."No.";
                NoOfGLAcc := NoOfGLAcc + 1;
                GLAcc.Modify;
              until GLAcc.Next = 0;
          until CostType.Next = 0;

        Window.Close;
    end;


    procedure CreateCostCenters()
    var
        CostCenter: Record "Cost Center";
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        if not Confirm(Text021,true,CostAccSetup."Cost Center Dimension") then
          Error('');

        RecsProcessed := 0;
        RecsCreated := 0;
        Window.Open(Text018);

        with CostCenter do begin
          Reset;
          DimValue.SetRange("Dimension Code",CostAccSetup."Cost Center Dimension");
          if DimValue.Find('-') then begin
            repeat
              Window.Update(1,Code);
              if InsertCostCenterFromDimValue(DimValue) then
                RecsProcessed := RecsProcessed + 1;
            until DimValue.Next = 0;
            Window.Close;
          end;
        end;

        IndentCostCenters;

        Message(Text019,RecsProcessed);
    end;


    procedure IndentCostCentersYN()
    var
        CostCenter: Record "Cost Center";
    begin
        if not Confirm(Text001,true,CostCenter.TableCaption) then
          Error('');

        IndentCostCenters;
    end;


    procedure IndentCostCenters()
    var
        CostCenter: Record "Cost Center";
        CostCenterRange: Code[250];
        StartRange: array [10] of Code[20];
        SpecialSort: Boolean;
    begin
        SpecialSort := false;
        i := 0;

        Window.Open(Text010);

        with CostCenter do begin
          SetCurrentkey("Sorting Order");
          SetFilter("Sorting Order",'<>%1','');
          if Find('-') then
            SpecialSort := true;

          Reset;
          if SpecialSort then begin
            SetCurrentkey("Sorting Order");
            if FindSet then
              repeat
                if "Line Type" = "line type"::"End-Total" then begin
                  Totaling := CostCenterRange;
                  if i < 1 then
                    Error(Text011,Code);
                  i := i - 1;
                end;
                Indentation := i;
                Modify;
                if "Line Type" = "line type"::"Begin-Total" then begin
                  CostCenterRange := '';
                  i := i + 1;
                end;
                if (("Line Type" = "line type"::"Cost Center") and (i = 1)) or
                   ("Line Type" = "line type"::"Begin-Total")
                then begin
                  if StrLen(CostCenterRange) + StrLen(Code) > MaxStrLen(CostCenterRange) then
                    Error(Text012);
                  if CostCenterRange = '' then
                    CostCenterRange := Code
                  else
                    CostCenterRange := CostCenterRange + '|' + Code;
                end;
              until Next = 0;
          end else begin
            SetCurrentkey(Code);
            if FindSet then
              repeat
                Window.Update(1,Code);

                if "Line Type" = "line type"::"End-Total" then begin
                  if i < 1 then
                    Error(Text005,Code);
                  Totaling := StartRange[i] + '..' + Code;
                  i := i - 1;
                end;
                Indentation := i;
                Modify;
                if "Line Type" = "line type"::"Begin-Total" then begin
                  i := i + 1;
                  StartRange[i] := Code;
                end;
              until Next = 0;
          end;
        end;
        Window.Close;
    end;


    procedure CreateCostObjects()
    var
        CostObject: Record "Cost Object";
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        if not Confirm(Text022,true,CostAccSetup."Cost Object Dimension") then
          Error('');

        RecsProcessed := 0;
        RecsCreated := 0;
        Window.Open(Text018);

        with CostObject do begin
          Reset;
          DimValue.SetRange("Dimension Code",CostAccSetup."Cost Object Dimension");
          if DimValue.Find('-') then begin
            repeat
              Window.Update(1,Code);
              if InsertCostObjectFromDimValue(DimValue) then
                RecsProcessed := RecsProcessed + 1;
            until DimValue.Next = 0;
            Window.Close;
          end;
        end;

        IndentCostObjects;
        Message(Text020,RecsProcessed);
    end;


    procedure IndentCostObjectsYN()
    var
        CostObject: Record "Cost Object";
    begin
        if not Confirm(Text001,true,CostObject.TableCaption) then
          Error('');

        IndentCostObjects;
    end;


    procedure IndentCostObjects()
    var
        CostObject: Record "Cost Object";
        CostObjRange: Code[250];
        StartRange: array [10] of Code[20];
        SpecialSort: Boolean;
    begin
        SpecialSort := false;
        i := 0;

        Window.Open(Text010);

        with CostObject do begin
          SetCurrentkey("Sorting Order");
          SetFilter("Sorting Order",'<>%1','');
          if Find('-') then
            SpecialSort := true;

          Reset;
          if SpecialSort then begin
            SetCurrentkey("Sorting Order");
            if FindSet then
              repeat
                if "Line Type" = "line type"::"End-Total" then begin
                  Totaling := CostObjRange;
                  if i < 1 then
                    Error(Text011,Code);
                  i := i - 1;
                end;
                Indentation := i;
                Modify;
                if "Line Type" = "line type"::"Begin-Total" then begin
                  CostObjRange := '';
                  i := i + 1;
                end;

                if (("Line Type" = "line type"::"Cost Object") and (i = 1)) or
                   ("Line Type" = "line type"::"Begin-Total")
                then begin
                  if StrLen(CostObjRange) + StrLen(Code) > MaxStrLen(CostObjRange) then
                    Error(Text012);

                  if CostObjRange = '' then
                    CostObjRange := Code
                  else
                    CostObjRange := CostObjRange + '|' + Code;
                end;
              until Next = 0;
          end else begin
            SetCurrentkey(Code);
            if Find('-') then
              repeat
                Window.Update(1,Code);
                if "Line Type" = "line type"::"End-Total" then begin
                  if i < 1 then
                    Error(Text005,Code);
                  Totaling := StartRange[i] + '..' + Code;
                  i := i - 1;
                end;
                Indentation := i;
                Modify;

                if "Line Type" = "line type"::"Begin-Total" then begin
                  i := i + 1;
                  StartRange[i] := Code;
                end;
              until Next = 0;
          end;
        end;
        Window.Close;
    end;


    procedure CheckValidCCAndCOInGLEntry(DimSetID: Integer)
    var
        CostCenter: Record "Cost Center";
        CostObject: Record "Cost Object";
        CostCenterCode: Code[20];
        CostObjectCode: Code[20];
    begin
        if not CostAccSetup.Get then
          exit;
        if not CostAccSetup."Check G/L Postings" then
          exit;

        CostCenterCode := GetCostCenterCodeFromDimSet(DimSetID);
        CostObjectCode := GetCostObjectCodeFromDimSet(DimSetID);

        if CostCenterCode <> '' then begin
          if not CostCenter.Get(CostCenterCode) then
            Error(Text013,CostCenter.TableCaption,CostCenterCode);
          if CostCenter.Blocked then
            Error(Text014,CostCenter.TableCaption,CostCenterCode);
          if not (CostCenter."Line Type" in [CostCenter."line type"::"Cost Center",CostCenter."line type"::"Begin-Total"]) then
            Error(Text015,CostCenter.TableCaption,CostCenterCode);
        end;

        if CostObjectCode <> '' then begin
          if not CostObject.Get(CostObjectCode) then
            Error(Text013,CostObject.TableCaption,CostObjectCode);
          if CostObject.Blocked then
            Error(Text014,CostObject.TableCaption,CostObjectCode);
          if not (CostObject."Line Type" in [CostObject."line type"::"Cost Object",CostObject."line type"::"Begin-Total"]) then
            Error(Text015,CostObject.TableCaption,CostObjectCode);
        end;
    end;


    procedure GetCostCenterCodeFromDimSet(DimSetID: Integer): Code[20]
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        CostAccSetup.Get;
        if DimSetEntry.Get(DimSetID,CostAccSetup."Cost Center Dimension") then
          exit(DimSetEntry."Dimension Value Code");
        exit('');
    end;


    procedure GetCostCenterCodeFromDefDim(TableID: Integer;No: Code[20]): Code[20]
    var
        DefaultDim: Record "Default Dimension";
    begin
        CostAccSetup.Get;
        if DefaultDim.Get(TableID,No,CostAccSetup."Cost Center Dimension") then
          exit(DefaultDim."Dimension Value Code");
    end;


    procedure CostCenterExists(CostCenterCode: Code[20]): Boolean
    var
        CostCenter: Record "Cost Center";
    begin
        exit(CostCenter.Get(CostCenterCode));
    end;


    procedure CostCenterExistsAsDimValue(CostCenterCode: Code[20]): Boolean
    var
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        exit(DimValue.Get(CostAccSetup."Cost Center Dimension",CostCenterCode));
    end;


    procedure LookupCostCenterFromDimValue(var CostCenterCode: Code[20])
    var
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        DimValue.LookupDimValue(CostAccSetup."Cost Center Dimension",CostCenterCode);
    end;


    procedure GetCostObjectCodeFromDimSet(DimSetID: Integer): Code[20]
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        CostAccSetup.Get;
        if DimSetEntry.Get(DimSetID,CostAccSetup."Cost Object Dimension") then
          exit(DimSetEntry."Dimension Value Code");
        exit('');
    end;


    procedure GetCostObjectCodeFromDefDim(TableID: Integer;No: Code[20]): Code[20]
    var
        DefaultDim: Record "Default Dimension";
    begin
        CostAccSetup.Get;
        if DefaultDim.Get(TableID,No,CostAccSetup."Cost Object Dimension") then
          exit(DefaultDim."Dimension Value Code");
    end;


    procedure CostObjectExists(CostObjectCode: Code[20]): Boolean
    var
        CostObject: Record "Cost Object";
    begin
        exit(CostObject.Get(CostObjectCode));
    end;


    procedure CostObjectExistsAsDimValue(CostObjectCode: Code[20]): Boolean
    var
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        exit(DimValue.Get(CostAccSetup."Cost Object Dimension",CostObjectCode));
    end;


    procedure LookupCostObjectFromDimValue(var COstObjectCode: Code[20])
    var
        DimValue: Record "Dimension Value";
    begin
        CostAccSetup.Get;
        DimValue.LookupDimValue(CostAccSetup."Cost Object Dimension",COstObjectCode);
    end;

    local procedure InsertCostCenterFromDimValue(DimValue: Record "Dimension Value"): Boolean
    var
        CostCenter: Record "Cost Center";
    begin
        CopyDimValueToCostCenter(DimValue,CostCenter);
        exit(CostCenter.Insert);
    end;

    local procedure ModifyCostCenterFromDimValue(DimValue: Record "Dimension Value"): Boolean
    var
        CostCenter: Record "Cost Center";
    begin
        CostCenter.Get(DimValue.Code);
        CopyDimValueToCostCenter(DimValue,CostCenter);
        exit(CostCenter.Modify);
    end;

    local procedure CopyDimValueToCostCenter(DimValue: Record "Dimension Value";var CostCenter: Record "Cost Center")
    begin
        CostCenter.Init;
        CostCenter.Code := DimValue.Code;
        CostCenter.Name := DimValue.Name;
        CostCenter."Line Type" := DimValue."Dimension Value Type";
        CostCenter.Blocked := DimValue.Blocked;
    end;

    local procedure InsertCostObjectFromDimValue(DimValue: Record "Dimension Value"): Boolean
    var
        CostObject: Record "Cost Object";
    begin
        CopyDimValueToCostObject(DimValue,CostObject);
        exit(CostObject.Insert);
    end;

    local procedure ModifyCostObjectFromDimValue(DimValue: Record "Dimension Value"): Boolean
    var
        CostObject: Record "Cost Object";
    begin
        CostObject.Get(DimValue.Code);
        CopyDimValueToCostObject(DimValue,CostObject);
        exit(CostObject.Modify);
    end;

    local procedure CopyDimValueToCostObject(DimValue: Record "Dimension Value";var CostObject: Record "Cost Object")
    begin
        CostObject.Init;
        CostObject.Code := DimValue.Code;
        CostObject.Name := DimValue.Name;
        CostObject."Line Type" := DimValue."Dimension Value Type";
        CostObject.Blocked := DimValue.Blocked;
    end;


    procedure InsertCostBudgetRegister(CostBudgetEntryNo: Integer;CostBudgetName: Code[10];CostBudgetAmount: Decimal): Integer
    var
        CostBudgetReg: Record "Cost Budget Register";
    begin
        CostBudgetReg.LockTable;
        if CostBudgetReg.FindLast then
          CostBudgetReg."No." := CostBudgetReg."No." + 1
        else
          CostBudgetReg."No." := 1;
        CostBudgetReg.Init;
        CostBudgetReg.Source := CostBudgetReg.Source::Manual;
        CostBudgetReg."From Cost Budget Entry No." := CostBudgetEntryNo;
        CostBudgetReg."To Cost Budget Entry No." := CostBudgetEntryNo;
        CostBudgetReg."No. of Entries" := 1;
        CostBudgetReg."Cost Budget Name" := CostBudgetName;
        CostBudgetReg.Amount := CostBudgetAmount;
        CostBudgetReg."Processed Date" := Today;
        CostBudgetReg."User ID" := UserId;
        CostBudgetReg.Insert;

        exit(CostBudgetReg."No.");
    end;


    procedure UpdateCostBudgetRegister(CostBudgetRegNo: Integer;CostBudgetEntryNo: Integer;CostBudgetAmount: Decimal)
    var
        CostBudgetReg: Record "Cost Budget Register";
        CostBudgetEntry: Record "Cost Budget Entry";
    begin
        if CostBudgetRegNo = 0 then begin
          CostBudgetReg.SetCurrentkey("From Cost Budget Entry No.","To Cost Budget Entry No.");
          CostBudgetReg.SetRange("From Cost Budget Entry No.",0,CostBudgetEntryNo);
          CostBudgetReg.SetFilter("To Cost Budget Entry No.",'%1..',CostBudgetEntryNo);
          CostBudgetReg.FindLast
        end else
          CostBudgetReg.Get(CostBudgetRegNo);

        if (CostBudgetEntryNo > CostBudgetReg."To Cost Budget Entry No." + 1) or
           (CostBudgetEntryNo < CostBudgetReg."From Cost Budget Entry No.")
        then
          Error(Text025,CostBudgetReg.TableCaption,CostBudgetEntry.TableCaption,CostBudgetEntry.FieldCaption("Entry No."));
        if CostBudgetEntryNo > CostBudgetReg."To Cost Budget Entry No." then begin
          CostBudgetReg."To Cost Budget Entry No." := CostBudgetEntryNo;
          CostBudgetReg."No. of Entries" := CostBudgetReg."To Cost Budget Entry No." - CostBudgetReg."From Cost Budget Entry No." + 1
        end;
        CostBudgetReg.Amount := CostBudgetReg.Amount + CostBudgetAmount;
        CostBudgetReg.Modify(true)
    end;

    local procedure CheckAlignment(var GLAcc: Record "G/L Account";CallingTrigger: Option): Boolean
    begin
        CostAccSetup.Get;

        if CostAccSetup."Align G/L Account" = CostAccSetup."align g/l account"::"No Alignment" then
          exit(false);

        if CostAccSetup."Align G/L Account" = CostAccSetup."align g/l account"::Prompt then
          if not ConfirmUpdate(CallingTrigger,CostType.TableCaption,GLAcc."No.") then
            exit(false);

        exit(true);
    end;


    procedure IsGLAccNoFirstFromRange(CostType: Record "Cost Type";GLAccNo: Code[20]): Boolean
    var
        GLAccCheck: Record "G/L Account";
    begin
        GLAccCheck.SetFilter("No.",CostType."G/L Account Range");
        if GLAccCheck.FindFirst then
          exit(GLAccNo = GLAccCheck."No.");

        exit(false);
    end;


    procedure GetCostType(GLAccNo: Code[20];var CostTypeExists: Boolean)
    var
        GLAcc: Record "G/L Account";
        CostType: Record "Cost Type";
    begin
        CostType.Reset;
        CostType.SetRange("No.",GLAccNo);
        if CostType.IsEmpty then begin
          CostTypeExists := false;
          CostType.Reset;
          CostType.SetRange(Type,CostType.Type::"Cost Type");
          CostType.SetFilter("G/L Account Range",'<>%1','');
          if CostType.FindSet then
            repeat
              GLAcc.Reset;
              GLAcc.SetRange("Income/Balance",GLAcc."income/balance"::"Income Statement");
              GLAcc.SetFilter("No.",CostType."G/L Account Range");
              if GLAcc.FindSet then
                repeat
                  if GLAccNo = GLAcc."No." then
                    CostTypeExists := true
                until (GLAcc.Next = 0) or CostTypeExists;
            until (CostType.Next = 0) or CostTypeExists;
        end;
    end;
}

