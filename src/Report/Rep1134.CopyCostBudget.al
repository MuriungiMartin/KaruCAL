#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1134 "Copy Cost Budget"
{
    Caption = 'Copy Cost Budget';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cost Budget Entry";"Cost Budget Entry")
        {
            DataItemTableView = sorting("Budget Name","Cost Type No.",Date);
            RequestFilterFields = "Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date;
            column(ReportForNavId_3233; 3233)
            {
            }

            trigger OnAfterGetRecord()
            var
                CostAccMgt: Codeunit "Cost Account Mgt";
            begin
                if "Entry No." > LastEntryNo then
                  CurrReport.Break;

                CostBudgetEntryTarget := "Cost Budget Entry";

                CostBudgetEntryTarget.Description := StrSubstNo(Text006,GetFilter("Budget Name"));
                CostBudgetEntryTarget."Budget Name" := CostBudgetEntryReqForm."Budget Name";

                if CostBudgetEntryReqForm."Cost Type No." <> '' then
                  CostBudgetEntryTarget."Cost Type No." := CostBudgetEntryReqForm."Cost Type No.";
                if CostBudgetEntryReqForm."Cost Center Code" <> '' then
                  CostBudgetEntryTarget."Cost Center Code" := CostBudgetEntryReqForm."Cost Center Code";
                if CostBudgetEntryReqForm."Cost Object Code" <> '' then
                  CostBudgetEntryTarget."Cost Object Code" := CostBudgetEntryReqForm."Cost Object Code";

                CostBudgetEntryTarget.Amount := ROUND(Amount * Factor,0.01);
                CostBudgetEntryTarget.Allocated := false;

                for i := 1 to NoOfCopies do begin
                  CostBudgetEntryTarget."Entry No." := NextEntryNo;
                  NextEntryNo := NextEntryNo + 1;
                  if DateChangeFormula <> '' then
                    CostBudgetEntryTarget.Date := CalcDate(DateFormula,CostBudgetEntryTarget.Date);
                  CostBudgetEntryTarget.Insert;
                  NoInserted := NoInserted + 1;

                  if CostBudgetRegNo = 0 then
                    CostBudgetRegNo :=
                      CostAccMgt.InsertCostBudgetRegister(
                        CostBudgetEntryTarget."Entry No.",CostBudgetEntryTarget."Budget Name",CostBudgetEntryTarget.Amount)
                  else
                    CostAccMgt.UpdateCostBudgetRegister(
                      CostBudgetRegNo,CostBudgetEntryTarget."Entry No.",CostBudgetEntryTarget.Amount);

                  if (NoInserted MOD 100) = 0 then
                    Window.Update(3,NoInserted);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                if NoInserted = 0 then begin
                  Message(Text010);
                  Error('');
                end;

                if not Confirm(Text007,true,NoInserted,CostBudgetNameTarget.Name) then
                  Error('');
            end;

            trigger OnPreDataItem()
            begin
                if Factor = 0 then
                  Error(Text000);

                if NoOfCopies < 1 then
                  Error(Text001);

                if (NoOfCopies > 1) and (DateChangeFormula = '') then
                  Error(Text002);

                if GetFilter("Budget Name") = '' then
                  Error(Text008);

                if CostBudgetEntryReqForm."Budget Name" = '' then
                  Error(Text009);

                if CostBudgetEntryReqForm."Budget Name" <> '' then
                  CostBudgetNameTarget.Get(CostBudgetEntryReqForm."Budget Name")
                else
                  CostBudgetNameTarget.Get(GetFilter("Budget Name"));

                if not Confirm(
                     Text004,false,GetFilter("Budget Name"),CostBudgetNameTarget.Name,Factor,NoOfCopies,GetFilter(Date),DateChangeFormula)
                then
                  Error('');

                LockTable;

                if CostBudgetEntryTarget.FindLast then
                  LastEntryNo := CostBudgetEntryTarget."Entry No.";

                NextEntryNo := LastEntryNo + 1;

                Window.Open(Text005);

                Window.Update(1,Count);
                Window.Update(2,NoOfCopies);
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
                    group("Copy to...")
                    {
                        Caption = 'Copy to...';
                        field("Budget Name";CostBudgetEntryReqForm."Budget Name")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Budget Name';
                            Lookup = true;
                            TableRelation = "Cost Budget Name";
                        }
                        field("Cost Type No.";CostBudgetEntryReqForm."Cost Type No.")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Cost Type No.';
                            Lookup = true;
                            TableRelation = "Cost Type";
                        }
                        field("Cost Center Code";CostBudgetEntryReqForm."Cost Center Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Cost Center Code';
                            Lookup = true;
                            TableRelation = "Cost Center";
                        }
                        field("Cost Object Code";CostBudgetEntryReqForm."Cost Object Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Cost Object Code';
                            Lookup = true;
                            TableRelation = "Cost Object";
                        }
                    }
                    field("Amount multiplication factor";Factor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount multiplication factor';
                    }
                    field("No. of Copies";NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field("Date Change Formula";DateChangeFormula)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Change Formula';
                        DateFormula = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CostBudgetEntryReqForm.Init;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        if NoOfCopies = 0 then
          NoOfCopies := 1;
        if Factor = 0 then
          Factor := 1;
    end;

    trigger OnPreReport()
    begin
        Evaluate(DateFormula,DateChangeFormula);
    end;

    var
        CostBudgetEntryReqForm: Record "Cost Budget Entry";
        CostBudgetEntryTarget: Record "Cost Budget Entry";
        CostBudgetNameTarget: Record "Cost Budget Name";
        Window: Dialog;
        DateChangeFormula: Code[10];
        DateFormula: DateFormula;
        LastEntryNo: Integer;
        NextEntryNo: Integer;
        NoOfCopies: Integer;
        Factor: Decimal;
        i: Integer;
        NoInserted: Integer;
        CostBudgetRegNo: Integer;
        Text000: label 'The multiplication factor must not be 0.';
        Text001: label 'Number of copies must be at least 1.';
        Text002: label 'If more than one copy is created, a formula for date change must be defined.';
        Text004: label 'Budget %1 will be copied to Budget %2. The budget amounts will be multiplied by a factor of %3. \%4 copies will be created and the date from range %5 will be incremented by %6.\\Do you want do copy the budget?', Comment='%3=multiplication factor (decimal);%4=No of copies (integer)';
        Text005: label 'Copying budget entries\No of entries #1#####\No of copies  #2#####\Copied        #3#####';
        Text006: label 'Copy of cost budget %1', Comment='%1 - Budget Name.';
        Text007: label '%1 entries generated in budget %2.\\Do you want to copy entries?';
        Text008: label 'Define name of source budget.';
        Text009: label 'Define name of target budget.';
        Text010: label 'No entries were copied.';
}

