#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5752 "Picking List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Picking List.rdlc';
    Caption = 'Picking List';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Activity Header";"Warehouse Activity Header")
        {
            DataItemTableView = sorting(Type,"No.") where(Type=filter(Pick|"Invt. Pick"));
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
                column(PickFilter;PickFilter)
                {
                }
                column(DirectedPutAwayAndPick;Location."Directed Put-away and Pick")
                {
                }
                column(BinMandatory;Location."Bin Mandatory")
                {
                }
                column(InvtPick;InvtPick)
                {
                }
                column(ShowLotSN;ShowLotSN)
                {
                }
                column(SumUpLines;SumUpLines)
                {
                }
                column(No_WhseActivHeaderCaption;"Warehouse Activity Header".FieldCaption("No."))
                {
                }
                column(WhseActivHeaderCaption;"Warehouse Activity Header".TableCaption + ': ' + PickFilter)
                {
                }
                column(LoctnCode_WhseActivHeader;"Warehouse Activity Header"."Location Code")
                {
                }
                column(SortingMtd_WhseActivHeader;"Warehouse Activity Header"."Sorting Method")
                {
                }
                column(AssgUserID_WhseActivHeader;"Warehouse Activity Header"."Assigned User ID")
                {
                }
                column(SourcDocument_WhseActLine;"Warehouse Activity Line"."Source Document")
                {
                }
                column(LoctnCode_WhseActivHeaderCaption;"Warehouse Activity Header".FieldCaption("Location Code"))
                {
                }
                column(SortingMtd_WhseActivHeaderCaption;"Warehouse Activity Header".FieldCaption("Sorting Method"))
                {
                }
                column(AssgUserID_WhseActivHeaderCaption;"Warehouse Activity Header".FieldCaption("Assigned User ID"))
                {
                }
                column(SourcDocument_WhseActLineCaption;"Warehouse Activity Line".FieldCaption("Source Document"))
                {
                }
                column(SourceNo_WhseActLineCaption;WhseActLine.FieldCaption("Source No."))
                {
                }
                column(ShelfNo_WhseActLineCaption;WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(VariantCode_WhseActLineCaption;WhseActLine.FieldCaption("Variant Code"))
                {
                }
                column(Description_WhseActLineCaption;WhseActLine.FieldCaption(Description))
                {
                }
                column(ItemNo_WhseActLineCaption;WhseActLine.FieldCaption("Item No."))
                {
                }
                column(UOMCode_WhseActLineCaption;WhseActLine.FieldCaption("Unit of Measure Code"))
                {
                }
                column(QtytoHandle_WhseActLineCaption;WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(QtyBase_WhseActLineCaption;WhseActLine.FieldCaption("Qty. (Base)"))
                {
                }
                column(DestinatnType_WhseActLineCaption;WhseActLine.FieldCaption("Destination Type"))
                {
                }
                column(DestinationNo_WhseActLineCaption;WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(ZoneCode_WhseActLineCaption;WhseActLine.FieldCaption("Zone Code"))
                {
                }
                column(BinCode_WhseActLineCaption;WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(ActionType_WhseActLineCaption;WhseActLine.FieldCaption("Action Type"))
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                column(PickingListCaption;PickingListCaptionLbl)
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
                            if "Warehouse Activity Header"."Sorting Method" =
                               "Warehouse Activity Header"."sorting method"::"Ship-To"
                            then begin
                              TmpWhseActLine.SetRange("Destination Type","Destination Type");
                              TmpWhseActLine.SetRange("Destination No.","Destination No.")
                            end;
                            if TmpWhseActLine.FindFirst then begin
                              TmpWhseActLine."Qty. (Base)" := TmpWhseActLine."Qty. (Base)" + "Qty. (Base)";
                              TmpWhseActLine."Qty. to Handle" := TmpWhseActLine."Qty. to Handle" + "Qty. to Handle";
                              TmpWhseActLine."Source No." := '';
                              if "Warehouse Activity Header"."Sorting Method" <>
                                 "Warehouse Activity Header"."sorting method"::"Ship-To"
                              then begin
                                TmpWhseActLine."Destination Type" := TmpWhseActLine."destination type"::" ";
                                TmpWhseActLine."Destination No." := '';
                              end;
                              TmpWhseActLine.Modify;
                            end else begin
                              TmpWhseActLine := "Warehouse Activity Line";
                              TmpWhseActLine.Insert;
                              Mark(true);
                            end;
                          end;
                        end else
                          Mark(true);
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
                    column(SourceNo_WhseActLine;"Source No.")
                    {
                    }
                    column(FormatSourcDocument_WhseActLine;Format("Source Document"))
                    {
                    }
                    column(ShelfNo_WhseActLine;"Shelf No.")
                    {
                    }
                    column(ItemNo_WhseActLine;"Item No.")
                    {
                    }
                    column(Description_WhseActLine;Description)
                    {
                    }
                    column(VariantCode_WhseActLine;"Variant Code")
                    {
                    }
                    column(UOMCode_WhseActLine;"Unit of Measure Code")
                    {
                    }
                    column(DueDate_WhseActLine;Format("Due Date"))
                    {
                    }
                    column(QtytoHandle_WhseActLine;"Qty. to Handle")
                    {
                    }
                    column(QtyBase_WhseActLine;"Qty. (Base)")
                    {
                    }
                    column(DestinatnType_WhseActLine;"Destination Type")
                    {
                    }
                    column(DestinationNo_WhseActLine;"Destination No.")
                    {
                    }
                    column(ZoneCode_WhseActLine;"Zone Code")
                    {
                    }
                    column(BinCode_WhseActLine;"Bin Code")
                    {
                    }
                    column(ActionType_WhseActLine;"Action Type")
                    {
                    }
                    column(LotNo_WhseActLine;"Lot No.")
                    {
                    }
                    column(SerialNo_WhseActLine;"Serial No.")
                    {
                    }
                    column(LotNo_WhseActLineCaption;FieldCaption("Lot No."))
                    {
                    }
                    column(SerialNo_WhseActLineCaption;FieldCaption("Serial No."))
                    {
                    }
                    column(LineNo_WhseActLine;"Line No.")
                    {
                    }
                    column(BinRanking_WhseActLine;"Bin Ranking")
                    {
                    }
                    column(EmptyStringCaption;EmptyStringCaptionLbl)
                    {
                    }
                    dataitem(WhseActLine2;"Warehouse Activity Line")
                    {
                        DataItemLink = "Activity Type"=field("Activity Type"),"No."=field("No."),"Bin Code"=field("Bin Code"),"Item No."=field("Item No."),"Action Type"=field("Action Type"),"Variant Code"=field("Variant Code"),"Unit of Measure Code"=field("Unit of Measure Code"),"Due Date"=field("Due Date");
                        DataItemLinkReference = WhseActLine;
                        DataItemTableView = sorting("Activity Type","No.","Bin Code","Breakbulk No.","Action Type");
                        column(ReportForNavId_4019; 4019)
                        {
                        }
                        column(LotNo_WhseActLine2;"Lot No.")
                        {
                        }
                        column(SerialNo_WhseActLine2;"Serial No.")
                        {
                        }
                        column(QtyBase_WhseActLine2;"Qty. (Base)")
                        {
                        }
                        column(QtytoHandle_WhseActLine2;"Qty. to Handle")
                        {
                        }
                        column(LineNo_WhseActLine2;"Line No.")
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
                InvtPick := Type = Type::"Invt. Pick";

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
    }

    trigger OnPreReport()
    begin
        PickFilter := "Warehouse Activity Header".GetFilters;
    end;

    var
        Location: Record Location;
        TmpWhseActLine: Record "Warehouse Activity Line" temporary;
        PickFilter: Text;
        BreakbulkFilter: Boolean;
        SumUpLines: Boolean;
        HideOptions: Boolean;
        InvtPick: Boolean;
        ShowLotSN: Boolean;
        Counter: Integer;
        [InDataSet]
        BreakbulkEditable: Boolean;
        [InDataSet]
        SumUpLinesEditable: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        PickingListCaptionLbl: label 'Picking List';
        WhseActLineDueDateCaptionLbl: label 'Due Date';
        QtyHandledCaptionLbl: label 'Qty. Handled';
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


    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;
}

