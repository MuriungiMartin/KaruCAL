#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60138 "Prod. Order - Mat. Qty"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Prod. Order - Mat. Qty.rdlc';
    Caption = 'Prod. Order - Mat. Requisition';

    dataset
    {
        dataitem("Production Order";"Production Order")
        {
            DataItemTableView = sorting(Status,"No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status,"No.","Source Type","Source No.";
            column(ReportForNavId_4824; 4824)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ProdOrderTableCaptionFilter;TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(No_ProdOrder;"No.")
            {
            }
            column(Desc_ProdOrder;Description)
            {
            }
            column(SourceNo_ProdOrder;"Source No.")
            {
                IncludeCaption = true;
            }
            column(Status_ProdOrder;Status)
            {
            }
            column(Qty_ProdOrder;Quantity)
            {
                IncludeCaption = true;
            }
            column(Filter_ProdOrder;ProdOrderFilter)
            {
            }
            column(ProdOrderMaterialRqstnCapt;ProdOrderMaterialRqstnCaptLbl)
            {
            }
            column(CurrReportPageNoCapt;CurrReportPageNoCaptLbl)
            {
            }
            dataitem("Prod. Order Component";"Prod. Order Component")
            {
                DataItemLink = Status=field(Status),"Prod. Order No."=field("No.");
                DataItemTableView = sorting(Status,"Prod. Order No.","Prod. Order Line No.","Line No.");
                column(ReportForNavId_7771; 7771)
                {
                }
                column(ItemNo_ProdOrderComp;"Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ProdOrderComp;Description)
                {
                    IncludeCaption = true;
                }
                column(Qtyper_ProdOrderComp;"Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UOMCode_ProdOrderComp;"Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(RemainingQty_ProdOrderComp;"Remaining Quantity")
                {
                    IncludeCaption = true;
                }
                column(Scrap_ProdOrderComp;"Scrap %")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderComp;Format("Due Date"))
                {
                    IncludeCaption = false;
                }
                column(LocationCode_ProdOrderComp;"Location Code")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    with ReservationEntry do begin
                      SetCurrentkey("Source ID","Source Ref. No.","Source Type","Source Subtype");

                      SetRange("Source Type",Database::"Prod. Order Component");
                      SetRange("Source ID","Production Order"."No.");
                      SetRange("Source Ref. No.","Line No.");
                      SetRange("Source Subtype",Status);
                      SetRange("Source Batch Name",'');
                      SetRange("Source Prod. Order Line","Prod. Order Line No.");

                      if FindSet then begin
                        RemainingQtyReserved := 0;
                        repeat
                          if ReservationEntry2.Get("Entry No.",not Positive) then
                            if (ReservationEntry2."Source Type" = Database::"Prod. Order Line") and
                               (ReservationEntry2."Source ID" = "Prod. Order Component"."Prod. Order No.")
                            then
                              RemainingQtyReserved += ReservationEntry2."Quantity (Base)";
                        until Next = 0;
                        if "Prod. Order Component"."Remaining Qty. (Base)" = RemainingQtyReserved then
                          CurrReport.Skip;
                      end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Remaining Quantity",'<>0');
                end;
            }

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
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
        ProdOrderCompDueDateCapt = 'Due Date';
    }

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ProdOrderFilter: Text;
        RemainingQtyReserved: Decimal;
        ProdOrderMaterialRqstnCaptLbl: label 'Prod. Order - Material Requisition';
        CurrReportPageNoCaptLbl: label 'Page';
}

