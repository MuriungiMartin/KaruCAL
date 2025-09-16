#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7380 "Calculate Phys. Invt. Counting"
{
    Caption = 'Calculate Phys. Invt. Counting';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

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

                        trigger OnValidate()
                        begin
                            ValidatePostingDate;
                        end;
                    }
                    field(NextDocNo;NextDocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                    }
                    field(ZeroQty;ZeroQty)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Items Not on Inventory';
                    }
                    group(Print)
                    {
                        Caption = 'Print';
                        field(PrintDoc;PrintDoc)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Print List';

                            trigger OnValidate()
                            begin
                                if not PrintDoc then begin
                                  PrintDocPerItem := false;
                                  ShowQtyCalculated := false;
                                end;
                                ShowQtyCalcEnable := PrintDoc;
                                PrintPerItemEnable := PrintDoc;
                            end;
                        }
                        field(ShowQtyCalc;ShowQtyCalculated)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Show Qty. Calculated';
                            Enabled = ShowQtyCalcEnable;
                        }
                        field(PrintPerItem;PrintDocPerItem)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Item';
                            Enabled = PrintPerItemEnable;
                            Visible = PrintPerItemVisible;
                        }
                    }
                    field(SortMethod;SortingMethod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sorting Method';
                        OptionCaption = ' ,Item,Bin';
                        Visible = SortMethodVisible;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            PrintPerItemVisible := true;
            SortMethodVisible := true;
            PrintPerItemEnable := true;
            ShowQtyCalcEnable := true;
        end;

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
              PostingDate := WorkDate;
            ValidatePostingDate;

            ShowQtyCalcEnable := PrintDoc;
            PrintPerItemEnable := PrintDoc;
            SortMethodVisible := SourceJnl = Sourcejnl::WhseJnl;
            PrintPerItemVisible := SourceJnl = Sourcejnl::WhseJnl;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        OKPressed := true;
    end;

    var
        ItemJnlBatch: Record "Item Journal Batch";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostingDate: Date;
        SourceJnl: Option ItemJnl,WhseJnl;
        SortingMethod: Option " ",Item,Bin;
        NextDocNo: Code[20];
        PrintDoc: Boolean;
        PrintDocPerItem: Boolean;
        ShowQtyCalculated: Boolean;
        ZeroQty: Boolean;
        OKPressed: Boolean;
        [InDataSet]
        ShowQtyCalcEnable: Boolean;
        [InDataSet]
        PrintPerItemEnable: Boolean;
        [InDataSet]
        SortMethodVisible: Boolean;
        [InDataSet]
        PrintPerItemVisible: Boolean;


    procedure GetRequest(var PostingDate2: Date;var NextDocNo2: Code[20];var SortingMethod2: Option " ",Item,Bin;var PrintDoc2: Boolean;var PrintDocPerItem2: Boolean;var ZeroQty2: Boolean;var ShowQtyCalculated2: Boolean): Boolean
    begin
        PostingDate2 := PostingDate;
        NextDocNo2 := NextDocNo;
        SortingMethod2 := SortingMethod;
        PrintDoc2 := PrintDoc;
        PrintDocPerItem2 := PrintDocPerItem;
        ZeroQty2 := ZeroQty;
        ShowQtyCalculated2 := ShowQtyCalculated;
        exit(OKPressed);
    end;

    local procedure ValidatePostingDate()
    begin
        if SourceJnl = Sourcejnl::ItemJnl then begin
          if ItemJnlBatch."No. Series" = '' then
            NextDocNo := ''
          else begin
            NextDocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series",PostingDate,false);
            Clear(NoSeriesMgt);
          end;
        end else
          if WhseJnlBatch."No. Series" = '' then
            NextDocNo := ''
          else begin
            NextDocNo := NoSeriesMgt.GetNextNo(WhseJnlBatch."No. Series",PostingDate,false);
            Clear(NoSeriesMgt);
          end;
    end;


    procedure SetItemJnlLine(NewItemJnlBatch: Record "Item Journal Batch")
    begin
        ItemJnlBatch := NewItemJnlBatch;
        SourceJnl := Sourcejnl::ItemJnl;
    end;


    procedure SetWhseJnlLine(NewWhseJnlBatch: Record "Warehouse Journal Batch")
    begin
        WhseJnlBatch := NewWhseJnlBatch;
        SourceJnl := Sourcejnl::WhseJnl;
    end;
}

