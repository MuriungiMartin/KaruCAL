#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7300 "Calculate Bin Replenishment"
{
    Caption = 'Calculate Bin Replenishment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bin Content";"Bin Content")
        {
            DataItemTableView = sorting("Location Code","Item No.","Variant Code","Warehouse Class Code",Fixed,"Bin Ranking") order(descending) where(Fixed=filter(true));
            RequestFilterFields = "Bin Code","Item No.";
            column(ReportForNavId_4810; 4810)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Replenishmt.ReplenishBin("Bin Content",AllowBreakbulk);
            end;

            trigger OnPostDataItem()
            begin
                if not Replenishmt.InsertWhseWkshLine then
                  if not HideDialog then
                    Message(Text000);
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Location Code") <> '' then begin
                  if GetFilter("Location Code") <> LocationCode then
                    Error(Text001,FieldCaption("Location Code"),LocationCode);
                end else
                  SetRange("Location Code",LocationCode);

                Replenishmt.SetWhseWorksheet(
                  WhseWkshTemplateName,WhseWkshName,LocationCode,DoNotFillQtytoHandle);
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
                    field(AllowBreakbulk;AllowBreakbulk)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Allow Breakbulk';
                    }
                    field(DoNotFillQtytoHandle;DoNotFillQtytoHandle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Do Not Fill Qty. to Handle';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Replenishmt: Codeunit Replenishment;
        WhseWkshTemplateName: Code[10];
        WhseWkshName: Code[10];
        LocationCode: Code[10];
        AllowBreakbulk: Boolean;
        HideDialog: Boolean;
        Text000: label 'There is nothing to replenish.';
        DoNotFillQtytoHandle: Boolean;
        Text001: label 'If you want to set a filter to field %1, it must be %2.';


    procedure InitializeRequest(WhseWkshTemplateName2: Code[10];WhseWkshName2: Code[10];LocationCode2: Code[10];AllowBreakbulk2: Boolean;HideDialog2: Boolean;DoNotFillQtytoHandle2: Boolean)
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
        AllowBreakbulk := AllowBreakbulk2;
        HideDialog := HideDialog2;
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
    end;
}

