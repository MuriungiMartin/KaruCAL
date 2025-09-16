#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5751 "Put-away List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Put-away List.rdlc';
    Caption = 'Put-away List';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Activity Header";"Warehouse Activity Header")
        {
            DataItemTableView = sorting(Type,"No.") where(Type=filter("Put-away"|"Invt. Put-away"));
            RequestFilterFields = "No.","No. Printed";
            column(ReportForNavId_9684; 9684)
            {
            }
            column(No_WhseActivHeader;"No.")
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(Time;Time)
                {
                }
                column(SumUpLines;SumUpLines)
                {
                }
                column(ShowLotSN;ShowLotSN)
                {
                }
                column(InvtPutAway;InvtPutAway)
                {
                }
                column(BinMandatory;Location."Bin Mandatory")
                {
                }
                column(DirPutAwayAndPick;Location."Directed Put-away and Pick")
                {
                }
                column(PutAwayFilter;PutAwayFilter)
                {
                }
                column(TblCptnPutAwayFilter;"Warehouse Activity Header".TableCaption + ': ' + PutAwayFilter)
                {
                }
                column(No1_WhseActivHeader;"Warehouse Activity Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(LocCode_WhseActivHeader;"Warehouse Activity Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(AssgndUID_WhseActivHeader;"Warehouse Activity Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(SortingMthd_WhseActivHeader;"Warehouse Activity Header"."Sorting Method")
                {
                    IncludeCaption = true;
                }
                column(SrcDoc_WhseActivHeader;"Warehouse Activity Line"."Source Document")
                {
                    IncludeCaption = true;
                }
                column(CurrReportPAGENOCaption;CurrReportPAGENOCaptionLbl)
                {
                }
                column(PutawayListCaption;PutawayListCaptionLbl)
                {
                }
                column(WhseActLineDueDateCaption;WhseActLineDueDateCaptionLbl)
                {
                }
                column(QtyHandledCaption;QtyHandledCaptionLbl)
                {
                }
                dataitem("Warehouse Activity Line";"Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type"=field(Type),"No."=field("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = sorting("Activity Type","No.","Sorting Sequence No.");
                    column(ReportForNavId_6441; 6441)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if SumUpLines and
                           ("Warehouse Activity Header"."Sorting Method" <>
                            "Warehouse Activity Header"."sorting method"::Document)
                        then begin
                          if TmpWhseActLine."No." = '' then begin
                            TmpWhseActLine := "Warehouse Activity Line";
                            TmpWhseActLine.Insert;
                            Mark(true);
                          end else begin
                            TmpWhseActLine.SetCurrentkey("Activity Type","No.","Bin Code","Breakbulk No.","Action Type");
                            TmpWhseActLine.SetRange("Activity Type","Activity Type");
                            TmpWhseActLine.SetRange("No.","No.");
                            TmpWhseActLine.SetRange("Bin Code","Bin Code");
                            TmpWhseActLine.SetRange("Item No.","Item No.");
                            TmpWhseActLine.SetRange("Action Type","Action Type");
                            TmpWhseActLine.SetRange("Variant Code","Variant Code");
                            TmpWhseActLine.SetRange("Unit of Measure Code","Unit of Measure Code");
                            TmpWhseActLine.SetRange("Due Date","Due Date");
                            if TmpWhseActLine.FindFirst then begin
                              TmpWhseActLine."Qty. (Base)" := TmpWhseActLine."Qty. (Base)" + "Qty. (Base)";
                              TmpWhseActLine."Qty. to Handle" := TmpWhseActLine."Qty. to Handle" + "Qty. to Handle";
                              TmpWhseActLine."Source No." := '';
                              TmpWhseActLine.Modify;
                            end else begin
                              TmpWhseActLine := "Warehouse Activity Line";
                              TmpWhseActLine.Insert;
                              Mark(true);
                            end;
                          end;
                        end else
                          Mark(true);
                        SetCrossDockMark("Cross-Dock Information");
                    end;

                    trigger OnPostDataItem()
                    begin
                        MarkedOnly(true);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TmpWhseActLine.SetRange("Activity Type","Warehouse Activity Header".Type);
                        TmpWhseActLine.SetRange("No.","Warehouse Activity Header"."No.");
                        TmpWhseActLine.DeleteAll;
                        if BreakbulkFilter then
                          TmpWhseActLine.SetRange("Original Breakbulk",false);
                        Clear(TmpWhseActLine);
                    end;
                }
                dataitem(WhseActLine;"Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type"=field(Type),"No."=field("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = sorting("Activity Type","No.","Sorting Sequence No.");
                    column(ReportForNavId_5832; 5832)
                    {
                    }
                    column(SrcNo_WhseActivLine;"Source No.")
                    {
                        IncludeCaption = false;
                    }
                    column(SrcDoc_WhseActivLine;Format("Source Document"))
                    {
                    }
                    column(ShelfNo_WhseActivLine;"Shelf No.")
                    {
                        IncludeCaption = false;
                    }
                    column(ItemNo1_WhseActivLine;"Item No.")
                    {
                        IncludeCaption = false;
                    }
                    column(Desc_WhseActivLine;Description)
                    {
                        IncludeCaption = false;
                    }
                    column(CrsDocInfo_WhseActivLine;"Cross-Dock Information")
                    {
                        IncludeCaption = false;
                    }
                    column(UOMCode_WhseActivLine;"Unit of Measure Code")
                    {
                        IncludeCaption = false;
                    }
                    column(DueDate_WhseActivLine;Format("Due Date"))
                    {
                    }
                    column(QtyToHndl_WhseActivLine;"Qty. to Handle")
                    {
                        IncludeCaption = false;
                    }
                    column(QtyBase_WhseActivLine;"Qty. (Base)")
                    {
                        IncludeCaption = false;
                    }
                    column(CrossDockMark;CrossDockMark)
                    {
                    }
                    column(VariantCode_WhseActivLine;"Variant Code")
                    {
                        IncludeCaption = false;
                    }
                    column(ZoneCode_WhseActivLine;"Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseActivLine;"Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ActionType_WhseActivLine;"Action Type")
                    {
                        IncludeCaption = true;
                    }
                    column(LotNo1_WhseActivLine;"Lot No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SerialNo_WhseActivLine;"Serial No.")
                    {
                        IncludeCaption = true;
                    }
                    column(LineNo1_WhseActivLine;"Line No.")
                    {
                    }
                    column(BinRanking_WhseActivLine;"Bin Ranking")
                    {
                    }
                    column(EmptyStringCaption;EmptyStringCaptionLbl)
                    {
                    }
                    dataitem(WhseActLine2;"Warehouse Activity Line")
                    {
                        DataItemLink = "Activity Type"=field("Activity Type"),"No."=field("No."),"Bin Code"=field("Bin Code"),"Item No."=field("Item No."),"Action Type"=field("Action Type"),"Variant Code"=field("Variant Code"),"Unit of Measure Code"=field("Unit of Measure Code"),"Due Date"=field("Due Date");
                        DataItemTableView = sorting("Activity Type","No.","Bin Code","Breakbulk No.","Action Type");
                        column(ReportForNavId_4019; 4019)
                        {
                        }
                        column(LotNo_WhseActivLine;"Lot No.")
                        {
                        }
                        column(SerialNo2_WhseActivLine;"Serial No.")
                        {
                        }
                        column(QtyBase2_WhseActivLine;"Qty. (Base)")
                        {
                        }
                        column(QtyToHndl2_WhseActivLine;"Qty. to Handle")
                        {
                        }
                        column(LineNo_WhseActivLine;"Line No.")
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if SumUpLines then begin
                          TmpWhseActLine.Get("Activity Type","No.","Line No.");
                          "Qty. (Base)" := TmpWhseActLine."Qty. (Base)";
                          "Qty. to Handle" := TmpWhseActLine."Qty. to Handle";
                        end;
                        SetCrossDockMark("Cross-Dock Information");
                    end;

                    trigger OnPreDataItem()
                    begin
                        Copy("Warehouse Activity Line");
                        Counter := Count;
                        if Counter = 0 then
                          CurrReport.Break;

                        if BreakbulkFilter then
                          SetRange("Original Breakbulk",false);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                InvtPutAway := Type = Type::"Invt. Put-away";

                if not CurrReport.Preview then
                  Codeunit.Run(Codeunit::"Whse.-Printed","Warehouse Activity Header");
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
                    field(Breakbulk;BreakbulkFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Set Breakbulk Filter';
                        Editable = BreakbulkEditable;
                    }
                    field(SumUpLines;SumUpLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sum up Lines';
                        Editable = SumUpLinesEditable;
                    }
                    field(LotSerialNo;ShowLotSN)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Serial/Lot Number';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SumUpLinesEditable := true;
            BreakbulkEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if HideOptions then begin
              BreakbulkEditable := false;
              SumUpLinesEditable := false;
            end;
        end;
    }

    labels
    {
        WhseActLineItemNoCaption = 'Item No.';
        WhseActLineDescriptionCaption = 'Description';
        WhseActLineVariantCodeCaption = 'Variant Code';
        WhseActLineCrossDockInformationCaption = 'Cross-Dock Information';
        WhseActLineShelfNoCaption = 'Shelf No.';
        WhseActLineQtyBaseCaption = 'Quantity(Base)';
        WhseActLineQtytoHandleCaption = 'Quantity to Handle';
        WhseActLineUnitofMeasureCodeCaption = 'Unit of Measure Code';
        WhseActLineSourceNoCaption = 'Source No.';
    }

    trigger OnPreReport()
    begin
        PutAwayFilter := "Warehouse Activity Header".GetFilters;
    end;

    var
        Location: Record Location;
        TmpWhseActLine: Record "Warehouse Activity Line" temporary;
        PutAwayFilter: Text;
        BreakbulkFilter: Boolean;
        SumUpLines: Boolean;
        HideOptions: Boolean;
        InvtPutAway: Boolean;
        ShowLotSN: Boolean;
        Counter: Integer;
        CrossDockMark: Text[1];
        [InDataSet]
        BreakbulkEditable: Boolean;
        [InDataSet]
        SumUpLinesEditable: Boolean;
        CurrReportPAGENOCaptionLbl: label 'Page';
        PutawayListCaptionLbl: label 'Put-away List';
        WhseActLineDueDateCaptionLbl: label 'Due Date';
        QtyHandledCaptionLbl: label 'Quantity Handled';
        EmptyStringCaptionLbl: label '____________';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;


    procedure SetBreakbulkFilter(BreakbulkFilter2: Boolean)
    begin
        BreakbulkFilter := BreakbulkFilter2;
    end;


    procedure SetCrossDockMark(CrossDockInfo: Option)
    begin
        if CrossDockInfo <> 0 then
          CrossDockMark := '!'
        else
          CrossDockMark := '';
    end;


    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;
}

