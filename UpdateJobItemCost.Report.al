#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1095 "Update Job Item Cost"
{
    Caption = 'Update Job Item Cost';
    Permissions = TableData "Job Ledger Entry"=rm,
                  TableData "Value Entry"=rm;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("No.") where(Status=filter(<>Completed));
            RequestFilterFields = "No.";
            column(ReportForNavId_8019; 8019)
            {
            }
            dataitem("Job Ledger Entry";"Job Ledger Entry")
            {
                DataItemLink = "Job No."=field("No.");
                DataItemTableView = sorting(Type,"Entry Type","Country/Region Code","Source Code","Posting Date") where(Type=filter(=Item),"Entry Type"=filter(=Usage));
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_5612; 5612)
                {
                }
                dataitem("Item Ledger Entry";"Item Ledger Entry")
                {
                    DataItemLink = "Entry No."=field("Ledger Entry No.");
                    DataItemTableView = sorting("Entry No.");
                    column(ReportForNavId_7209; 7209)
                    {
                    }
                    dataitem("Job Planning Line";"Job Planning Line")
                    {
                        DataItemLink = "Job No."=field("Job No."),"Job Task No."=field("Job Task No."),"Ledger Entry No."=field("Entry No.");
                        DataItemTableView = sorting("Job No.","Job Task No.","Line No.");
                        column(ReportForNavId_9714; 9714)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Qty. Transferred to Invoice");
                            if ("Qty. Transferred to Invoice" <> 0) or not "System-Created Entry" or ("Ledger Entry Type" <> "ledger entry type"::Item) then
                              CurrReport.Skip;

                            Validate("Unit Cost (LCY)","Job Ledger Entry"."Unit Cost (LCY)");
                            Validate("Line Discount Amount (LCY)","Job Ledger Entry"."Line Discount Amount (LCY)");
                            Modify;
                            "Job Ledger Entry".Validate("Unit Price","Unit Price");
                            "Job Ledger Entry".Validate("Unit Price (LCY)","Unit Price (LCY)");
                            "Job Ledger Entry".Validate("Total Price","Total Price");
                            "Job Ledger Entry".Validate("Total Price (LCY)","Total Price (LCY)");
                            "Job Ledger Entry".Validate("Line Amount (LCY)","Line Amount (LCY)");
                            "Job Ledger Entry".Validate("Line Amount","Line Amount");
                            "Job Ledger Entry".Modify;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if NoOfJobLedgEntry = 0 then
                              CurrReport.Break;
                            LockTable;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        ValueEntry: Record "Value Entry";
                        ValueEntry2: Record "Value Entry";
                        JobLedgerEntryCostValue: Decimal;
                        JobLedgerEntryCostValueACY: Decimal;
                    begin
                        ValueEntry.SetRange("Job No.","Job Ledger Entry"."Job No.");
                        ValueEntry.SetRange("Job Task No.","Job Ledger Entry"."Job Task No.");
                        ValueEntry.SetRange("Job Ledger Entry No.","Job Ledger Entry"."Entry No.");
                        ValueEntry.SetRange("Item Ledger Entry No.","Entry No.");
                        ValueEntry.SetRange("Item Ledger Entry Type",ValueEntry."item ledger entry type"::"Negative Adjmt.");
                        ValueEntry.SetRange("Document Type",ValueEntry."document type"::"Purchase Invoice");

                        if ValueEntry.IsEmpty then begin
                          CalcFields("Cost Amount (Expected)","Cost Amount (Expected) (ACY)",
                            "Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
                          JobLedgerEntryCostValue := "Cost Amount (Expected)" + "Cost Amount (Actual)";
                          JobLedgerEntryCostValueACY := "Cost Amount (Expected) (ACY)" + "Cost Amount (Actual) (ACY)";
                        end else begin
                          ValueEntry.SetRange(Adjustment,false);
                          if ValueEntry.FindFirst then begin
                            JobLedgerEntryCostValue := ValueEntry."Cost Amount (Actual)";
                            JobLedgerEntryCostValueACY := ValueEntry."Cost Amount (Actual) (ACY)";

                            ValueEntry2.SetRange("Item Ledger Entry No.","Entry No.");
                            ValueEntry2.SetRange("Document No.",ValueEntry."Document No.");
                            ValueEntry2.SetRange("Item Ledger Entry Type",ValueEntry."item ledger entry type"::"Negative Adjmt.");
                            ValueEntry2.SetRange("Document Type",ValueEntry."document type"::"Purchase Invoice");
                            ValueEntry2.SetRange(Adjustment,true);
                            ValueEntry2.CalcSums("Cost Amount (Actual)","Cost Amount (Actual) (ACY)");
                            JobLedgerEntryCostValue += ValueEntry2."Cost Amount (Actual)";
                            JobLedgerEntryCostValueACY += ValueEntry2."Cost Amount (Actual) (ACY)";

                            ValueEntry2.SetRange("Job Ledger Entry No.",0);
                            ValueEntry2.ModifyAll("Job No.",ValueEntry."Job No.");
                            ValueEntry2.ModifyAll("Job Task No.",ValueEntry."Job Task No.");
                            ValueEntry2.ModifyAll("Job Ledger Entry No.",ValueEntry."Job Ledger Entry No.");
                          end;
                        end;
                        PostTotalCostAdjustment("Job Ledger Entry",JobLedgerEntryCostValue,JobLedgerEntryCostValueACY);
                    end;

                    trigger OnPreDataItem()
                    begin
                        LockTable;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    LockTable;
                end;
            }

            trigger OnPostDataItem()
            begin
                if not HideResult then begin
                  if NoOfJobLedgEntry <> 0 then
                    Message(StrSubstNo(Text001,NoOfJobLedgEntry))
                  else
                    Message(Text003);
                end;
            end;

            trigger OnPreDataItem()
            begin
                NoOfJobLedgEntry := 0;
                LockTable;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text001: label 'The job ledger entry item costs have now been updated to equal the related item ledger entry actual costs.\\The number of job ledger entries modified = %1.', Comment='The Job Ledger Entry item costs have now been updated to equal the related item ledger entry actual costs.\\Number of Job Ledger Entries modified = 2.';
        NoOfJobLedgEntry: Integer;
        Text003: label 'There were no job ledger entries that needed to be updated.';
        HideResult: Boolean;


    procedure SetProperties(SuppressSummary: Boolean)
    begin
        HideResult := SuppressSummary;
    end;

    local procedure UpdatePostedTotalCost(var JobLedgerEntry: Record "Job Ledger Entry";AdjustJobCost: Decimal;AdjustJobCostLCY: Decimal)
    var
        JobUsageLink: Record "Job Usage Link";
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobUsageLink.SetRange("Entry No.",JobLedgerEntry."Entry No.");
        if JobUsageLink.FindSet then
          repeat
            JobPlanningLine.Get(JobUsageLink."Job No.",JobUsageLink."Job Task No.",JobUsageLink."Line No.");
            JobPlanningLine.UpdatePostedTotalCost(AdjustJobCost,AdjustJobCostLCY);
            JobPlanningLine.Modify;
          until JobUsageLink.Next = 0;
    end;

    local procedure PostTotalCostAdjustment(var JobLedgEntry: Record "Job Ledger Entry";JobLedgerEntryCostValue: Decimal;JobLedgerEntryCostValueACY: Decimal)
    var
        AdjustJobCost: Decimal;
        AdjustJobCostLCY: Decimal;
    begin
        if JobLedgEntry."Total Cost (LCY)" <> -JobLedgerEntryCostValue then begin
          // Update Total Costs
          AdjustJobCostLCY := -JobLedgerEntryCostValue - JobLedgEntry."Total Cost (LCY)";
          JobLedgEntry."Total Cost (LCY)" := -JobLedgerEntryCostValue;
          if JobLedgEntry."Currency Code" = '' then begin
            AdjustJobCost := -JobLedgerEntryCostValue - JobLedgEntry."Total Cost";
            JobLedgEntry."Total Cost" := -JobLedgerEntryCostValue
          end else begin
            AdjustJobCost := -JobLedgerEntryCostValue * JobLedgEntry."Currency Factor" - JobLedgEntry."Total Cost";
            JobLedgEntry."Total Cost" := -JobLedgerEntryCostValue * JobLedgEntry."Currency Factor";
          end;
          if JobLedgerEntryCostValueACY <> 0 then
            JobLedgEntry."Additional-Currency Total Cost" := -JobLedgerEntryCostValueACY;

          // Update Unit Costs
          JobLedgEntry."Unit Cost (LCY)" :=
            JobLedgEntry."Total Cost (LCY)" / JobLedgEntry.Quantity;
          JobLedgEntry."Unit Cost" :=
            JobLedgEntry."Total Cost" / JobLedgEntry.Quantity;

          JobLedgEntry.Adjusted := true;
          JobLedgEntry."DateTime Adjusted" := CurrentDatetime;
          JobLedgEntry.Modify;

          UpdatePostedTotalCost(JobLedgEntry,AdjustJobCost,AdjustJobCostLCY);

          NoOfJobLedgEntry += 1;
        end;
    end;
}

