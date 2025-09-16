#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5855 "Implement Standard Cost Change"
{
    Caption = 'Implement Standard Cost Change';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Standard Cost Worksheet";"Standard Cost Worksheet")
        {
            DataItemTableView = sorting("Standard Cost Worksheet Name",Type,"No.");
            RequestFilterFields = Type,"No.";
            column(ReportForNavId_4691; 4691)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Type);
                Window.Update(2,"No.");

                case Type of
                  Type::Item:
                    begin
                      UpdateItem("Standard Cost Worksheet");
                      UpdateSKU("Standard Cost Worksheet");
                      InsertRevalItemJnlLine;
                    end;
                  Type::"Work Center":
                    UpdateWorkCenter("Standard Cost Worksheet");
                  Type::"Machine Center":
                    UpdateMachCenter("Standard Cost Worksheet");
                  Type::Resource:
                    UpdateRes("Standard Cost Worksheet");
                end;
                UpdateStdCostWksh("Standard Cost Worksheet")
            end;

            trigger OnPostDataItem()
            begin
                if not NoMessage then
                  Message(GetMessage);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Standard Cost Worksheet Name",StdCostWkshName);
                if IsEmpty then
                  Error(Text013,StdCostWkshName);

                Window.Open(
                  Text000 +
                  Text007 +
                  Text008);

                ItemJnlLine.LockTable;
                LockTable;

                RevalJnlCreated := false;
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
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                        NotBlank = true;
                    }
                    field(DocumentNo;DocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                    }
                    field(ItemJournalTemplate;RevalItemJnlTemplate.Name)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Journal Template ';
                        NotBlank = true;
                        TableRelation = "Item Journal Template" where (Type=const(Revaluation));
                    }
                    field(ItemJournalBatchName;RevalItemJnlBatch.Name)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Journal Batch Name';
                        NotBlank = true;
                        TableRelation = "Item Journal Batch".Name;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RevalItemJnlBatch.SetFilter("Journal Template Name",RevalItemJnlTemplate.Name);
                            if Page.RunModal(0,RevalItemJnlBatch) = Action::LookupOK then begin
                              Text := Text + RevalItemJnlBatch.Name;
                              exit(true);
                            end;
                            exit(false);
                        end;

                        trigger OnValidate()
                        begin
                            RevalItemJnlBatchNameOnAfterVa;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
              PostingDate := WorkDate;

            ValidatePostingDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        RevalItemJnlTemplate.Get(RevalItemJnlTemplate.Name);
        RevalItemJnlTemplate.TestField(Type,RevalItemJnlTemplate.Type::Revaluation);
        RevalItemJnlBatch.Get(RevalItemJnlTemplate.Name,RevalItemJnlBatch.Name);

        if DocNo = '' then
          Error(Text001);
        if StdCostWkshName = '' then
          Error(StrSubstNo(Text002));
    end;

    var
        ItemJnlLine: Record "Item Journal Line";
        RevalItemJnlTemplate: Record "Item Journal Template";
        RevalItemJnlBatch: Record "Item Journal Batch";
        Window: Dialog;
        StdCostWkshName: Code[10];
        DocNo: Code[20];
        PostingDate: Date;
        Text000: label 'Implementing standard cost changes...\\';
        Text001: label 'You must specify a document no.';
        Text002: label 'You must specify a worksheet to implement from.';
        Text007: label 'Type                       #1##########\';
        Text008: label 'No.                        #2##########';
        Text009: label '\Revaluation journal lines have also been created.';
        RevalJnlCreated: Boolean;
        ItemCostsUpdated: Boolean;
        MachCtrCostsUpdated: Boolean;
        WorkCtrCostsUpdated: Boolean;
        ResCostsUpdated: Boolean;
        SKUCostsUpdated: Boolean;
        NoMessage: Boolean;
        HideDuplWarning: Boolean;
        Text010: label 'Costs have been updated on the following: ';
        Text011: label ', ';
        Text012: label '.';
        Text013: label 'Standard Cost Worksheet %1 is empty.';

    local procedure UpdateItem(StdCostWksh: Record "Standard Cost Worksheet")
    var
        Item: Record Item;
    begin
        with Item do begin
          Get(StdCostWksh."No.");
          Validate("Indirect Cost %",StdCostWksh."New Indirect Cost %");
          Validate("Overhead Rate",StdCostWksh."New Overhead Rate");
          Validate("Standard Cost",StdCostWksh."New Standard Cost");
          "Single-Level Material Cost" := StdCostWksh."New Single-Lvl Material Cost";
          "Single-Level Capacity Cost" := StdCostWksh."New Single-Lvl Cap. Cost";
          "Single-Level Subcontrd. Cost" := StdCostWksh."New Single-Lvl Subcontrd Cost";
          "Single-Level Cap. Ovhd Cost" := StdCostWksh."New Single-Lvl Cap. Ovhd Cost";
          "Single-Level Mfg. Ovhd Cost" := StdCostWksh."New Single-Lvl Mfg. Ovhd Cost";

          "Rolled-up Material Cost" := StdCostWksh."New Rolled-up Material Cost";
          "Rolled-up Capacity Cost" := StdCostWksh."New Rolled-up Cap. Cost";
          "Rolled-up Subcontracted Cost" := StdCostWksh."New Rolled-up Subcontrd Cost";
          "Rolled-up Mfg. Ovhd Cost" := StdCostWksh."New Rolled-up Mfg. Ovhd Cost";
          "Rolled-up Cap. Overhead Cost" := StdCostWksh."New Rolled-up Cap. Ovhd Cost";

          "Last Unit Cost Calc. Date" := PostingDate;
          Modify(true);

          ItemCostsUpdated := true;
        end;
    end;

    local procedure UpdateSKU(StdCostWksh: Record "Standard Cost Worksheet")
    var
        SKU: Record "Stockkeeping Unit";
    begin
        with SKU do begin
          SetRange("Item No.",StdCostWksh."No.");
          if Find('-') then begin
            SKUCostsUpdated := true;
            repeat
              Validate("Standard Cost",StdCostWksh."New Standard Cost");
              Modify(true);
            until Next = 0;
          end;
        end;
    end;

    local procedure UpdateMachCenter(StdCostWksh: Record "Standard Cost Worksheet")
    var
        MachCtr: Record "Machine Center";
    begin
        with MachCtr do begin
          Get(StdCostWksh."No.");
          Validate("Overhead Rate",StdCostWksh."New Overhead Rate");
          Validate("Indirect Cost %",StdCostWksh."New Indirect Cost %");
          Validate("Unit Cost",StdCostWksh."New Standard Cost");
          Modify(true);
          MachCtrCostsUpdated := true;
        end;
    end;

    local procedure UpdateWorkCenter(StdCostWksh: Record "Standard Cost Worksheet")
    var
        WorkCtr: Record "Work Center";
    begin
        with WorkCtr do begin
          Get(StdCostWksh."No.");
          Validate("Overhead Rate",StdCostWksh."New Overhead Rate");
          Validate("Indirect Cost %",StdCostWksh."New Indirect Cost %");
          Validate("Unit Cost",StdCostWksh."New Standard Cost");
          Modify(true);
          WorkCtrCostsUpdated := true;
        end;
    end;

    local procedure UpdateRes(StdCostWksh: Record "Standard Cost Worksheet")
    var
        ResCost: Record "Resource Cost";
        Res: Record Resource;
    begin
        with Res do begin
          Get(StdCostWksh."No.");
          Validate("Indirect Cost %",StdCostWksh."New Indirect Cost %");
          Validate("Unit Cost",StdCostWksh."New Standard Cost");
          Modify(true);
          ResCostsUpdated := true;
        end;

        with ResCost do begin
          Type := Type::Resource;
          Code := StdCostWksh."No.";
          Validate("Direct Unit Cost",Res."Direct Unit Cost");
          Validate("Unit Cost",StdCostWksh."New Standard Cost");
          if not Modify(true) then;
        end;
    end;

    local procedure UpdateStdCostWksh(var StdCostWksh: Record "Standard Cost Worksheet")
    begin
        with StdCostWksh do begin
          Implemented := true;
          Modify(true);
        end;
    end;

    local procedure InsertRevalItemJnlLine()
    var
        Item: Record Item;
        ItemJnlLine2: Record "Item Journal Line";
        CalcInvtValue: Report "Calculate Inventory Value";
        CalculatePer: Option "Item Ledger Entry",Item;
    begin
        ItemJnlLine2.SetRange("Journal Template Name",RevalItemJnlTemplate.Name);
        ItemJnlLine2.SetRange("Journal Batch Name",RevalItemJnlBatch.Name);
        if ItemJnlLine2.Find('+') then;

        ItemJnlLine."Journal Template Name" := RevalItemJnlTemplate.Name;
        ItemJnlLine."Journal Batch Name" := RevalItemJnlBatch.Name;
        CalcInvtValue.SetItemJnlLine(ItemJnlLine);
        Clear(Item);
        Item.SetRange("No.","Standard Cost Worksheet"."No.");
        CalcInvtValue.SetTableview(Item);
        CalcInvtValue.InitializeRequest(PostingDate,DocNo,HideDuplWarning,Calculateper::Item,false,false,false,0,false);
        CalcInvtValue.UseRequestPage(false);
        CalcInvtValue.Run;
        HideDuplWarning := true;

        if ItemJnlLine2.Next <> 0 then
          repeat
            ItemJnlLine2.Validate("Unit Cost (Revalued)","Standard Cost Worksheet"."New Standard Cost");
            ItemJnlLine2.Modify(true);
            RevalJnlCreated := true;
          until ItemJnlLine2.Next = 0;
    end;


    procedure SetStdCostWksh(NewStdCostWkshName: Code[10])
    begin
        StdCostWkshName := NewStdCostWkshName;
    end;

    local procedure GetMessage() TheMsg: Text[250]
    var
        Item: Record Item;
        MachCtr: Record "Machine Center";
        WorkCtr: Record "Work Center";
        Res: Record Resource;
        SKU: Record "Stockkeeping Unit";
    begin
        TheMsg := '';
        if ItemCostsUpdated then
          TheMsg := Item.TableCaption;
        if SKUCostsUpdated then begin
          TheMsg := TheMsg + Text011;
          TheMsg := TheMsg + SKU.TableCaption;
        end;
        if MachCtrCostsUpdated then begin
          if TheMsg <> '' then
            TheMsg := TheMsg + Text011;
          TheMsg := TheMsg + MachCtr.TableCaption;
        end;
        if WorkCtrCostsUpdated then begin
          if TheMsg <> '' then
            TheMsg := TheMsg + Text011;
          TheMsg := TheMsg + WorkCtr.TableCaption;
        end;
        if ResCostsUpdated then begin
          if TheMsg <> '' then
            TheMsg := TheMsg + Text011;
          TheMsg := TheMsg + Res.TableCaption;
        end;
        if TheMsg <> '' then
          TheMsg := Text010 + TheMsg + Text012;
        if RevalJnlCreated then
          TheMsg := TheMsg + Text009;
        exit(TheMsg);
    end;

    local procedure ValidatePostingDate()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with RevalItemJnlBatch do
          if Get(RevalItemJnlTemplate.Name,Name) then
            if "No. Series" = '' then
              DocNo := ''
            else begin
              DocNo := NoSeriesMgt.GetNextNo("No. Series",PostingDate,false);
              Clear(NoSeriesMgt);
            end;
    end;


    procedure Initialize()
    var
        DocNo2: Code[20];
        PostingDate2: Date;
        RevalItemJnlTemplate2: Code[10];
        RevalItemJnlBatch2: Code[10];
        NoMessage2: Boolean;
    begin
        PostingDate := PostingDate2;
        DocNo := DocNo2;
        RevalItemJnlTemplate.Get(RevalItemJnlTemplate2);
        RevalItemJnlBatch.Get(RevalItemJnlTemplate2,RevalItemJnlBatch2);
        NoMessage := NoMessage2;
    end;

    local procedure RevalItemJnlBatchNameOnAfterVa()
    begin
        ValidatePostingDate;
    end;
}

