#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6529 "Item Tracking Navigate"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Tracking Navigate.rdlc';
    Caption = 'Item Tracking Navigate';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_5444; 5444)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(Head2View;CurrReport.PageNo = 1)
            {
            }
            column(Head3View;(CurrReport.PageNo = 1) and (SerialNoFilter <> ''))
            {
            }
            column(Head4View;(CurrReport.PageNo = 1) and (LotNoFilter <> ''))
            {
            }
            column(Head5View;(CurrReport.PageNo = 1) and (ItemNoFilter <> ''))
            {
            }
            column(Head6View;(CurrReport.PageNo = 1) and (VariantFilter <> ''))
            {
            }
            column(FormatedSerialNoFilter;Text001 + Format(SerialNoFilter))
            {
            }
            column(FormatedLotNoFilter;Text002 + Format(LotNoFilter))
            {
            }
            column(FormatedtemNoFilter;Text003 + Format(ItemNoFilter))
            {
            }
            column(FormatedVariantFilter;Text004 + Format(VariantFilter))
            {
            }
            column(ItemTrackingNavigateCaption;ItemTrackingNavigateCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(NavigateFiltersCaption;NavigateFiltersCaptionLbl)
            {
            }
            dataitem(RecordBuffer;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_8805; 8805)
                {
                }
                column(TempDocEntryNoOfRecords;TempDocEntry."No. of Records")
                {
                }
                column(TempDocEntryTableName;TempDocEntry."Table Name")
                {
                }
                column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                {
                }
                column(RecordCounter;RecordCounter)
                {
                }
                column(TempRecordBufferPrimaryKey;TempRecordBuffer."Primary Key")
                {
                }
                column(TempRecordBufferSerialNo;TempRecordBuffer."Serial No.")
                {
                }
                column(TempRecordBufferLotNo;TempRecordBuffer."Lot No.")
                {
                }
                column(TempDocEntryNoofRecordsCaption;TempDocEntryNoofRecordsCaptionLbl)
                {
                }
                column(TempDocEntryTableNameCaption;TempDocEntryTableNameCaptionLbl)
                {
                }
                column(TempRecordBufferSerialNoCaption;TempRecordBufferSerialNoCaptionLbl)
                {
                }
                column(TempRecordBufferLotNoCaption;TempRecordBufferLotNoCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                      if not TempRecordBuffer.Find('-') then
                        CurrReport.Break;
                    end else
                      if TempRecordBuffer.Next = 0 then
                        CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    TempRecordBuffer.SetCurrentkey("Table No.","Search Record ID");
                    TempRecordBuffer.SetRange("Table No.",TempDocEntry."Table ID");
                    RecordCounter := RecordCounter + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                  if not TempDocEntry.Find('-') then
                    CurrReport.Break;
                end else
                  if TempDocEntry.Next = 0 then
                    CurrReport.Break;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                RecordCounter := 0;
            end;
        }
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
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Table';
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
        Text001: label 'Serial No. : ';
        Text002: label 'Lot No. : ';
        TempDocEntry: Record "Document Entry" temporary;
        TempRecordBuffer: Record "Record Buffer" temporary;
        SerialNoFilter: Text;
        LotNoFilter: Text;
        ItemNoFilter: Text;
        VariantFilter: Text;
        Text003: label 'Item No. : ';
        Text004: label 'Variant Code. : ';
        PrintOnlyOnePerPage: Boolean;
        RecordCounter: Integer;
        ItemTrackingNavigateCaptionLbl: label 'Item Tracking Navigate';
        CurrReportPageNoCaptionLbl: label 'Page';
        NavigateFiltersCaptionLbl: label 'Navigate Filters';
        TempDocEntryNoofRecordsCaptionLbl: label 'No. of Records';
        TempDocEntryTableNameCaptionLbl: label 'Table Name';
        TempRecordBufferSerialNoCaptionLbl: label 'Serial No.';
        TempRecordBufferLotNoCaptionLbl: label 'Lot No.';


    procedure TransferDocEntries(var NewDocEntry: Record "Document Entry")
    var
        TempDocumentEntry: Record "Document Entry";
    begin
        TempDocumentEntry := NewDocEntry;
        NewDocEntry.Reset;
        if NewDocEntry.Find('-') then
          repeat
            TempDocEntry := NewDocEntry;
            TempDocEntry.Insert;
          until NewDocEntry.Next = 0;
        NewDocEntry := TempDocumentEntry;
    end;


    procedure TransferRecordBuffer(var NewRecordBuffer: Record "Record Buffer")
    begin
        NewRecordBuffer.Reset;
        if NewRecordBuffer.Find('-') then
          repeat
            TempRecordBuffer := NewRecordBuffer;
            TempRecordBuffer.Insert;
          until NewRecordBuffer.Next = 0;
    end;


    procedure TransferFilters(NewSerialNoFilter: Text;NewLotNoFilter: Text;NewItemNoFilter: Text;NewVariantFilter: Text)
    begin
        SerialNoFilter := NewSerialNoFilter;
        LotNoFilter := NewLotNoFilter;
        ItemNoFilter := NewItemNoFilter;
        VariantFilter := NewVariantFilter;
    end;
}

