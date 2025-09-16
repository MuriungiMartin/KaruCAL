#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5806 "Item Charges - Specification"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Charges - Specification.rdlc';
    Caption = 'Item Charges - Specification';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Value Entry";"Value Entry")
        {
            DataItemTableView = sorting("Item Charge No.","Inventory Posting Group","Item No.") where("Item Charge No."=filter(<>''));
            RequestFilterFields = "Item No.","Posting Date","Inventory Posting Group";
            column(ReportForNavId_8894; 8894)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ReportTitle;ReportTitle)
            {
            }
            column(ValueEntryCaption;TableCaption + ': ' + ValueEntryFilter)
            {
            }
            column(SourceTypePurch;SourceTypePurch)
            {
            }
            column(ValueEntryPostingDate;ValueEntryPostingDate)
            {
            }
            column(ValueEntryDocNo;ValueEntryDocNo)
            {
            }
            column(ValueEntrySourceType;ValueEntrySourceType)
            {
            }
            column(ValueEntrySourceNo;ValueEntrySourceNo)
            {
            }
            column(ValueEntryQuantity;ValueEntryQuantity)
            {
            }
            column(ValueEntryItemNo;ValueEntryItemNo)
            {
            }
            column(ValueEntryFilter;ValueEntryFilter)
            {
            }
            column(ItemChargeNo_ValueEntry;"Item Charge No.")
            {
            }
            column(InventoryPostingGroup;Text004 + ': ' + "Inventory Posting Group")
            {
            }
            column(PostingDate_ValueEntry;Format("Posting Date"))
            {
            }
            column(DocumentNo_ValueEntry;"Document No.")
            {
            }
            column(SourceType_ValueEntry;"Source Type")
            {
            }
            column(SourceNo_ValueEntry;"Source No.")
            {
            }
            column(ValuedQuantity_ValueEntry;"Valued Quantity")
            {
            }
            column(CostAmtActual_ValueEntry;"Cost Amount (Actual)")
            {
            }
            column(ItemNo_ValueEntry;"Item No.")
            {
            }
            column(PrintDetails;PrintDetails)
            {
            }
            column(SalesAmtActual_ValueEntry;"Sales Amount (Actual)")
            {
            }
            column(GroupSubtotaItemNo;"Item No." + ' : ' + Text005)
            {
            }
            column(ValEntyCostAmtActSalesAct;"Cost Amount (Actual)" + "Sales Amount (Actual)")
            {
            }
            column(ItemDescription;ItemDescription)
            {
            }
            column(SubTotalInvPostingGroup;Text006 + ': ' + "Inventory Posting Group")
            {
            }
            column(GroupTotalItemChargeNo;Text007 + ': ' + "Item Charge No.")
            {
            }
            column(InvPostingGrp_ValueEntry;"Inventory Posting Group")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ValueEntryCostAmtActlCptn;ValueEntryCostAmtActlCptnLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if PrintDetails then begin
                  ValueEntryItemNo := FieldCaption("Item No.");
                  ValueEntryPostingDate := FieldCaption("Posting Date");
                  ValueEntryDocNo := FieldCaption("Document No.");
                  ValueEntrySourceType := FieldCaption("Source Type");
                  ValueEntrySourceNo := FieldCaption("Source No.");
                  ValueEntryQuantity := FieldCaption("Valued Quantity");
                end;
                if Item.Get("Item No.") then
                  ItemDescription := Item.Description;
            end;

            trigger OnPreDataItem()
            begin
                if SourceType = Sourcetype::Sale then begin
                  ReportTitle := ReportTitle + Text002;
                  SetRange("Item Ledger Entry Type","item ledger entry type"::Sale);
                end else begin
                  ReportTitle := ReportTitle + Text003;
                  SetRange("Item Ledger Entry Type","item ledger entry type"::Purchase);
                end;

                CurrReport.CreateTotals("Cost Amount (Actual)","Valued Quantity","Sales Amount (Actual)");
                SourceTypePurch := SourceType = Sourcetype::Purchase;
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
                    field(PrintDetails;PrintDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Details';
                    }
                    field(SourceType;SourceType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Source Type';
                        OptionCaption = 'Sale,Purchase';
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

    trigger OnPreReport()
    begin
        ValueEntryFilter := "Value Entry".GetFilters;

        ReportTitle := Text000;
        if PrintDetails then
          ReportTitle := Text001;
    end;

    var
        Text000: label 'Item Charges - Overview';
        Text001: label 'Item Charges - Specification';
        Text002: label ' (Sales)';
        Text003: label ' (Purchases)';
        Text004: label 'Inventory Posting Group';
        Text005: label 'Group Subtotal';
        Text006: label 'Inventory Posting Group Subtotal';
        Text007: label 'Group Total';
        Item: Record Item;
        PrintDetails: Boolean;
        ReportTitle: Text[100];
        ValueEntryFilter: Text;
        ValueEntryItemNo: Text[80];
        ValueEntryPostingDate: Text[80];
        ValueEntryDocNo: Text[80];
        ValueEntrySourceType: Text[80];
        ValueEntrySourceNo: Text[80];
        ValueEntryQuantity: Text[80];
        ItemDescription: Text[50];
        SourceType: Option Sale,Purchase;
        SourceTypePurch: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        ValueEntryCostAmtActlCptnLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';


    procedure InitializeRequest(NewPrintDetails: Boolean;NewSourceType: Option)
    begin
        PrintDetails := NewPrintDetails;
        SourceType := NewSourceType;
    end;
}

