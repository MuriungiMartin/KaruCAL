#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1131 "Cost Allocation"
{
    Caption = 'Cost Allocation';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(CostAllocationSource;"Cost Allocation Source")
        {
            DataItemTableView = sorting(Level,"Valid From","Valid To","Cost Type Range") order(ascending);
            column(ReportForNavId_7485; 7485)
            {
            }
            dataitem(CostAllocationTarget;"Cost Allocation Target")
            {
                DataItemLink = ID=field(ID);
                DataItemTableView = sorting(ID,"Line No.") order(ascending);
                column(ReportForNavId_4986; 4986)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not AllocTargetErrorFound then
                      AllocTargetErrorFound := ("Target Cost Center" = '') and ("Target Cost Object" = '')
                    else
                      CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not AllocSourceErrorFound then
                  AllocSourceErrorFound := ("Cost Center Code" = '') and ("Cost Object Code" = '')
                else
                  CurrReport.Skip;
            end;

            trigger OnPostDataItem()
            begin
                if AllocSourceErrorFound or AllocTargetErrorFound then begin
                  ShowAllocations(not AllocSourceErrorFound);
                  CurrReport.Quit;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Level,FromLevel,ToLevel);
                SetRange(Variant,AllocVariant);
            end;
        }
        dataitem("Cost Allocation Source";"Cost Allocation Source")
        {
            DataItemTableView = sorting(Level,"Valid From","Valid To","Cost Type Range");
            column(ReportForNavId_1662; 1662)
            {
            }
            dataitem("Cost Entry";"Cost Entry")
            {
                DataItemTableView = sorting("Entry No.") order(ascending);
                column(ReportForNavId_5276; 5276)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SourceTotalAmount := SourceTotalAmount + Amount;
                    NoOfEntries := NoOfEntries + 1;
                    Window.Update(3,Format(NoOfEntries));
                end;

                trigger OnPostDataItem()
                begin
                    if CostRegister.FindLast then;
                    ModifyAll("Allocated with Journal No.",CostRegister."No." + 1);
                    ModifyAll(Allocated,true);
                end;

                trigger OnPreDataItem()
                begin
                    if AllocateBudget then
                      CurrReport.Break;

                    if "Cost Allocation Source"."Cost Center Code" <> '' then begin
                      SetCurrentkey("Cost Center Code","Cost Type No.",Allocated);
                      SetFilter("Cost Center Code","Cost Allocation Source"."Cost Center Code");
                    end else begin
                      SetCurrentkey("Cost Object Code","Cost Type No.",Allocated);
                      SetFilter("Cost Object Code","Cost Allocation Source"."Cost Object Code");
                    end;
                    SetFilter("Cost Type No.","Cost Allocation Source"."Cost Type Range");
                    SetRange(Allocated,false);
                    SetRange("Posting Date",0D,AllocDate);

                    SourceTotalAmount := 0;
                end;
            }
            dataitem("Cost Budget Entry";"Cost Budget Entry")
            {
                DataItemTableView = sorting("Entry No.") order(ascending);
                column(ReportForNavId_3233; 3233)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SourceTotalAmount := SourceTotalAmount + Amount;
                    NoOfEntries := NoOfEntries + 1;
                    Window.Update(3,Format(NoOfEntries));
                end;

                trigger OnPostDataItem()
                begin
                    if CostBudgetRegister.FindLast then;
                    ModifyAll("Allocated with Journal No.",CostBudgetRegister."No." + 1);
                    ModifyAll(Allocated,true);
                end;

                trigger OnPreDataItem()
                begin
                    if not AllocateBudget then
                      CurrReport.Break;

                    if "Cost Allocation Source"."Cost Center Code" <> '' then begin
                      SetCurrentkey("Budget Name","Cost Center Code","Cost Type No.",Allocated);
                      SetFilter("Cost Center Code","Cost Allocation Source"."Cost Center Code");
                    end else begin
                      SetCurrentkey("Budget Name","Cost Object Code","Cost Type No.",Allocated);
                      SetFilter("Cost Object Code","Cost Allocation Source"."Cost Object Code");
                    end;
                    SetRange("Budget Name",CostBudgetName.Name);
                    SetFilter("Cost Type No.","Cost Allocation Source"."Cost Type Range");
                    SetRange(Allocated,false);
                    SetRange(Date,0D,AllocDate);

                    SourceTotalAmount := 0;
                end;
            }
            dataitem("Cost Allocation Target";"Cost Allocation Target")
            {
                DataItemTableView = sorting(ID,"Line No.");
                column(ReportForNavId_9203; 9203)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    case "Allocation Target Type" of
                      "allocation target type"::"All Costs":
                        begin
                          ReminderAmount += SourceTotalAmount / 100 * Percent;
                          AllocAmount := ROUND(ReminderAmount,0.01);
                          ReminderAmount -= AllocAmount;
                          AllocRatio := StrSubstNo(Text010,
                              Share,"Cost Allocation Source"."Total Share",SourceTotalAmount);
                        end;
                      "allocation target type"::"Percent per Share":
                        begin
                          AllocAmount := ROUND(Share / 100 * "Percent per Share",0.01);
                          AllocRatio := StrSubstNo(Text011,
                              "Percent per Share",Share);
                        end;
                      "allocation target type"::"Amount per Share":
                        begin
                          AllocAmount := ROUND(Share * "Amount per Share",0.01);
                          AllocRatio := StrSubstNo(Text012,
                              "Amount per Share",Share);
                        end;
                    end;

                    if StrLen(AllocTargetText) < MaxStrLen(TempCostJnlLine.Description) then begin
                      if "Target Cost Center" <> '' then
                        AllocTargetText := AllocTargetText + "Target Cost Center" + ', '
                      else
                        AllocTargetText := AllocTargetText + "Target Cost Object" + ', ';
                    end;

                    AllocTotalAmount := AllocTotalAmount + AllocAmount;

                    WriteJournalLine("Target Cost Type","Target Cost Center","Target Cost Object",AllocAmount,
                      AllocSourceText,AllocRatio,"Cost Allocation Source".ID,false);
                end;

                trigger OnPostDataItem()
                begin
                    if StrLen(AllocTargetText) > MaxStrLen(TempCostJnlLine.Description) then
                      AllocTargetText := CopyStr(AllocTargetText,1,MaxStrLen(TempCostJnlLine.Description) - 10) + Text013;

                    AllocRatio := StrSubstNo(Text014,"Cost Allocation Source".Level,AllocDate);

                    WriteJournalLine("Cost Allocation Source"."Credit to Cost Type","Cost Allocation Source"."Cost Center Code",
                      "Cost Allocation Source"."Cost Object Code",-AllocTotalAmount,
                      AllocTargetText,AllocRatio,"Cost Allocation Source".ID,true);

                    CostAccSetup."Last Allocation Doc. No." := IncStr(CostAccSetup."Last Allocation Doc. No.");
                    CostAccSetup.Modify;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(ID,"Cost Allocation Source".ID);
                    "Cost Allocation Source".CalcFields("Total Share");
                    AllocTotalAmount := 0;
                    ReminderAmount := 0;

                    AllocSourceText := Text008;
                    if "Cost Allocation Source"."Cost Type Range" <> '' then
                      AllocSourceText := AllocSourceText + ' ' + "Cost Allocation Source"."Cost Type Range" + ' (' + Text017 + ')';
                    if "Cost Allocation Source"."Cost Center Code" <> '' then
                      AllocSourceText := AllocSourceText + ' ' + "Cost Allocation Source"."Cost Center Code" + ' (' + Text018 + ')';
                    if "Cost Allocation Source"."Cost Object Code" <> '' then
                      AllocSourceText := AllocSourceText + ' ' + "Cost Allocation Source"."Cost Object Code" + ' (' + Text019 + ')';

                    AllocTargetText := Text009;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if (LastLevel <> 0) and (Level > LastLevel) then begin
                  if EntriesPerLevel > 0 then
                    PostCostJournalLines;
                  LastCostJourLineNo := 0;
                  EntriesPerLevel := 0;
                end;

                LastLevel := Level;

                SourceTotalAmount := 0;
                Window.Update(1,Format(Level));
                Window.Update(2,Format(ID));
            end;

            trigger OnPostDataItem()
            begin
                if TotalEntries = 0 then
                  Error(Text006);

                if EntriesPerLevel > 0 then
                  PostCostJournalLines;

                Window.Close;
                if CurrReport.UseRequestPage then
                  Message(Text007,TotalEntries);
            end;

            trigger OnPreDataItem()
            begin
                "Cost Entry".LockTable;
                CostRegister.LockTable;
                CostBudgetRegister.LockTable;
                LockTable;
                "Cost Allocation Target".LockTable;
                "Cost Budget Entry".LockTable;

                CostAccSetup.Get;
                SourceCodeSetup.Get;
                SourceCodeSetup.TestField("Cost Allocation");

                if AllocDate = 0D then
                  Error(Text000);

                if FromLevel > ToLevel then
                  Error(Text001);

                if CostBudgetName.Name <> '' then begin
                  AllocateBudget := true;
                  MsgText := Text002 + ' ' + CostBudgetName.Name;
                end else
                  MsgText := Text003;

                if CurrReport.UseRequestPage then
                  if not Confirm(Text004,true,MsgText,FromLevel,ToLevel,AllocDate,AllocVariant) then
                    Error('');

                SetRange(Level,FromLevel,ToLevel);
                SetRange(Variant,AllocVariant);
                SetRange("Valid From",0D,AllocDate);
                SetFilter("Valid To",'%1|>=%2',0D,AllocDate);
                SetRange(Blocked,false);

                if AllocateBudget then
                  SetFilter("Allocation Source Type",'%1|%2',"allocation source type"::Both,"allocation source type"::Budget)
                else
                  SetRange("Allocation Source Type","allocation source type"::Both,"allocation source type"::Actual);

                Window.Open(Text005)
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("From Alloc. Level";FromLevel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Alloc. Level';
                        MaxValue = 99;
                        MinValue = 1;
                    }
                    field("To Alloc. Level";ToLevel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Alloc. Level';
                        MaxValue = 99;
                        MinValue = 1;
                    }
                    field("Allocation Date";AllocDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Allocation Date';
                    }
                    field(Group;AllocVariant)
                    {
                        ApplicationArea = Basic;
                        BlankZero = true;
                        Caption = 'Group';
                    }
                    field("Budget Name";CostBudgetName.Name)
                    {
                        ApplicationArea = Basic;
                        BlankZero = true;
                        Caption = 'Budget Name';
                        Lookup = true;
                        TableRelation = "Cost Budget Name";
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CostBudgetName.Init;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        InitializeRequest(1,99,WorkDate,'','');
    end;

    var
        CostRegister: Record "Cost Register";
        CostBudgetRegister: Record "Cost Budget Register";
        TempCostJnlLine: Record "Cost Journal Line" temporary;
        CostAccSetup: Record "Cost Accounting Setup";
        CostBudgetName: Record "Cost Budget Name";
        SourceCodeSetup: Record "Source Code Setup";
        Window: Dialog;
        FromLevel: Integer;
        ToLevel: Integer;
        AllocVariant: Code[10];
        LastLevel: Integer;
        NoOfEntries: Integer;
        EntriesPerLevel: Integer;
        TotalEntries: Integer;
        AllocDate: Date;
        SourceTotalAmount: Decimal;
        AllocAmount: Decimal;
        AllocSourceText: Text;
        AllocTargetText: Text;
        AllocRatio: Text;
        AllocTotalAmount: Decimal;
        ReminderAmount: Decimal;
        LastCostJourLineNo: Integer;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        AllocateBudget: Boolean;
        MsgText: Text;
        AllocSourceErrorFound: Boolean;
        AllocTargetErrorFound: Boolean;
        Text000: label 'Allocation date must be defined.';
        Text001: label 'From Alloc. Level must not be higher than To Alloc. Level.';
        Text002: label 'Budget cost from budget';
        Text003: label 'Actual cost';
        Text004: label '%1 will be allocated for levels %2 to %3.\Posting date: %4,  group: "%5"\Do you want to start the job?';
        Text005: label 'Cost allocation\Level                      #1####### \Source ID                  #2####### \Sum source entries         #3####### \Write allocation entries   #4####### ';
        Text006: label 'No entries have been created for the selected allocations.';
        Text007: label '%1 allocation entries have been generated and processed.';
        Text008: label 'Alloc. Source:';
        Text009: label 'Alloc. Target: ';
        Text010: label 'Alloc: %1 of %2 shares. Base $ %3';
        Text011: label 'Alloc: %1 pct of %2 shares';
        Text012: label 'Alloc: %1 $ of %2 shares';
        Text013: label ' ... etc.';
        Text014: label 'Alloc. level %1 of %2';
        Text015: label 'Not all cost types for debit and credit are defined for allocation ID %1.';
        Text016: label 'For allocation ID %1, cost center or cost object must be defined for debit and credit. Cost center: "%2", cost object "%3".';
        Text017: label 'Cost Type';
        Text018: label 'Cost Center';
        Text019: label 'Cost Object';
        Text020: label 'One or more allocation targets do not have a cost center or cost object defined. The allocation cannot continue.';
        Text021: label 'One or more allocation sources do not have a cost center or cost object defined. The allocation cannot continue.';
        Text022: label 'Posting Cost Entries                       @1@@@@@@@@@@\';

    local procedure ShowAllocations(CheckTargets: Boolean)
    var
        CostAllocations: Report "Cost Allocations";
        ConfirmText: Text[1024];
        SkipSourcesWithoutTargets: Boolean;
    begin
        if CheckTargets then begin
          ConfirmText := Text020;
          CostAllocationTarget.SetFilter("Target Cost Center",'%1','');
          CostAllocationTarget.SetFilter("Target Cost Object",'%1','');
        end else begin
          ConfirmText := Text021;
          CostAllocationSource.SetFilter("Cost Center Code",'%1','');
          CostAllocationSource.SetFilter("Cost Object Code",'%1','');
          CostAllocationTarget.SetFilter(ID,'<%1','');
        end;
        if Confirm(ConfirmText,true) then begin
          SkipSourcesWithoutTargets := CheckTargets;
          CostAllocations.InitializeRequest(CostAllocationSource,CostAllocationTarget,SkipSourcesWithoutTargets);
          CostAllocations.Run;
        end;
    end;

    local procedure WriteJournalLine(CostTypeCode: Code[20];CostCenterCode: Code[20];CostObjectCode: Code[20];PostAmount: Decimal;Text: Text;AllocKey: Text;AllocID: Code[10];Allocated2: Boolean)
    begin
        if PostAmount = 0 then
          exit;

        if CostTypeCode = '' then
          Error(Text015,"Cost Allocation Source".ID);

        if ((CostCenterCode = '') and (CostObjectCode = '')) or ((CostCenterCode <> '') and (CostObjectCode <> '')) then
          Error(Text016,"Cost Allocation Source".ID,CostCenterCode,CostObjectCode);

        with TempCostJnlLine do begin
          LastCostJourLineNo := LastCostJourLineNo + 10000;
          "Line No." := LastCostJourLineNo;
          "Posting Date" := AllocDate;
          "Cost Type No." := CostTypeCode;
          "Cost Center Code" := CostCenterCode;
          "Cost Object Code" := CostObjectCode;
          "Document No." := IncStr(CostAccSetup."Last Allocation Doc. No.");
          Description := CopyStr(Text,1,MaxStrLen(Description));
          Amount := PostAmount;
          "System-Created Entry" := true;
          Allocated := Allocated2;
          "Allocation Description" := CopyStr(AllocKey,1,MaxStrLen("Allocation Description"));
          "Allocation ID" := AllocID;
          "Source Code" := SourceCodeSetup."Cost Allocation";
          "Budget Name" := CostBudgetName.Name;
          Insert;

          if Amount > 0 then
            TotalDebit := TotalDebit + Amount
          else
            TotalCredit := TotalCredit + Amount;
        end;

        EntriesPerLevel := EntriesPerLevel + 1;
        TotalEntries := TotalEntries + 1;
        Window.Update(4,Format(TotalEntries));
    end;

    local procedure PostCostJournalLines()
    var
        CostJnlLine: Record "Cost Journal Line";
        CAJnlPostLine: Codeunit "CA Jnl.-Post Line";
        Window2: Dialog;
        CostJnlLineStep: Integer;
        JournalLineCount: Integer;
    begin
        TempCostJnlLine.Reset;
        Window2.Open(
          Text022);
        if TempCostJnlLine.Count > 0 then
          JournalLineCount := 10000 * 100000 DIV TempCostJnlLine.Count;
        if TempCostJnlLine.FindSet then begin
          repeat
            CostJnlLineStep := CostJnlLineStep + JournalLineCount;
            Window2.Update(1,CostJnlLineStep DIV 100000);
            CostJnlLine := TempCostJnlLine;
            CAJnlPostLine.RunWithCheck(CostJnlLine);
          until TempCostJnlLine.Next = 0;
          TempCostJnlLine.DeleteAll;
        end;
        Window2.Close;
    end;


    procedure InitializeRequest(NewFromLevel: Integer;NewToLevel: Integer;NewAllocDate: Date;NewAllocVariant: Code[10];NewCostBudgetName: Code[10])
    begin
        FromLevel := NewFromLevel;
        ToLevel := NewToLevel;
        AllocDate := NewAllocDate;
        AllocVariant := NewAllocVariant;
        CostBudgetName.Name := NewCostBudgetName;
    end;
}

