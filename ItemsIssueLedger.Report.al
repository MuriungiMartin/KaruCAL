#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51222 "Items Issue Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Items Issue Ledger.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry";"Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type"=const("Negative Adjmt."));
            RequestFilterFields = "Item No.","Posting Date","Global Dimension 2 Code";
            column(ReportForNavId_7209; 7209)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Item_Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Item_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Item_Ledger_Entry_Quantity;Quantity)
            {
            }
            column(Item_Ledger_Entry__Item_No__;"Item No.")
            {
            }
            column(DeptName;DeptName)
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual__;"Cost Amount (Actual)")
            {
            }
            column(Value;Value)
            {
            }
            column(Item_Description;Item.Description)
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual___Control1102755007;"Cost Amount (Actual)")
            {
            }
            column(Value_Control1102755008;Value)
            {
            }
            column(Item_Ledger_Entry_Quantity_Control1102755009;Quantity)
            {
            }
            column(Stock_Issue_LedgerCaption;Stock_Issue_LedgerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Item_Ledger_Entry_QuantityCaption;FieldCaption(Quantity))
            {
            }
            column(Unit_PriceCaption;Unit_PriceCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption;FieldCaption("Item No."))
            {
            }
            column(Total_ValueCaption;Total_ValueCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Item_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 Dimm.Reset;
                 Dimm.SetRange(Dimm.Code,"Item Ledger Entry"."Global Dimension 2 Code");
                 if Dimm.Find('-') then begin
                 DeptName:=Dimm.Name;
                 end;
                "Item Ledger Entry".Quantity:="Item Ledger Entry".Quantity*-1;
                "Item Ledger Entry"."Cost Amount (Actual)":="Item Ledger Entry"."Cost Amount (Actual)"*-1;
                 Value:=Value*-1;
                Value:="Item Ledger Entry"."Cost Amount (Actual)"/"Item Ledger Entry".Quantity;
                CurrReport.CreateTotals(Value);

                Item.Reset;
                Item.SetRange(Item."No.","Item Ledger Entry"."Item No.");
                if Item.Find('-') then
;
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
        Dimm: Record "Dimension Value";
        UnitCost: Decimal;
        DeptName: Text[60];
        Item: Record Item;
        Value: Decimal;
        Stock_Issue_LedgerCaptionLbl: label 'Stock Issue Ledger';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DateCaptionLbl: label 'Date';
        DepartmentCaptionLbl: label 'Department';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Total_ValueCaptionLbl: label 'Total Value';
        DescriptionCaptionLbl: label 'Description';
}

