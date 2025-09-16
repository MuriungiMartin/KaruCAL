#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1004 "Close Inventory Period - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Close Inventory Period - Test.rdlc';
    Caption = 'Close Inventory Period - Test';
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Inventory Period";"Inventory Period")
        {
            DataItemLinkReference = Header;
            DataItemTableView = sorting("Ending Date");
            RequestFilterFields = "Ending Date";
            column(ReportForNavId_7411; 7411)
            {
            }
            dataitem(Header;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_7745; 7745)
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(Name_InvtPeriod;"Inventory Period".Name)
                {
                }
                column(EndingDateFormat_InvtPeriod;Format("Inventory Period"."Ending Date"))
                {
                }
                column(ClosedFormat_InvtPeriod;Format("Inventory Period".Closed))
                {
                }
                column(PageNoCaption;PageCaptionLbl)
                {
                }
                column(CloseInventoryPeriodTestCaption;CloseInventPeriodTestCaptionLbl)
                {
                }
                column(ClosedCaption_InvtPeriod;"Inventory Period".FieldCaption(Closed))
                {
                }
                column(NameCaption_InvtPeriod;"Inventory Period".FieldCaption(Name))
                {
                }
                column(PeriodEndingDateCaption;EndingDateCaptionLbl)
                {
                }
                column(PeriodErrorText;PeriodErrorText)
                {
                }
                dataitem("Avg. Cost Adjmt. Entry Point";"Avg. Cost Adjmt. Entry Point")
                {
                    DataItemTableView = sorting("Item No.","Cost Is Adjusted","Valuation Date");
                    column(ReportForNavId_31; 31)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "Item No." <> LastItemNoStored then begin
                          StoreItemInErrorBuffer("Item No.",Database::"Avg. Cost Adjmt. Entry Point",Text008,'','',0);
                          LastItemNoStored := "Item No.";
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Cost Is Adjusted",false);
                        SetRange("Valuation Date",0D,"Inventory Period"."Ending Date");
                        LastItemNoStored := '';
                    end;
                }
                dataitem("Inventory Adjmt. Entry (Order)";"Inventory Adjmt. Entry (Order)")
                {
                    DataItemTableView = sorting("Cost is Adjusted","Allow Online Adjustment") where("Cost is Adjusted"=const(false),"Is Finished"=const(true));
                    column(ReportForNavId_30; 30)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        ValueEntry: Record "Value Entry";
                    begin
                        ValueEntry.SetCurrentkey("Order Type","Order No.","Order Line No.");
                        ValueEntry.SetRange("Order Type","Order Type");
                        ValueEntry.SetRange("Order No.","Order No.");
                        ValueEntry.SetRange("Order Line No.","Order Line No.");
                        case "Order Type" of
                          "order type"::Production:
                            ValueEntry.SetRange("Item Ledger Entry Type",ValueEntry."item ledger entry type"::Output);
                          "order type"::Assembly:
                            ValueEntry.SetRange("Item Ledger Entry Type",ValueEntry."item ledger entry type"::"Assembly Output");
                        end;
                        ValueEntry.SetRange("Valuation Date",0D,"Inventory Period"."Ending Date");

                        if not ValueEntry.IsEmpty then
                          StoreOrderInErrorBuffer("Inventory Adjmt. Entry (Order)");
                    end;
                }
                dataitem("Item Ledger Entry";"Item Ledger Entry")
                {
                    DataItemTableView = sorting("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                    column(ReportForNavId_40; 40)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        StoreItemInErrorBuffer("Item No.",Database::"Item Ledger Entry",StrSubstNo(Text003,"Entry No."),'','',0);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Open,true);
                        SetRange(Positive,false);
                        SetRange("Posting Date",0D,"Inventory Period"."Ending Date");
                    end;
                }
                dataitem(Item;Item)
                {
                    DataItemTableView = sorting("No.");
                    column(ReportForNavId_16; 16)
                    {
                    }
                    column(Description_Item;Description)
                    {
                    }
                    column(No_Item;"No.")
                    {
                    }
                    column(NoteText;NoteText)
                    {
                    }
                    column(DescriptionCaption_Item;FieldCaption(Description))
                    {
                    }
                    column(ItemHyperlink;ItemHyperlink)
                    {
                    }
                    column(NoCaption_Item;FieldCaption("No."))
                    {
                    }
                    dataitem(ItemErrorLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_20; 20)
                        {
                        }
                        column(TempItemErrorBufferErrorText;TempItemErrorBuffer."Error Text")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            GetErrorBuffer(TempItemErrorBuffer,Number = 1);
                        end;

                        trigger OnPreDataItem()
                        begin
                            TempItemErrorBuffer.SetRange("Source No.",Item."No.");
                            TempItemErrorBuffer.SetRange("Source Table",Database::"Avg. Cost Adjmt. Entry Point");
                            SetRange(Number,1,TempItemErrorBuffer.Count);
                        end;
                    }
                    dataitem(ItemOrderErrorLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_18; 18)
                        {
                        }
                        column(ItemOrderErrorLoopErrorText;TempItemErrorBuffer."Error Text")
                        {
                        }
                        column(ErrorHyperlink;ErrorHyperlink)
                        {
                        }
                        column(ErrorHyperlinkAnchor;ErrorHyperlinkAnchor)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            GetErrorBuffer(TempItemErrorBuffer,Number = 1);

                            if TempItemErrorBufferBookmark.Get(TempItemErrorBuffer."Error No.") then begin
                              ErrorHyperlink := GenerateHyperlink(TempItemErrorBufferBookmark."Error Text",TempItemErrorBufferBookmark."Source Ref. No.");
                              ErrorHyperlinkAnchor := TempItemErrorBufferBookmark."Source No." + ':';
                            end else begin
                              ErrorHyperlink := '';
                              ErrorHyperlinkAnchor := '';
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            TempItemErrorBuffer.SetRange("Source No.",Item."No.");
                            TempItemErrorBuffer.SetRange("Source Table",Database::"Inventory Adjmt. Entry (Order)");
                            SetRange(Number,1,TempItemErrorBuffer.Count);
                        end;
                    }
                    dataitem(ItemLedgErrorLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_22; 22)
                        {
                        }
                        column(ItemLedgErrorLoopErrorText;TempItemErrorBuffer."Error Text")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            GetErrorBuffer(TempItemErrorBuffer,Number = 1);
                        end;

                        trigger OnPreDataItem()
                        begin
                            TempItemErrorBuffer.SetRange("Source No.",Item."No.");
                            TempItemErrorBuffer.SetRange("Source Table",Database::"Item Ledger Entry");
                            if not TempItemErrorBuffer.IsEmpty and (NoteText = '') then
                              NoteText := Text004;
                            SetRange(Number,1,TempItemErrorBuffer.Count);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Item);
                        ItemHyperlink := GenerateHyperlink(Format(RecRef.RecordId,0,10),Page::"Item Card");
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempItemErrorBuffer.Reset;
                        TempItemErrorBuffer.DeleteAll;
                        TempItemErrorBufferBookmark.Reset;
                        TempItemErrorBufferBookmark.DeleteAll;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Item2.MarkedOnly(true);
                        Copy(Item2);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Ending Date" = 0D then
                  PeriodErrorText := StrSubstNo(Text001,FieldCaption("Ending Date"),Name)
                else
                  PeriodErrorText := '';
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
        Text001: label '%1 is missing in Inventory Period %2.', Comment='%1 = FIELDCAPTION("Ending Date"), %2 = "Name"';
        Item2: Record Item;
        TempItemErrorBuffer: Record "Error Buffer" temporary;
        TempItemErrorBufferBookmark: Record "Error Buffer" temporary;
        PeriodErrorText: Text[250];
        NoteText: Text[250];
        ItemHyperlink: Text;
        ErrorHyperlink: Text;
        ErrorHyperlinkAnchor: Code[21];
        Text003: label 'Item Ledger Entry %1 is open.*';
        Text004: label '*Close the open Item Ledger Entry, for example by posting related inbound transactions, in order to resolve the negative inventory and thereby allow the Inventory Period to be closed.';
        PageCaptionLbl: label 'Page';
        CloseInventPeriodTestCaptionLbl: label 'Close Inventory Period - Test';
        EndingDateCaptionLbl: label 'Ending Date';
        Text008: label 'The item has entries in this period that have not been adjusted.';
        Text009: label 'This %1 Order has not been adjusted.';
        LastItemNoStored: Code[20];
        Text010: label 'Posted Assembly';

    local procedure StoreItemInErrorBuffer(ItemNo: Code[20];SourceTableNo: Integer;ErrorText: Text[250];Recordbookmark: Text[250];HyperlinkSourceRecNo: Code[20];HyperlinkPageID: Integer)
    begin
        TempItemErrorBuffer."Error No." += 1;
        TempItemErrorBuffer."Error Text" := ErrorText;
        TempItemErrorBuffer."Source Table" := SourceTableNo;
        TempItemErrorBuffer."Source No." := ItemNo;
        TempItemErrorBuffer.Insert;

        if Recordbookmark <> '' then begin
          TempItemErrorBufferBookmark."Error No." := TempItemErrorBuffer."Error No.";
          TempItemErrorBufferBookmark."Error Text" := Recordbookmark;
          TempItemErrorBufferBookmark."Source No." := HyperlinkSourceRecNo;
          TempItemErrorBufferBookmark."Source Ref. No." := HyperlinkPageID;
          TempItemErrorBufferBookmark.Insert;
        end;

        if ItemNo <> '' then begin
          Item2.Get(ItemNo);
          Item2.Mark(true);
        end;
    end;

    local procedure StoreOrderInErrorBuffer(InventoryAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)")
    var
        ProductionOrder: Record "Production Order";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        RecRef: RecordRef;
        Bookmark: Text[250];
    begin
        case InventoryAdjmtEntryOrder."Order Type" of
          InventoryAdjmtEntryOrder."order type"::Production:
            begin
              ProductionOrder.Get(ProductionOrder.Status::Finished,InventoryAdjmtEntryOrder."Order No.");
              RecRef.GetTable(ProductionOrder);
              Bookmark := Format(RecRef.RecordId,0,10);
              StoreItemInErrorBuffer(InventoryAdjmtEntryOrder."Item No.",Database::"Inventory Adjmt. Entry (Order)",
                StrSubstNo(Text009,InventoryAdjmtEntryOrder."Order Type"),Bookmark,InventoryAdjmtEntryOrder."Order No.",
                Page::"Finished Production Order");
            end;
          InventoryAdjmtEntryOrder."order type"::Assembly:
            begin
              PostedAssemblyHeader.SetRange("Order No.",InventoryAdjmtEntryOrder."Order No.");
              if PostedAssemblyHeader.FindSet then
                repeat
                  RecRef.GetTable(PostedAssemblyHeader);
                  Bookmark := Format(RecRef.RecordId,0,10);
                  StoreItemInErrorBuffer(InventoryAdjmtEntryOrder."Item No.",Database::"Inventory Adjmt. Entry (Order)",
                    StrSubstNo(Text009,Text010),Bookmark,PostedAssemblyHeader."No.",Page::"Posted Assembly Order");
                until PostedAssemblyHeader.Next = 0;
            end;
        end;
    end;

    local procedure GetErrorBuffer(var TempItemErrorBuffer: Record "Error Buffer" temporary;GetFirstRecord: Boolean)
    begin
        if GetFirstRecord then
          TempItemErrorBuffer.FindSet
        else
          TempItemErrorBuffer.Next;
    end;

    local procedure GenerateHyperlink(Bookmark: Text[250];PageID: Integer): Text
    begin
        if Bookmark = '' then
          exit('');

        // Generates a URL such as dynamicsnav://hostname:port/instance/company/runpage?page=pageId&bookmark=recordId&mode=View.
        exit(GetUrl(CurrentClientType,COMPANYNAME,Objecttype::Page,PageID) +
          StrSubstNo('&amp;bookmark=%1&mode=View',Bookmark));
    end;
}

