#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10163 "Vendor Purchases by Item"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor Purchases by Item.rdlc';
    Caption = 'Vendor Purchases by Item';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Date Filter","Location Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(ItemLedgEntryFilter;ItemLedgEntryFilter)
            {
            }
            column(IncludeReturns;IncludeReturns)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Item_Ledger_Entry__TABLECAPTION__________ItemLedgEntryFilter;"Item Ledger Entry".TableCaption + ': ' + ItemLedgEntryFilter)
            {
            }
            column(PurchasesText;PurchasesText)
            {
            }
            column(QtyText;QtyText)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(FIELDCAPTION__Base_Unit_of_Measure_____________Base_Unit_of_Measure_;FieldCaption("Base Unit of Measure") + ': ' + "Base Unit of Measure")
            {
            }
            column(ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount_;ValueEntry."Purchase Amount (Actual)" + ValueEntry."Discount Amount")
            {
            }
            column(ValueEntry__Discount_Amount_;ValueEntry."Discount Amount")
            {
            }
            column(ValueEntry__Purchase_Amount__Actual__;ValueEntry."Purchase Amount (Actual)")
            {
            }
            column(Item_Date_Filter;"Date Filter")
            {
            }
            column(Item_Location_Filter;"Location Filter")
            {
            }
            column(Item_Variant_Filter;"Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Vendor_Purchases_by_ItemCaption;Vendor_Purchases_by_ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Returns_are_included_in_Purchase_Quantities_Caption;Returns_are_included_in_Purchase_Quantities_CaptionLbl)
            {
            }
            column(Returns_are_not_included_in_Purchase_Quantities_Caption;Returns_are_not_included_in_Purchase_Quantities_CaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Source_No__Caption;Item_Ledger_Entry__Source_No__CaptionLbl)
            {
            }
            column(Vend_NameCaption;Vend_NameCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Invoiced_Quantity_Caption;"Item Ledger Entry".FieldCaption("Invoiced Quantity"))
            {
            }
            column(ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control29Caption;ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control29CaptionLbl)
            {
            }
            column(ValueEntry__Discount_Amount__Control30Caption;ValueEntry__Discount_Amount__Control30CaptionLbl)
            {
            }
            column(ValueEntry__Purchase_Amount__Actual___Control31Caption;ValueEntry__Purchase_Amount__Actual___Control31CaptionLbl)
            {
            }
            column(Net_Average_Caption;Net_Average_CaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No."),"Posting Date"=field("Date Filter"),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Entry Type","Item No.","Variant Code","Source Type","Source No.","Posting Date") where("Entry Type"=const(Purchase),"Source Type"=const(Vendor));
                RequestFilterFields = "Source No.";
                column(ReportForNavId_7209; 7209)
                {
                }
                column(FIELDCAPTION__Variant_Code_____________Variant_Code_;FieldCaption("Variant Code") + ': ' + "Variant Code")
                {
                }
                column(Item_Ledger_Entry__Source_No__;"Source No.")
                {
                }
                column(Vend_Name;Vend.Name)
                {
                }
                column(Item_Ledger_Entry__Invoiced_Quantity_;"Invoiced Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control29;ValueEntry."Purchase Amount (Actual)" + ValueEntry."Discount Amount")
                {
                }
                column(ValueEntry__Discount_Amount__Control30;ValueEntry."Discount Amount")
                {
                }
                column(ValueEntry__Purchase_Amount__Actual___Control31;ValueEntry."Purchase Amount (Actual)")
                {
                }
                column(Net_Average_;"Net Average")
                {
                    DecimalPlaces = 2:5;
                }
                column(Text008_________FIELDCAPTION__Variant_Code_____________Variant_Code_;Text008 + ' ' + FieldCaption("Variant Code") + ': ' + "Variant Code")
                {
                }
                column(Net_Average__Control9;"Net Average")
                {
                    DecimalPlaces = 2:5;
                }
                column(ValueEntry__Purchase_Amount__Actual___Control19;ValueEntry."Purchase Amount (Actual)")
                {
                }
                column(ValueEntry__Discount_Amount__Control25;ValueEntry."Discount Amount")
                {
                }
                column(ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control39;ValueEntry."Purchase Amount (Actual)" + ValueEntry."Discount Amount")
                {
                }
                column(Item_Ledger_Entry__Invoiced_Quantity__Control40;"Invoiced Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(Item_Ledger_Entry__Invoiced_Quantity__Control34;"Invoiced Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control35;ValueEntry."Purchase Amount (Actual)" + ValueEntry."Discount Amount")
                {
                }
                column(ValueEntry__Discount_Amount__Control36;ValueEntry."Discount Amount")
                {
                }
                column(ValueEntry__Purchase_Amount__Actual___Control37;ValueEntry."Purchase Amount (Actual)")
                {
                }
                column(Net_Average__Control38;"Net Average")
                {
                    DecimalPlaces = 2:5;
                }
                column(Text008_________FIELDCAPTION__Item_No______________Item_No__;Text008 + ' ' + FieldCaption("Item No.") + ': ' + "Item No.")
                {
                }
                column(Item_Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Item_Ledger_Entry_Variant_Code;"Variant Code")
                {
                }
                column(Item_Ledger_Entry_Item_No_;"Item No.")
                {
                }
                column(Item_Ledger_Entry_Posting_Date;"Posting Date")
                {
                }
                column(Item_Ledger_Entry_Location_Code;"Location Code")
                {
                }
                column(Item_Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }
                column(Item_Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    with ValueEntry do begin
                      SetRange("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
                      CalcSums("Purchase Amount (Actual)","Discount Amount");
                    end;
                    if "Source No." <> '' then
                      Vend.Get("Source No.")
                    else
                      Clear(Vend);
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Invoiced Quantity",ValueEntry."Purchase Amount (Actual)",ValueEntry."Discount Amount");
                    if IncludeReturns then
                      SetFilter("Invoiced Quantity",'<>0')
                    else
                      SetFilter("Invoiced Quantity",'>0');

                    with ValueEntry do begin
                      Reset;
                      SetCurrentkey("Item Ledger Entry No.","Entry Type");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Purchases (Qty.)","Purchases (LCY)");
                if MinPurchases <> 0 then
                  if "Purchases (LCY)" <= MinPurchases then
                    CurrReport.Skip;
                if MaxPurchases <> 0 then
                  if "Purchases (LCY)" >= MaxPurchases then
                    CurrReport.Skip;
                if MinQty <> 0 then
                  if "Purchases (Qty.)" <= MinQty then
                    CurrReport.Skip;
                if MaxQty <> 0 then
                  if "Purchases (Qty.)" >= MaxQty then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ValueEntry."Purchase Amount (Actual)",ValueEntry."Discount Amount");
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
                    field(IncludeReturns;IncludeReturns)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Returns';
                    }
                    group("Items with Net Purch. ($)")
                    {
                        Caption = 'Items with Net Purch. ($)';
                        field(MinPurchases;MinPurchases)
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Greater than';
                        }
                        field(MaxPurchases;MaxPurchases)
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Less than';
                        }
                    }
                    group("Items with Net Purch. (Qty)")
                    {
                        Caption = 'Items with Net Purch. (Qty)';
                        field(MinQty;MinQty)
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Greater than';
                        }
                        field(MaxQty;MaxQty)
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Less than';
                        }
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
        CompanyInformation.Get;
        ItemFilter := Item.GetFilters;
        PeriodText := "Item Ledger Entry".GetFilter("Posting Date");
        "Item Ledger Entry".SetRange("Posting Date");
        ItemLedgEntryFilter := "Item Ledger Entry".GetFilters;
        if PeriodText = '' then
          SubTitle := Text000
        else
          SubTitle := Text001 + ' ' + PeriodText;
        if MinPurchases = 0 then
          PurchasesText := ''
        else
          PurchasesText := StrSubstNo(Text002,MinPurchases);
        if MaxPurchases <> 0 then begin
          if PurchasesText = '' then
            PurchasesText := StrSubstNo(Text003,MaxPurchases)
          else
            PurchasesText := PurchasesText + StrSubstNo(Text004,MaxPurchases);
        end;
        if MinQty = 0 then
          QtyText := ''
        else
          QtyText := StrSubstNo(Text005,MinQty);
        if MaxQty <> 0 then begin
          if QtyText = '' then
            QtyText := StrSubstNo(Text006,MaxQty)
          else
            QtyText := QtyText + StrSubstNo(Text007,MaxQty);
        end;
    end;

    var
        Vend: Record Vendor;
        CompanyInformation: Record "Company Information";
        ValueEntry: Record "Value Entry";
        IncludeReturns: Boolean;
        MinPurchases: Decimal;
        MaxPurchases: Decimal;
        MinQty: Decimal;
        MaxQty: Decimal;
        SubTitle: Text;
        PurchasesText: Text[132];
        QtyText: Text[132];
        "Net Average": Decimal;
        PeriodText: Text;
        ItemFilter: Text;
        ItemLedgEntryFilter: Text;
        Text000: label 'All Purchases to Date';
        Text001: label 'Purchases during the Period';
        Text002: label 'Items with Net Purchases of more than $%1';
        Text003: label 'Items with Net Purchases of less than $%1';
        Text004: label ' and less than $%1';
        Text005: label 'Items with Net Purchase Quantity more than %1';
        Text006: label 'Items with Net Purchase Quantity less than %1';
        Text007: label ' and less than %1';
        Text008: label 'Total for';
        Vendor_Purchases_by_ItemCaptionLbl: label 'Vendor Purchases by Item';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Returns_are_included_in_Purchase_Quantities_CaptionLbl: label 'Returns are included in Purchase Quantities.';
        Returns_are_not_included_in_Purchase_Quantities_CaptionLbl: label 'Returns are not included in Purchase Quantities.';
        Item_Ledger_Entry__Source_No__CaptionLbl: label 'Vendor No.';
        Vend_NameCaptionLbl: label 'Name';
        ValueEntry__Purchase_Amount__Actual_____ValueEntry__Discount_Amount__Control29CaptionLbl: label 'Amount Before Discount';
        ValueEntry__Discount_Amount__Control30CaptionLbl: label 'Discount Amount';
        ValueEntry__Purchase_Amount__Actual___Control31CaptionLbl: label 'Amount';
        Net_Average_CaptionLbl: label 'Net Average';
        Report_TotalCaptionLbl: label 'Report Total';


    procedure CalcNetAverage()
    begin
        if "Item Ledger Entry"."Invoiced Quantity" <> 0 then
          "Net Average" := ValueEntry."Purchase Amount (Actual)" / "Item Ledger Entry"."Invoiced Quantity"
        else
          "Net Average" := 0;
    end;
}

